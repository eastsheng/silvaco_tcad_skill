param(
    [Parameter(Mandatory = $true)]
    [string[]]$Root,
    [string[]]$Categories,
    [ValidateSet('Object', 'Json', 'Markdown')]
    [string]$Format = 'Object'
)

$ErrorActionPreference = 'Stop'

function Get-IndexMetadata([string]$indexPath) {
    $map = @{}
    if (-not (Test-Path -LiteralPath $indexPath)) { return $map }
    $raw = Get-Content -Raw -LiteralPath $indexPath
    $blocks = [regex]::Matches($raw, '(?ms)^\{subsection\}\s+([^:]+?)\s*:\s*(.+?)\s*$\s*(.*?)(?=^\{subsection\}|\z)')
    foreach ($block in $blocks) {
        $body = $block.Groups[3].Value
        $requires = if ($body -match '(?im)^Requires:\s*(.+?)\s*$') { $matches[1].Trim() } else { '' }
        $minimum = if ($body -match '(?im)^Minimum Versions:\s*(.+?)\s*$') { $matches[1].Trim() } else { '' }
        $map[$block.Groups[1].Value.Trim()] = [pscustomobject]@{
            Title = $block.Groups[2].Value.Trim()
            Requires = $requires
            MinimumVersions = $minimum
        }
    }
    return $map
}

function Get-DeviceClass([string]$category, [string]$name, [string]$title, [string]$text) {
    $haystack = if ([string]::IsNullOrWhiteSpace($title)) { "$category $name $text" } else { "$category $name $title" }
    $classes = New-Object System.Collections.Generic.List[string]
    $mosExcluded = $title -match '(?i)\b(?:(?:n|p)?mos capacitor|vacuum triode|spice only)\b'
    $mosCategory = -not $mosExcluded -and ($category -eq 'mos1' -or ($category -eq 'mos2' -and $title -notmatch '(?i)vacuum triode'))
    if (-not $mosExcluded -and ($mosCategory -or $haystack -match '(?i)\b(mosf+et|nmos|pmos|dmos|ldmos|umos|finfet|coolmos|misfet|iemosfet)\b')) { $classes.Add('MOSFET') }
    if ($haystack -match '(?i)\b(igbt|bigt|insulated[ -]gate bipolar)\b') { $classes.Add('IGBT') }
    if ($category -in @('hemt', 'ganfet') -or $haystack -match '(?i)\b(hemt|hfet|phemt|cavet|algan/gan)\b') { $classes.Add('HEMT') }
    return @($classes | Sort-Object -Unique)
}

function Get-Features([string]$title, [string]$text) {
    $haystack = "$title $text"
    $patterns = [ordered]@{
        'transfer' = '(?i)id.?vgs|id.?vg|transfer|threshold|sub.?threshold|dibl|body effect'
        'output' = '(?i)id.?vds|id.?vd|ic.?vce|output|on-state|forward characteristics'
        'breakdown' = '(?i)breakdown|ionization integral|\bbv\b|gate rupture|segr'
        'latch-up/snapback' = '(?i)latch.?up|snapback|second breakdown|current filament'
        'self-heating/thermal' = '(?i)lattice heat|self.?heat|electro.?thermal|thermal|temperature'
        'transient/switching' = '(?i)transient|turn.?on|turn.?off|switch|gate charg|large signal'
        'AC/CV/RF' = '(?i)\bac\b|c-v|capacit|high frequency|rf|s.?parameter'
        'reliability/traps' = '(?i)reliab|nbti|degrad|hysteresis|trap|current collapse|hot electron'
        'polarization/stress' = '(?i)polarization|piezo|intrinsic stress'
        'process/structure' = '(?i)go athena|go devedit|process|implant|etch|deposit|oxid|3d|trench|finfet'
        'mixed-mode' = '(?i)go atlas.*\.begin|mixedmode|\.tran|\.dc'
    }
    $features = foreach ($entry in $patterns.GetEnumerator()) {
        if ($haystack -match $entry.Value) { $entry.Key }
    }
    return @($features)
}

function Get-Dependencies([System.IO.FileInfo]$deck, [string]$text, [string[]]$generatedByExample) {
    $tokens = New-Object System.Collections.Generic.List[string]
    $generated = @([regex]::Matches($text, '(?i)\b(?:out|outf|outfile)\s*=\s*["'']?([^\s"'']+)') | ForEach-Object { $_.Groups[1].Value.TrimEnd(',', ';') })
    $patterns = @(
        '(?i)\b(?:infile|master)\s*=\s*["'']?([^\s"'']+)',
        '(?i)\b(?:mesh|load)\s+infile\s*=\s*["'']?([^\s"'']+)',
        '(?i)\bf\.[a-z0-9_.]+\s*=\s*["'']?([^\s"'']+)',
        '(?i)\b(?:source|include)\s+["'']?([^\s"'']+)'
    )
    foreach ($pattern in $patterns) {
        foreach ($match in [regex]::Matches($text, $pattern)) {
            $token = $match.Groups[1].Value.TrimEnd(',', ';')
            if ($token -match '\.(?:in|cmd|str|dat|lib|c|nta|exp|tbl|set|setx|log|sol|bin)$') { $tokens.Add($token) }
        }
    }
    $result = foreach ($token in $tokens | Sort-Object -Unique) {
        if ($generated -contains $token) { continue }
        $candidate = Join-Path $deck.DirectoryName $token
        $state = if ($token -match '[$()]') {
            'dynamic'
        } elseif (Test-Path -LiteralPath $candidate) {
            'present'
        } elseif ($generatedByExample -contains $token) {
            'generated-before-use'
        } else {
            'unresolved'
        }
        [pscustomobject]@{ File = $token; State = $state }
    }
    return @($result)
}

