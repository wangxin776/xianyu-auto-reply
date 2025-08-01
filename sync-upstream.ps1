# Sync upstream repository script
# Sync latest code from zhinianboke/xianyu-auto-reply

Write-Host "Starting sync with upstream repository..." -ForegroundColor Green

# Save current branch
$currentBranch = git branch --show-current
Write-Host "Current branch: $currentBranch" -ForegroundColor Yellow

# Check if working directory is clean
$status = git status --porcelain
if ($status) {
    Write-Host "Working directory has uncommitted changes. Please commit or stash first:" -ForegroundColor Red
    git status --short
    Write-Host "Suggestion: git add . && git commit -m 'Save current work'" -ForegroundColor Cyan
    exit 1
}

try {
    # Switch to main branch
    Write-Host "Switching to main branch..." -ForegroundColor Blue
    git checkout main

    # Fetch latest code from upstream
    Write-Host "Fetching latest code from upstream..." -ForegroundColor Blue
    git fetch upstream

    # Check if there are new updates
    $behind = git rev-list --count HEAD..upstream/main
    if ($behind -eq "0") {
        Write-Host "Already up to date, no sync needed" -ForegroundColor Green
    } else {
        Write-Host "Found $behind new commits, starting merge..." -ForegroundColor Yellow

        # Merge upstream changes
        git merge upstream/main --no-edit

        # Push to your fork
        Write-Host "Pushing updates to your fork..." -ForegroundColor Blue
        git push origin main

        Write-Host "Main branch sync completed" -ForegroundColor Green
    }

    # Switch back to development branch
    Write-Host "Switching back to development branch: $currentBranch" -ForegroundColor Blue
    git checkout $currentBranch

    # Check if development branch needs main updates
    $behindMain = git rev-list --count HEAD..main
    if ($behindMain -eq "0") {
        Write-Host "Development branch is up to date" -ForegroundColor Green
    } else {
        Write-Host "Merging main branch updates to development branch..." -ForegroundColor Yellow
        git merge main --no-edit
        Write-Host "Development branch update completed" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "Sync completed!" -ForegroundColor Green
    Write-Host "Current branch: $currentBranch" -ForegroundColor Yellow
    Write-Host "Latest upstream code merged" -ForegroundColor Green

    # Show latest commits
    Write-Host ""
    Write-Host "Latest commit history:" -ForegroundColor Cyan
    git log --oneline -5

} catch {
    Write-Host "Error during sync: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Please check and resolve conflicts manually" -ForegroundColor Yellow
    exit 1
}
