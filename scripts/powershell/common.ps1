#!/usr/bin/env pwsh
# Common PowerShell functions analogous to common.sh

# Script-level configuration cache
$script:SpecifyConfig = $null
$script:SpecifyConfigLoaded = $false

# Load configuration from config files
# Priority: 1) local.config.json (user-specific), 2) config.json, 3) environment variables, 4) defaults
function Get-SpecifyConfig {
    param([string]$RepoRoot)

    # Return cached config if already loaded
    if ($script:SpecifyConfigLoaded -and $script:SpecifyConfig) {
        return $script:SpecifyConfig
    }

    # Initialize with defaults
    $config = @{
        specsDir = "specs"
        adrDir = "adrs"
        useNumberedPrefix = $true
        userName = ""
        userTeam = ""
        userEmail = ""
        teams = @{}
    }

    # Try to load from base config file first
    if ($RepoRoot) {
        $baseConfigFile = Join-Path $RepoRoot ".specify/config.json"
        if (Test-Path $baseConfigFile) {
            try {
                $jsonConfig = Get-Content $baseConfigFile -Raw | ConvertFrom-Json
                if ($jsonConfig.specsDir) { $config.specsDir = $jsonConfig.specsDir }
                if ($jsonConfig.adrDir) { $config.adrDir = $jsonConfig.adrDir }
                if ($null -ne $jsonConfig.useNumberedPrefix) { $config.useNumberedPrefix = $jsonConfig.useNumberedPrefix }
            } catch {
                Write-Verbose "Could not parse base config file: $_"
            }
        }

        # Load local config (overrides base config)
        $localConfigFile = Join-Path $RepoRoot ".specify/local.config.json"
        if (Test-Path $localConfigFile) {
            try {
                $localConfig = Get-Content $localConfigFile -Raw | ConvertFrom-Json

                # Override with local config values
                if ($localConfig.specsDir) { $config.specsDir = $localConfig.specsDir }
                if ($localConfig.adrDir) { $config.adrDir = $localConfig.adrDir }
                if ($null -ne $localConfig.useNumberedPrefix) { $config.useNumberedPrefix = $localConfig.useNumberedPrefix }

                # User-specific settings (only from local config)
                if ($localConfig.user) {
                    if ($localConfig.user.name) { $config.userName = $localConfig.user.name }
                    if ($localConfig.user.team) { $config.userTeam = $localConfig.user.team }
                    if ($localConfig.user.email) { $config.userEmail = $localConfig.user.email }
                }

                # Teams configuration
                if ($localConfig.teams) {
                    $config.teams = $localConfig.teams
                }

                # If user has a team, check for team-specific specsDir/adrDir overrides
                if ($config.userTeam -and $localConfig.teams -and $localConfig.teams.$($config.userTeam)) {
                    $teamConfig = $localConfig.teams.$($config.userTeam)
                    if ($teamConfig.specsDir) { $config.specsDir = $teamConfig.specsDir }
                    if ($teamConfig.adrDir) { $config.adrDir = $teamConfig.adrDir }
                }
            } catch {
                Write-Verbose "Could not parse local config file: $_"
            }
        }
    }

    # Fall back to environment variables if config values are still defaults
    if ($env:SPECIFY_SPECS_DIR -and $config.specsDir -eq "specs") {
        $config.specsDir = $env:SPECIFY_SPECS_DIR
    }
    if ($env:SPECIFY_ADR_DIR -and $config.adrDir -eq "adrs") {
        $config.adrDir = $env:SPECIFY_ADR_DIR
    }
    if ($env:SPECIFY_USE_NUMBERED_PREFIX) {
        $config.useNumberedPrefix = $env:SPECIFY_USE_NUMBERED_PREFIX -eq "true"
    }

    # Cache the config
    $script:SpecifyConfig = $config
    $script:SpecifyConfigLoaded = $true

    return $config
}

# Reset config cache (useful for testing)
function Reset-SpecifyConfig {
    $script:SpecifyConfig = $null
    $script:SpecifyConfigLoaded = $false
}

function Get-SpecsDir {
    $repoRoot = Get-RepoRoot
    $config = Get-SpecifyConfig -RepoRoot $repoRoot
    return $config.specsDir
}

function Get-AdrDir {
    $repoRoot = Get-RepoRoot
    $config = Get-SpecifyConfig -RepoRoot $repoRoot
    return $config.adrDir
}

function Use-NumberedPrefix {
    $repoRoot = Get-RepoRoot
    $config = Get-SpecifyConfig -RepoRoot $repoRoot
    return $config.useNumberedPrefix
}

function Get-UserName {
    $repoRoot = Get-RepoRoot
    $config = Get-SpecifyConfig -RepoRoot $repoRoot
    return $config.userName
}

function Get-UserTeam {
    $repoRoot = Get-RepoRoot
    $config = Get-SpecifyConfig -RepoRoot $repoRoot
    return $config.userTeam
}

function Get-UserEmail {
    $repoRoot = Get-RepoRoot
    $config = Get-SpecifyConfig -RepoRoot $repoRoot
    return $config.userEmail
}

function Get-RepoRoot {
    try {
        $result = git rev-parse --show-toplevel 2>$null
        if ($LASTEXITCODE -eq 0) {
            return $result
        }
    } catch {
        # Git command failed
    }
    
    # Fall back to script location for non-git repos
    return (Resolve-Path (Join-Path $PSScriptRoot "../../..")).Path
}

