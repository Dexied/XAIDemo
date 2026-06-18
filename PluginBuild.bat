@echo off
B:\UnrealEngine\UE_5.8\Engine\Build\BatchFiles\RunUAT.bat BuildPlugin -Plugin="B:\Projects\XAIDemo\Plugins\XAI\XAI.uplugin" -Package="B:\Projects\XAIDemo\Builds\XAI" -Rocket -2019 > "B:\Projects\XAIDemo\BuildLog.txt" 2>&1
echo Build completed. Check BuildLog.txt for details.
pause