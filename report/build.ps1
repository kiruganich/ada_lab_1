$ErrorActionPreference = 'Stop'
$reportRoot = $PSScriptRoot
$buildDir = Join-Path $reportRoot 'build'
$outputDir = Join-Path $reportRoot 'output\pdf'
$previousTectonicCacheDir = [Environment]::GetEnvironmentVariable('TECTONIC_CACHE_DIR', 'Process')
New-Item -ItemType Directory -Force -Path $buildDir, $outputDir | Out-Null
Push-Location -LiteralPath $reportRoot
try {
    if (Get-Command tectonic -ErrorAction SilentlyContinue) {
        if (-not $previousTectonicCacheDir) {
            $env:TECTONIC_CACHE_DIR = Join-Path $buildDir 'tectonic-cache'
        }
        & tectonic --untrusted --keep-logs --keep-intermediates --outdir $buildDir report.tex
        if ($LASTEXITCODE -ne 0) { throw 'Tectonic build failed.' }
    }
    elseif (Get-Command pdflatex -ErrorAction SilentlyContinue) {
        for ($pass = 0; $pass -lt 2; $pass++) {
            & pdflatex -interaction=nonstopmode -halt-on-error -output-directory=$buildDir report.tex
            if ($LASTEXITCODE -ne 0) { throw 'pdfLaTeX build failed.' }
        }
    }
    else {
        throw 'Install Tectonic or a TeX distribution with pdfLaTeX and Russian language support.'
    }
    $pdfPath = Join-Path $outputDir 'report-template.pdf'
    Copy-Item -LiteralPath (Join-Path $buildDir 'report.pdf') -Destination $pdfPath -Force
    Write-Output "Report template: $pdfPath"
}
finally {
    [Environment]::SetEnvironmentVariable('TECTONIC_CACHE_DIR', $previousTectonicCacheDir, 'Process')
    Pop-Location
}
