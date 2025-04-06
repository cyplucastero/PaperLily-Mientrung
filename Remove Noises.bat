
@echo off
if "%1"=="skip.build" goto REMOVE_NOISES

for /f "usebackq delims=" %%i in (`"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere" -prerelease -latest -property installationPath`) do (
  if exist "%%i\Common7\Tools\vsdevcmd.bat" call "%%i\Common7\Tools\vsdevcmd.bat"
)

echo Build Tools
cd LacieEngineLog
msbuild -p:Configuration=Release -p:Platform=x64 -restore -m
if %errorlevel% neq 0 (
    echo Failed to build tools
    pause
    exit /b %errorlevel%
)
cd ..
echo+

:REMOVE_NOISES
echo Remove Noises
call LacieEngineLog\RemoveFodsNoises\bin\x64\Release\net7.0\RemoveFodsNoises
if %errorlevel% neq 0 (
    echo Failed to Remove Noises
    pause
    exit /b %errorlevel%
)
echo+
