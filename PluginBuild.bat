@echo off
setlocal

:: ===== Constants =====
set UE_PATH=B:\UnrealEngine\UE_5.8
set PROJECT_PATH=B:\Projects\XAIDemo
set PLUGIN_NAME=XAI

set BUILD_DIR=%PROJECT_PATH%\Builds\%PLUGIN_NAME%
set PLUGIN_FILE=%PROJECT_PATH%\Plugins\%PLUGIN_NAME%\%PLUGIN_NAME%.uplugin  
:: =====================

start powershell -NoExit -Command "& '%UE_PATH%\Engine\Build\BatchFiles\RunUAT.bat' BuildPlugin -Plugin='%PLUGIN_FILE%' -Package='%BUILD_DIR%' -Rocket -2019 2>&1 | ForEach-Object { $_; Out-File -FilePath '%PROJECT_PATH%\PluginBuildLog.txt' -Encoding utf8 -Append -InputObject $_ }; if ($LASTEXITCODE -eq 0) { if (-not (Test-Path '%BUILD_DIR%')) { New-Item -ItemType Directory -Path '%BUILD_DIR%' -Force | Out-Null }; Copy-Item -Path '%PLUGIN_FILE%' -Destination '%BUILD_DIR%' -Force; Write-Host 'Build completed and .uplugin copied.' } else { Write-Host 'Build failed with error code' $LASTEXITCODE }; Write-Host 'Check PluginBuildLog.txt for full details.'; Read-Host 'Press Enter to exit'"