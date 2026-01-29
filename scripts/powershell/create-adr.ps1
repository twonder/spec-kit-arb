#!/usr/bin/env pwsh
# Create a new Architecture Decision Record (ADR)

# Source common functions
. "$PSScriptRoot/common.ps1"

[CmdletBinding()]
param(
    [switch]$Json,
    [switch]$Help,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$AdrTitle
)
$ErrorActionPreference = 'Stop'

# Show help if requested
if ($Help) {
    Write-Host "Usage: ./create-adr.ps1 [-Json] <adr_title>"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -Json    Output in JSON format"
    Write-Host "  -Help    Show this help message"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  ./create-adr.ps1 'Use PostgreSQL for primary database'"
    Write-Host "  ./create-adr.ps1 -Json 'Adopt microservices architecture'"
    exit 0
}

# Check if ADR title provided
if (-not $AdrTitle -or $AdrTitle.Count -eq 0) {
    Write-Error "Usage: ./create-adr.ps1 [-Json] <adr_title>"
    exit 1
}

$adrTitleStr = ($AdrTitle -join ' ').Trim()

# Function to find the repository root by searching for existing project markers
function Find-RepositoryRoot {
    param(
        [string]$StartDir,
        [string[]]$Markers = @('.git', '.specify')
    )
    $current = Resolve-Path $StartDir
    while ($true) {
        foreach ($marker in $Markers) {
            if (Test-Path (Join-Path $current $marker)) {
                return $current
            }
        }
        $parent = Split-Path $current -Parent
        if ($parent -eq $current) {
            # Reached filesystem root without finding markers
            return $null
        }
        $current = $parent
    }
}

# Function to get highest ADR number from directory
function Get-HighestAdrNumber {
    param([string]$AdrDir)

    $highest = 0
    if (Test-Path $AdrDir) {
        Get-ChildItem -Path $AdrDir -File -Filter "ADR-*.md" | ForEach-Object {
            if ($_.Name -match '^ADR-(\d+)-') {
                $num = [int]$matches[1]
                if ($num -gt $highest) { $highest = $num }
            }
        }
    }
    return $highest
}

# Function to clean and format a slug
function ConvertTo-CleanSlug {
    param([string]$Name)

    return $Name.ToLower() -replace '[^a-z0-9]', '-' -replace '-{2,}', '-' -replace '^-', '' -replace '-$', ''
}

# Function to generate slug from title with stop word filtering
function Get-AdrSlug {
    param([string]$Title)

    # Common stop words to filter out
    $stopWords = @(
        'i', 'a', 'an', 'the', 'to', 'for', 'of', 'in', 'on', 'at', 'by', 'with', 'from',
        'is', 'are', 'was', 'were', 'be', 'been', 'being', 'have', 'has', 'had',
        'do', 'does', 'did', 'will', 'would', 'should', 'could', 'can', 'may', 'might', 'must', 'shall',
        'this', 'that', 'these', 'those', 'my', 'your', 'our', 'their',
        'want', 'need', 'we'
    )

    # Convert to lowercase and extract words
    $cleanName = $Title.ToLower() -replace '[^a-z0-9\s]', ' '
    $words = $cleanName -split '\s+' | Where-Object { $_ }

    # Filter words
    $meaningfulWords = @()
    foreach ($word in $words) {
        if ($stopWords -contains $word) { continue }
        if ($word.Length -ge 2) {
            $meaningfulWords += $word
        }
    }

    # Use first 4-5 meaningful words
    if ($meaningfulWords.Count -gt 0) {
        $maxWords = 5
        $result = ($meaningfulWords | Select-Object -First $maxWords) -join '-'
        return $result
    } else {
        # Fallback
        return ConvertTo-CleanSlug -Name $Title
    }
}

# Resolve repository root
$fallbackRoot = (Find-RepositoryRoot -StartDir $PSScriptRoot)
if (-not $fallbackRoot) {
    Write-Error "Error: Could not determine repository root. Please run this script from within the repository."
    exit 1
}

try {
    $repoRoot = git rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -eq 0) {
        # Success
    } else {
        throw "Git not available"
    }
} catch {
    $repoRoot = $fallbackRoot
}

Set-Location $repoRoot

# Load configuration
$config = Get-SpecifyConfig -RepoRoot $repoRoot
$adrDirName = $config.adrDir
$adrDir = Join-Path $repoRoot $adrDirName
New-Item -ItemType Directory -Path $adrDir -Force | Out-Null

# Get next ADR number
$highest = Get-HighestAdrNumber -AdrDir $adrDir
$adrNum = $highest + 1
$adrNumFormatted = ('{0:000}' -f $adrNum)

# Generate slug from title
$slug = Get-AdrSlug -Title $adrTitleStr

# Create ADR filename
$adrFilename = "ADR-$adrNumFormatted-$slug.md"
$adrFile = Join-Path $adrDir $adrFilename

# Copy template if it exists, otherwise create empty file
$template = Join-Path $repoRoot '.specify/templates/adr-template.md'
$packageTemplate = Join-Path $PSScriptRoot '../../templates/adr-template.md'

if (Test-Path $template) {
    Copy-Item $template $adrFile -Force
} elseif (Test-Path $packageTemplate) {
    Copy-Item $packageTemplate $adrFile -Force
} else {
    New-Item -ItemType File -Path $adrFile | Out-Null
}

# Output result
if ($Json) {
    $obj = [PSCustomObject]@{
        ADR_NUM = $adrNumFormatted
        ADR_FILE = $adrFile
        ADR_TITLE = $adrTitleStr
        ADR_SLUG = $slug
    }
    $obj | ConvertTo-Json -Compress
} else {
    Write-Output "ADR_NUM: $adrNumFormatted"
    Write-Output "ADR_FILE: $adrFile"
    Write-Output "ADR_TITLE: $adrTitleStr"
    Write-Output "ADR_SLUG: $slug"
}
