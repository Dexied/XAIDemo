@echo off
setlocal

:: ===== Constants =====
set UE_PATH=B:\UnrealEngine\UE_5.8
set PROJECT_PATH=B:\Projects\XAIDemo
set PROJECT_NAME=XAIDemo
set TARGET_NAME=XAIDemoEditor
set BUILD_CONFIG=Development
set BUILD_PLATFORM=Win64

set UPROJECT_FILE=%PROJECT_PATH%\%PROJECT_NAME%.uproject
set BUILD_LOG=%PROJECT_PATH%\ProjectBuildLog.txt
:: =====================

if exist "%BUILD_LOG%" del "%BUILD_LOG%"

powershell -NoExit -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Continue'; $UE='%UE_PATH%'; $UP='%UPROJECT_FILE%'; $LOG='%BUILD_LOG%'; $GEN_OK=$false; Write-Host '=== Step 1/2: Generate Project Files ===' -ForegroundColor Cyan; $GenRoot=Join-Path $UE 'GenerateProjectFiles.bat'; $GenOld=Join-Path $UE 'Engine\Build\BatchFiles\GenerateProjectFiles.bat'; $BuildBat=Join-Path $UE 'Engine\Build\BatchFiles\Build.bat'; $ProjArg = '-project=' + $UP; if (Test-Path $GenRoot) { Write-Host 'Using: GenerateProjectFiles.bat (engine root)'; & $GenRoot -project=$UP -game -engine 2>&1 | ForEach-Object { $_; Out-File -FilePath $LOG -Encoding utf8 -Append -InputObject $_ }; $GEN_OK=($LASTEXITCODE -eq 0) } elseif (Test-Path $GenOld) { Write-Host 'Using: GenerateProjectFiles.bat (BatchFiles)'; & $GenOld -project=$UP -game -engine 2>&1 | ForEach-Object { $_; Out-File -FilePath $LOG -Encoding utf8 -Append -InputObject $_ }; $GEN_OK=($LASTEXITCODE -eq 0) } elseif (Test-Path $BuildBat) { Write-Host 'Using: Build.bat -projectfiles'; & $BuildBat -projectfiles $ProjArg -game -engine 2>&1 | ForEach-Object { $_; Out-File -FilePath $LOG -Encoding utf8 -Append -InputObject $_ }; $GEN_OK=($LASTEXITCODE -eq 0) } else { Write-Host 'No suitable generator found!' -ForegroundColor Red }; if (-not $GEN_OK) { Write-Host 'GenerateProjectFiles failed!' -ForegroundColor Red; Read-Host 'Press Enter to exit'; exit 1 }; Write-Host 'Project files generated.' -ForegroundColor Green; Write-Host ''; Write-Host '=== Step 2/2: Build Editor Target ===' -ForegroundColor Cyan; $EditorProjArg = '-Project=' + $UP; & '%UE_PATH%\Engine\Build\BatchFiles\Build.bat' %TARGET_NAME% %BUILD_PLATFORM% %BUILD_CONFIG% $EditorProjArg -WaitMutex -FromMsBuild 2>&1 | ForEach-Object { $_; Out-File -FilePath '%BUILD_LOG%' -Encoding utf8 -Append -InputObject $_ }; if ($LASTEXITCODE -eq 0) { Write-Host 'Build completed successfully.' -ForegroundColor Green } else { Write-Host 'Build failed with error code' $LASTEXITCODE -ForegroundColor Red }; Write-Host 'Check ProjectBuildLog.txt for full details.'; Read-Host 'Press Enter to exit'"