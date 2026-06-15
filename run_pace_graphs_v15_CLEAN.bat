@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo ============================================================
echo Pace Graphs v15 CLEAN START
echo This runs the renamed file: app_v15_clean_compare.py
echo Folder: %CD%
echo URL: http://localhost:8515
echo ============================================================
echo.

if not exist "%~dp0app_v15_clean_compare.py" (
    echo ERROR: app_v15_clean_compare.py was not found in this folder.
    echo Make sure this batch file is in the same folder as app_v15_clean_compare.py.
    pause
    exit /b 1
)

if exist "%~dp0__pycache__" rmdir /s /q "%~dp0__pycache__"
for /d /r "%~dp0" %%D in (__pycache__) do (
    if exist "%%D" rmdir /s /q "%%D"
)

echo Checking the Python file being launched...
python - <<PY
from pathlib import Path
p = Path(r"%~dp0app_v15_clean_compare.py")
text = p.read_text(encoding="utf-8")
print("Running file:", p.resolve())
print("Has v15 marker:", "v15 CLEAN" in text)
print("Has compare mode:", "Compare multiple flocks" in text)
print("Has old metrics selector:", 'st.multiselect("Metrics"' in text)
print("Has old partial checkbox:", 'Include latest partial week' in text)
PY

echo.
echo Closing any old Streamlit process on port 8515...
for /f "tokens=5" %%P in ('netstat -ano ^| findstr ":8515" ^| findstr "LISTENING"') do taskkill /PID %%P /F >nul 2>&1

echo Clearing Streamlit cache...
python -m streamlit cache clear

echo.
echo Starting Pace Graphs v15 on http://localhost:8515
echo Use this new 8515 browser tab, not the old 8501 tab.
echo.
python -m streamlit run "%~dp0app_v15_clean_compare.py" --server.port 8515 --server.address localhost --server.headless false

pause
