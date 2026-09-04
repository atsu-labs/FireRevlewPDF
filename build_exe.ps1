<#
.SYNOPSIS
    FireReviewPDF の Windows 実行ファイル（EXE）ビルドスクリプト
.DESCRIPTION
    PyInstaller を用いて単一実行ファイル形式 (Onefile) で FireReviewPDF.exe をビルドします。
#>

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  FireReviewPDF Windows EXE Build Script" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Python 実行パスの検出
$pythonCmd = "python"
if (Get-Command "C:\Users\fd-shidou\AppData\Local\Python\bin\python.exe" -ErrorAction SilentlyContinue) {
    $pythonCmd = "C:\Users\fd-shidou\AppData\Local\Python\bin\python.exe"
}

Write-Host "`n[1/3] Python & PyInstaller の確認..." -ForegroundColor Yellow
& $pythonCmd -m PyInstaller --version
if ($LASTEXITCODE -ne 0) {
    Write-Error "PyInstaller が見つかりません。pip install pyinstaller を実行してください。"
    exit 1
}

Write-Host "`n[2/3] PyInstaller によるビルド実行中..." -ForegroundColor Yellow
& $pythonCmd -m PyInstaller FireReviewPDF.spec --clean --noconfirm

if ($LASTEXITCODE -ne 0) {
    Write-Error "ビルド中にエラーが発生しました。"
    exit $LASTEXITCODE
}

Write-Host "`n[3/3] ビルド結果の確認..." -ForegroundColor Yellow
$exePath = Join-Path $PSScriptRoot "dist\FireReviewPDF.exe"

if (Test-Path $exePath) {
    $item = Get-Item $exePath
    $sizeMB = [math]::Round($item.Length / 1MB, 2)
    Write-Host "`nビルドが正常に完了しました！" -ForegroundColor Green
    Write-Host "出力ファイル: $exePath" -ForegroundColor Green
    Write-Host "サイズ: $sizeMB MB`n" -ForegroundColor Green
} else {
    Write-Error "dist\FireReviewPDF.exe が生成されませんでした。"
    exit 1
}
