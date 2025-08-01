# 闲鱼自动回复系统 - 上游代码同步脚本
# 用于同步原作者 zhinianboke/xianyu-auto-reply 的最新代码

Write-Host "🚀 开始同步原作者最新代码..." -ForegroundColor Green

# 保存当前分支
$currentBranch = git branch --show-current
Write-Host "📍 当前分支: $currentBranch" -ForegroundColor Yellow

# 检查工作区是否干净
$status = git status --porcelain
if ($status) {
    Write-Host "⚠️  工作区有未提交的更改，请先提交或暂存:" -ForegroundColor Red
    git status --short
    Write-Host "💡 建议执行: git add . && git commit -m '保存当前工作'" -ForegroundColor Cyan
    exit 1
}

try {
    # 切换到main分支
    Write-Host "🔄 切换到main分支..." -ForegroundColor Blue
    git checkout main
    
    # 拉取原作者最新代码
    Write-Host "📥 从原作者仓库拉取最新代码..." -ForegroundColor Blue
    git fetch upstream
    
    # 检查是否有新的更新
    $behind = git rev-list --count HEAD..upstream/main
    if ($behind -eq "0") {
        Write-Host "✅ 已经是最新版本，无需同步" -ForegroundColor Green
    } else {
        Write-Host "📦 发现 $behind 个新提交，开始合并..." -ForegroundColor Yellow
        
        # 合并原作者的最新代码
        git merge upstream/main --no-edit
        
        # 推送到您的fork仓库
        Write-Host "📤 推送更新到您的fork仓库..." -ForegroundColor Blue
        git push origin main
        
        Write-Host "✅ main分支同步完成" -ForegroundColor Green
    }
    
    # 切换回开发分支
    Write-Host "🔄 切换回开发分支: $currentBranch" -ForegroundColor Blue
    git checkout $currentBranch
    
    # 检查开发分支是否需要合并main的更新
    $behindMain = git rev-list --count HEAD..main
    if ($behindMain -eq "0") {
        Write-Host "✅ 开发分支已经是最新的" -ForegroundColor Green
    } else {
        Write-Host "📦 将main分支的更新合并到开发分支..." -ForegroundColor Yellow
        git merge main --no-edit
        Write-Host "✅ 开发分支更新完成" -ForegroundColor Green
    }
    
    Write-Host "`n🎉 同步完成！" -ForegroundColor Green
    Write-Host "📍 当前分支: $currentBranch" -ForegroundColor Yellow
    Write-Host "✨ 已合并原作者最新代码" -ForegroundColor Green
    
    # 显示最新的几个提交
    Write-Host "`n📋 最新提交记录:" -ForegroundColor Cyan
    git log --oneline -5
    
} catch {
    Write-Host "❌ 同步过程中出现错误: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "🔧 请手动检查并解决冲突" -ForegroundColor Yellow
    exit 1
}