function Get-CurrentBranch {
    # First check if SPECIFY_FEATURE environment variable is set
    if ($env:SPECIFY_FEATURE) {
        return $env:SPECIFY_FEATURE
    }
    
    # Then check git if available
    try {
        $result = git rev-parse --abbrev-ref HEAD 2>$null
        if ($LASTEXITCODE -eq 0) {
            return $result
        }
    } catch {
        # Git command failed
    }
    
    # For non-git repos, try to find the latest feature directory
    $repoRoot = Get-RepoRoot
    $specsDir = Join-Path $repoRoot (Get-SpecsDir)

    if (Test-Path $specsDir) {
        $latestFeature = ""
        $highest = 0
        $latestMtime = [DateTime]::MinValue

        Get-ChildItem -Path $specsDir -Directory | ForEach-Object {
            if (Use-NumberedPrefix) {
                # Numbered prefix mode: find highest number
                if ($_.Name -match '^(\d{3})-') {
                    $num = [int]$matches[1]
                    if ($num -gt $highest) {
                        $highest = $num
                        $latestFeature = $_.Name
                    }
                }
            } else {
                # Non-numbered mode: find most recently modified
                $mtime = $_.LastWriteTime
                if ($mtime -gt $latestMtime) {
                    $latestMtime = $mtime
                    $latestFeature = $_.Name
                }
            }
        }

        if ($latestFeature) {
            return $latestFeature
        }
    }

    # Final fallback
    return "main"
}

function Test-HasGit {
    try {
        git rev-parse --show-toplevel 2>$null | Out-Null
        return ($LASTEXITCODE -eq 0)
    } catch {
        return $false
    }
}

function Test-FeatureBranch {
    param(
        [string]$Branch,
        [bool]$HasGit = $true
    )

    # For non-git repos, we can't enforce branch naming but still provide output
    if (-not $HasGit) {
        Write-Warning "[specify] Warning: Git repository not detected; skipped branch validation"
        return $true
    }

    # Skip numbered prefix validation when not using numbered prefixes
    if (-not (Use-NumberedPrefix)) {
        return $true
    }

    if ($Branch -notmatch '^[0-9]{3}-') {
        Write-Output "ERROR: Not on a feature branch. Current branch: $Branch"
        Write-Output "Feature branches should be named like: 001-feature-name"
        return $false
    }
    return $true
}

function Get-FeatureDir {
    param([string]$RepoRoot, [string]$Branch)
    Join-Path $RepoRoot "$(Get-SpecsDir)/$Branch"
}

# Find feature directory by numeric prefix instead of exact branch match
# This allows multiple branches to work on the same spec (e.g., 004-fix-bug, 004-add-feature)
function Find-FeatureDirByPrefix {
    param([string]$RepoRoot, [string]$BranchName)

    $specsDir = Join-Path $RepoRoot (Get-SpecsDir)

    # In non-numbered mode, use exact match
    if (-not (Use-NumberedPrefix)) {
        return Join-Path $specsDir $BranchName
    }

    # Extract numeric prefix from branch (e.g., "004" from "004-whatever")
    if ($BranchName -notmatch '^(\d{3})-') {
        # If branch doesn't have numeric prefix, fall back to exact match
        return Join-Path $specsDir $BranchName
    }

    $prefix = $matches[1]

    # Search for directories in specs/ that start with this prefix
    $matchingDirs = @()
    if (Test-Path $specsDir) {
        Get-ChildItem -Path $specsDir -Directory | Where-Object { $_.Name -match "^$prefix-" } | ForEach-Object {
            $matchingDirs += $_.Name
        }
    }

    # Handle results
    if ($matchingDirs.Count -eq 0) {
        # No match found - return the branch name path
        return Join-Path $specsDir $BranchName
    } elseif ($matchingDirs.Count -eq 1) {
        # Exactly one match
        return Join-Path $specsDir $matchingDirs[0]
    } else {
        # Multiple matches
        Write-Warning "ERROR: Multiple spec directories found with prefix '$prefix': $($matchingDirs -join ', ')"
        Write-Warning "Please ensure only one spec directory exists per numeric prefix."
        return Join-Path $specsDir $BranchName
    }
}

function Get-FeaturePathsEnv {
    $repoRoot = Get-RepoRoot
    $currentBranch = Get-CurrentBranch
    $hasGit = Test-HasGit
    # Use prefix-based lookup to support multiple branches per spec
    $featureDir = Find-FeatureDirByPrefix -RepoRoot $repoRoot -BranchName $currentBranch

    [PSCustomObject]@{
        REPO_ROOT     = $repoRoot
        CURRENT_BRANCH = $currentBranch
        HAS_GIT       = $hasGit
        FEATURE_DIR   = $featureDir
        FEATURE_SPEC  = Join-Path $featureDir 'spec.md'
        IMPL_PLAN     = Join-Path $featureDir 'plan.md'
        RESEARCH      = Join-Path $featureDir 'research.md'
        DATA_MODEL    = Join-Path $featureDir 'data-model.md'
        QUICKSTART    = Join-Path $featureDir 'quickstart.md'
        CONTRACTS_DIR = Join-Path $featureDir 'contracts'
    }
}

function Test-FileExists {
    param([string]$Path, [string]$Description)
    if (Test-Path -Path $Path -PathType Leaf) {
        Write-Output "  ✓ $Description"
        return $true
    } else {
        Write-Output "  ✗ $Description"
        return $false
    }
}

function Test-DirHasFiles {
    param([string]$Path, [string]$Description)
    if ((Test-Path -Path $Path -PathType Container) -and (Get-ChildItem -Path $Path -ErrorAction SilentlyContinue | Where-Object { -not $_.PSIsContainer } | Select-Object -First 1)) {
        Write-Output "  ✓ $Description"
        return $true
    } else {
        Write-Output "  ✗ $Description"
        return $false
    }
}

