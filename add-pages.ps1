# HTML文件自动添加到pages.json的PowerShell脚本

param(
    [string]$HtmlDir = ".",
    [string]$JsonFile = "pages.json"
)

function Get-RandomCssImage {
    $cssClasses = @(
        "css-image-abstract-gradient",
        "css-image-communication",
        "css-image-features",
        "css-image-add-page",
        "css-image-tech-style",
        "css-image-geometric",
        "css-image-minimalist"
    )
    $randomIndex = Get-Random -Minimum 0 -Maximum $cssClasses.Length
    return $cssClasses[$randomIndex]
}

function Get-HtmlTitle {
    param([string]$HtmlFile)
    $content = Get-Content -Path $HtmlFile -Raw -ErrorAction SilentlyContinue
    if (-not $content) { return $null }
    $titleMatch = [regex]::Match($content, '<title>(.*?)</title>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    if ($titleMatch.Success) {
        return $titleMatch.Groups[1].Value.Trim()
    }
    return $null
}

function Get-PageDescription {
    param([string]$HtmlFile)
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($HtmlFile)
    switch ($baseName) {
        "about" { return "了解我们的项目背景、团队和目标" }
        "contact" { return "获取联系方式，与我们取得联系" }
        "features" { return "详细介绍项目的各种功能和特性" }
        "index" { return "项目主页" }
        default { return "这是" + $baseName + "页面的描述" }
    }
}

Write-Host "=== HTML文件自动添加到pages.json工具 ==="
Write-Host "操作系统: Windows"
Write-Host

if (-not (Test-Path $JsonFile)) {
    Write-Host "创建空的pages.json文件..."
    "[]" | Out-File -FilePath $JsonFile -Encoding UTF8
}

$jsonContent = Get-Content -Path $JsonFile -Raw | ConvertFrom-Json

$backupFile = $JsonFile + ".bak"
Copy-Item -Path $JsonFile -Destination $backupFile -Force
Write-Host "已备份pages.json到" $backupFile
Write-Host

Write-Host "正在搜索HTML文件..."
$htmlFiles = Get-ChildItem -Path $HtmlDir -Filter "*.html" -Recurse | Where-Object { $_.Directory.Name -ne ".claude" } | Sort-Object -Property FullName

if ($htmlFiles.Count -eq 0) {
    Write-Host "未找到HTML文件"
    exit 0
}

Write-Host "找到" $htmlFiles.Count "个HTML文件"
Write-Host

$addedCount = 0
foreach ($htmlFile in $htmlFiles) {
    $fileName = $htmlFile.Name
    if ($fileName -eq "index.html") {
        Write-Host "跳过: " $fileName
        continue
    }
    $existing = $jsonContent | Where-Object { $_.file -eq $fileName }
    if ($existing) {
        Write-Host "跳过: " $fileName " 已存在于pages.json中"
        continue
    }
    $title = Get-HtmlTitle -HtmlFile $htmlFile.FullName
    if (-not $title) {
        $title = $fileName -replace ".html", "" -replace "-", " " -replace "_", " "
        $title = (Get-Culture).TextInfo.ToTitleCase($title)
    }
    $description = Get-PageDescription -HtmlFile $fileName
    $cssClass = Get-RandomCssImage
    $placeholder = "https://via.placeholder.com/400x200?text=" + ($title -replace " ", "+")
    $newPage = [PSCustomObject]@{
        title = $title
        description = $description
        file = $fileName
        imageType = "css"
        imageClass = $cssClass
        image = $placeholder
    }
    $jsonContent += $newPage
    $addedCount++
    Write-Host "已添加: " $fileName " -> " $title
}

$jsonContent | ConvertTo-Json -Depth 100 | Out-File -FilePath $JsonFile -Encoding UTF8

Write-Host
Write-Host "=== 完成！ ==="
Write-Host "已处理" $htmlFiles.Count "个HTML文件"
Write-Host "已添加" $addedCount "个新页面到pages.json"
Write-Host "备份文件: " $backupFile
Write-Host
Write-Host "使用CSS生成图像，您可以访问: http://localhost:8000/css-images-demo.html 查看样式"