$globalMetadata = @{}
foreach ($rootItem in $Root) {
    if (-not (Test-Path -LiteralPath $rootItem)) { continue }
    $rootCategories = if ($Categories.Count -gt 0) {
        $Categories
    } else {
        @(Get-ChildItem -LiteralPath $rootItem -Directory | Select-Object -ExpandProperty Name)
    }
    foreach ($categoryName in $rootCategories) {
        $categoryPath = Join-Path $rootItem $categoryName
        foreach ($indexFile in Get-ChildItem -LiteralPath $categoryPath -File -Filter '*examples.index' -ErrorAction SilentlyContinue) {
            foreach ($item in (Get-IndexMetadata $indexFile.FullName).GetEnumerator()) {
                $globalMetadata["$categoryName/$($item.Key)"] = $item.Value
            }
        }
    }
}

$records = New-Object System.Collections.Generic.List[object]
foreach ($rootItem in $Root) {
    if (-not (Test-Path -LiteralPath $rootItem)) { continue }
    $resolvedRoot = (Resolve-Path -LiteralPath $rootItem).Path
    $version = Split-Path -Leaf $resolvedRoot
    $categories = if ($Categories.Count -gt 0) {
        $Categories
    } else {
        @(Get-ChildItem -LiteralPath $resolvedRoot -Directory | Select-Object -ExpandProperty Name)
    }
    foreach ($category in $categories) {
        $categoryPath = Join-Path $resolvedRoot $category
        if (-not (Test-Path -LiteralPath $categoryPath)) { continue }
        $metadata = @{}
        foreach ($indexFile in Get-ChildItem -LiteralPath $categoryPath -File -Filter '*examples.index' -ErrorAction SilentlyContinue) {
            foreach ($item in (Get-IndexMetadata $indexFile.FullName).GetEnumerator()) { $metadata[$item.Key] = $item.Value }
        }
        foreach ($deck in Get-ChildItem -LiteralPath $categoryPath -Recurse -File -Filter '*.in') {
            $text = Get-Content -Raw -LiteralPath $deck.FullName
            $exampleDecks = @(Get-ChildItem -LiteralPath $deck.DirectoryName -File -Filter '*.in')
            $generatedByExample = @($exampleDecks | ForEach-Object {
                $siblingText = Get-Content -Raw -LiteralPath $_.FullName
                [regex]::Matches($siblingText, '(?i)\b(?:out|outf|outfile)\s*=\s*["'']?([^\s"'']+)') | ForEach-Object {
                    $_.Groups[1].Value.TrimEnd(',', ';')
                }
            } | Sort-Object -Unique)
            $metadataKey = "$category/$($deck.Name)"
            $meta = if ($metadata.ContainsKey($deck.Name)) { $metadata[$deck.Name] } elseif ($globalMetadata.ContainsKey($metadataKey)) { $globalMetadata[$metadataKey] } else { $null }
            $title = if ($null -ne $meta) { $meta.Title } else { '' }
            $classes = Get-DeviceClass $category $deck.BaseName $title $text
            if ($classes.Count -eq 0) { continue }
            $go = @([regex]::Matches($text, '(?im)^\s*go\s+(atlas|athena|devedit|victory\w*)') | ForEach-Object { $_.Groups[1].Value.ToLowerInvariant() } | Sort-Object -Unique)
            $dependencies = Get-Dependencies $deck $text $generatedByExample
            $commandFamilies = @([regex]::Matches($text, '(?im)^\s*(mesh|x\.mesh|y\.mesh|z\.mesh|region|electrode|doping|material|mobility|models|impact|interface|intdefects|trap|contact|thermcontact|method|solve|log|save|load|extract)\b') | ForEach-Object { $_.Groups[1].Value.ToLowerInvariant() } | Sort-Object -Unique)
            $records.Add([pscustomobject]@{
                Version = $version
                Category = $category
                Example = $deck.BaseName
                Role = if ($null -ne $meta) { 'main' } else { 'auxiliary' }
                Title = $title
                Requires = if ($null -ne $meta) { $meta.Requires } else { '' }
                MinimumVersions = if ($null -ne $meta) { $meta.MinimumVersions } else { '' }
                Devices = $classes
                Simulators = $go
                Features = Get-Features $title $text
                CommandFamilies = $commandFamilies
                RelativeDeck = $deck.FullName.Substring($resolvedRoot.Length + 1)
                Dependencies = $dependencies
                UnresolvedDependencies = @($dependencies | Where-Object { $_.State -eq 'unresolved' } | Select-Object -ExpandProperty File)
                Sha256 = (Get-FileHash -LiteralPath $deck.FullName -Algorithm SHA256).Hash
            })
        }
    }
}

$ordered = @($records | Sort-Object Devices, Category, Example, Version)
if ($Format -eq 'Json') {
    $ordered | ConvertTo-Json -Depth 6
} elseif ($Format -eq 'Markdown') {
    '| Device | Example | Role | Title | Version | Simulator | Features | Unresolved dependencies |'
    '| --- | --- | --- | --- | --- | --- | --- | --- |'
    foreach ($row in $ordered) {
        '| {0} | `{1}/{2}` | {3} | {4} | {5} | {6} | {7} | {8} |' -f (
            ($row.Devices -join '/'), $row.Category, $row.Example,
            $row.Role, ($row.Title -replace '\|', '\|'), $row.Version,
            ($row.Simulators -join ' -> '), ($row.Features -join ', '),
            ($row.UnresolvedDependencies -join ', ')
        )
    }
} else {
    $ordered
}
