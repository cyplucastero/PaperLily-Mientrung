
@echo off
echo This script will create a translation PCK file for Paper Lily with the files located in the "package" folder.
echo Make sure the Export Templates have been installed in the Godot Engine!
echo.

if "%1"=="skip.build" goto EXPORT_CSV
if "%1"=="skip.build.csv" goto MAKE_PCK

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

:EXPORT_CSV
echo Export csv files
call LacieEngineLog\Fods2CsvPo\bin\x64\Release\net8.0\Fods2CsvPo PaperLily po
if %errorlevel% neq 0 (
    echo Failed to export csv/po files
    pause
    exit /b %errorlevel%
)
echo+

:MAKE_PCK
echo Remove the old file
del translation_vi.pck

echo Move to the package folder
cd package

echo Export the PCK file with the translation assets
..\godot.exe --no-window --export "Pack Exporter" ../translation_vi.pck
echo+
if %errorlevel% neq 0 (
    echo Failed to export pck file
    pause
    exit /b %errorlevel%
)

echo Add the definition files to the previously created PCK
..\godotpcktool.exe ..\translation_vi.pck -a a definitions
echo+
if %errorlevel% neq 0 (
    echo Failed to add csv/po files to the pck file
    pause
    exit /b %errorlevel%
)

echo Done! If you see no errors above, then the translation.pck file should have been created.
echo+

pause