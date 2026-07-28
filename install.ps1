# install-refactoring-skill.ps1
#
# Installs the Refactoring Claude Skill into the current project.
# For Windows / PowerShell. For macOS/Linux, use install.sh instead.
#
# Usage (from the project's root folder, in PowerShell):
#   iwr -useb https://raw.githubusercontent.com/omaromar9091/refactoring-skill/main/install.ps1 | iex
#   # or, after cloning the repo:
#   .\install.ps1

$ErrorActionPreference = "Stop"

$Repo = "omaromar9091/refactoring-skill"
$Branch = "main"
$TargetDir = ".claude\skills\refactoring"
$RawBase = "https://raw.githubusercontent.com/$Repo/$Branch"

$ReferenceFiles = @(
    "authority-model.md",
    "bug-discovery.md",
    "code-examples.md",
    "criticality-calibration.md",
    "deadline-pressure.md",
    "language-variance.md",
    "large-scale-refactoring.md",
    "no-tests-scenario.md",
    "performance-tradeoffs.md",
    "refactor-vs-rewrite.md",
    "rollback-and-failure.md",
    "shared-api-refactoring.md",
    "smell-detection-signals.md",
    "tooling-vs-manual.md",
    "verification.md",
    "version-control-discipline.md"
)

Write-Host "==> Installing Refactoring Skill into .\$TargetDir"

New-Item -ItemType Directory -Force -Path "$TargetDir\references" | Out-Null

function Get-SkillFile {
    param(
        [string]$RemotePath,
        [string]$LocalPath
    )
    Invoke-WebRequest -Uri "$RawBase/$RemotePath" -OutFile $LocalPath -UseBasicParsing
}

Write-Host "==> Downloading SKILL.md"
Get-SkillFile -RemotePath "SKILL.md" -LocalPath "$TargetDir\SKILL.md"

Write-Host "==> Downloading reference files"
foreach ($f in $ReferenceFiles) {
    Write-Host "    - references/$f"
    Get-SkillFile -RemotePath "references/$f" -LocalPath "$TargetDir\references\$f"
}

Write-Host ""
Write-Host "Done. The skill is now available at: $TargetDir" -ForegroundColor Green
Write-Host "Any Claude-based agent (Claude Code, etc.) reading .claude\skills\"
Write-Host "in this project will pick it up automatically."
