@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"

title Pace Graphs v15 CLEAN

echo ============================================================
echo Pace Graphs v15 CLEAN START - Windows fixed launcher
echo Folder: %CD%
echo App file: app_v15_clean_compare.py
echo URL: http://localhost:8515
echo ============================================================
echo.

if not exist "%CD%\app_v15_clean_compare.py" (
    echo ERROR: app_v15_clean_compare.py was not found in this folder.
    echo.
    echo Make sure you unzipped the whole app pack and are running this BAT
    echo from the same folder as app_v15_clean_compare.py.
    echo.
    pause
    exit /b 1
)

if not exist "%CD%\data\Amino_Eggsactly_Data_V1.xlsx" (
    echo ERROR: data\Amino_Eggsactly_Data_V1.xlsx was not found.
    echo Please make sure the data folder was copied/unzipped.
    echo.
    pause
    exit /b 1
)

if not exist "%CD%\data\Amino_Eggsactly_Rearing_Layer_Match.xlsx" (
    echo ERROR: data\Amino_Eggsactly_Rearing_Layer_Match.xlsx was not found.
    echo Please make sure the data folder was copied/unzipped.
    echo.
    pause
    exit /b 1
)

echo Checking Python...
where py >nul 2>&1
if %ERRORLEVEL%==0 (
    set PYLAUNCH=py -3
) else (
    where python >nul 2>&1
    if %ERRORLEVEL%==0 (
        set PYLAUNCH=python
    ) else (
        echo ERROR: Python was not found on this computer.
        echo Install Python 3.11+ and tick "Add Python to PATH".
        echo.
        pause
        exit /b 1
    )
)

echo Using Python launcher: %PYLAUNCH%
%PYLAUNCH% --version
if errorlevel 1 (
    echo ERROR: Python could not start.
    pause
    exit /b 1
)

echo.
echo Creating virtual environment if needed...
if not exist "%CD%\.venv\Scripts\python.exe" (
    %PYLAUNCH% -m venv "%CD%\.venv"
    if errorlevel 1 (
        echo ERROR: Could not create virtual environment.
        pause
        exit /b 1
    )
)

set VPY=%CD%\.venv\Scripts\python.exe

echo.
echo Installing/updating required packages...
"%VPY%" -m pip install --upgrade pip
if errorlevel 1 (
    echo ERROR: pip upgrade failed.
    pause
    exit /b 1
)

if exist "%CD%\requirements.txt" (
    "%VPY%" -m pip install -r "%CD%\requirements.txt"
) else (
    "%VPY%" -m pip install streamlit pandas numpy plotly openpyxl
)
if errorlevel 1 (
    echo ERROR: Package install failed.
    pause
    exit /b 1
)

echo.
echo Confirming correct app version markers...
"%VPY%" -c "from pathlib import Path; p=Path('app_v15_clean_compare.py'); t=p.read_text(encoding='utf-8'); print('Running file:', p.resolve()); print('Has v15 marker:', 'v15 CLEAN' in t); print('Has compare mode:', 'Compare multiple flocks' in t); print('Has old metrics selector:', 'st.multiselect(\"Metrics\"' in t)"
if errorlevel 1 (
    echo ERROR: Could not inspect app file.
    pause
    exit /b 1
)

echo.
echo Removing Python cache folders...
if exist "%CD%\__pycache__" rmdir /s /q "%CD%\__pycache__"
for /d /r "%CD%" %%D in (__pycache__) do (
    if exist "%%D" rmdir /s /q "%%D"
)

echo.
echo Closing old Streamlit process on port 8515 if one exists...
for /f "tokens=5" %%P in ('netstat -ano ^| findstr ":8515" ^| findstr "LISTENING"') do taskkill /PID %%P /F >nul 2>&1

echo.
echo Clearing Streamlit cache...
"%VPY%" -m streamlit cache clear

echo.
echo ============================================================
echo Starting Pace Graphs v15 CLEAN on http://localhost:8515
echo IMPORTANT: Use the 8515 browser tab, not old 8501 tabs.
echo Keep this black window open while using the app.
echo ============================================================
echo.
"%VPY%" -m streamlit run "%CD%\app_v15_clean_compare.py" --server.port 8515 --server.address localhost --server.headless false

echo.
echo Streamlit stopped or failed. Review any error above.
pause
