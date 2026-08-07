param(
    [string]$Root,
    [string[]]$ExtraRoots = @(),
    [switch]$Json,
    [int]$Depth = 6
)

$ErrorActionPreference = 'SilentlyContinue'

$candidateRoots = New-Object System.Collections.Generic.List[string]

function Add-CandidateRoot([string]$Path) {
    if ([string]::IsNullOrWhiteSpace($Path)) { return }
    $expanded = [Environment]::ExpandEnvironmentVariables($Path)
    if (Test-Path -LiteralPath $expanded) {
        $resolved = (Resolve-Path -LiteralPath $expanded).Path
        if (-not $candidateRoots.Contains($resolved)) { $candidateRoots.Add($resolved) }
    }
}

Add-CandidateRoot $Root
foreach ($r in $ExtraRoots) { Add-CandidateRoot $r }

# User- or system-provided locations. Prefer these over broad drive scans.
Add-CandidateRoot $env:SILVACO_EXAMPLES_DIR
Add-CandidateRoot $env:TCAD_EXAMPLES_DIR
Add-CandidateRoot $env:SILVACO_HOME
Add-CandidateRoot $env:SEDATOOLS_HOME

# Generic Windows installation roots from environment variables, not hard-coded user paths.
Add-CandidateRoot $env:ProgramFiles
Add-CandidateRoot ${env:ProgramFiles(x86)}
Add-CandidateRoot $env:ProgramData

# Generic drive-root candidates. These are not personal paths; they are broad vendor directory names.
$driveRoots = Get-PSDrive -PSProvider FileSystem | ForEach-Object { $_.Root }
$vendorSubdirs = @(
    'Silvaco',
    'silvaco',
    'sedatools',
    'SILVACO',
    'softwares\sedatools',
    'software\sedatools',
    'tools\sedatools',
    'apps\sedatools'
)
foreach ($d in $driveRoots) {
    foreach ($subdir in $vendorSubdirs) {
        Add-CandidateRoot (Join-Path $d $subdir)
    }
}

$results = New-Object System.Collections.Generic.List[object]
foreach ($base in $candidateRoots) {
    Get-ChildItem -LiteralPath $base -Directory -Recurse -Depth $Depth | Where-Object {
        $_.FullName -match 'examples' -and (
            $_.Name -ieq 'sic' -or
            $_.Name -ieq 'power' -or
            $_.Name -ieq 'diode' -or
            $_.Name -ieq 'mos1' -or
            $_.Name -ieq 'mos2' -or
            $_.Name -ieq 'ganfet' -or
            $_.Name -ieq 'mesfet' -or
            $_.Name -ieq 'bjt' -or
            $_.Name -match '^\d+\.\d+\.\d+\.R$'
        )
    } | ForEach-Object {
        $indexFiles = Get-ChildItem -LiteralPath $_.FullName -File -Filter '*examples.index' -ErrorAction SilentlyContinue
        $deckCount = (Get-ChildItem -LiteralPath $_.FullName -Recurse -File -Include *.in,*.cmd -ErrorAction SilentlyContinue | Measure-Object).Count
        $results.Add([pscustomobject]@{
            Path = $_.FullName
            Name = $_.Name
            DeckCount = $deckCount
            IndexFiles = ($indexFiles | Select-Object -ExpandProperty Name) -join '; '
        })
    }
}

$unique = $results | Sort-Object Path -Unique
if ($Json) {
    $unique | ConvertTo-Json -Depth 4
} else {
    $unique | Format-Table -AutoSize
}
