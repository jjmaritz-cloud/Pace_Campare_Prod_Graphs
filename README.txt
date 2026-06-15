Pace Graphs - Amino Eggsactly Graph App v15 CLEAN

How to run:
1. Unzip this whole folder anywhere, for example: C:\Projects\Pace Graphs
2. Double-click: run_pace_graphs_v15_CLEAN.bat
3. The app will open at: http://localhost:8515

Important:
- Use the 8515 tab opened by this batch file, not older localhost:8501 tabs.
- The app runs app_v15_clean_compare.py directly so it cannot accidentally load an old app.py.
- The Excel backend files are in the data folder.

Included files:
- app_v15_clean_compare.py       Main Streamlit app
- app.py                         Same app, included as backup/convenience
- run_pace_graphs_v15_CLEAN.bat  Clean start batch file
- requirements.txt               Python package list
- data/Amino_Eggsactly_Data_V1.xlsx
- data/Amino_Eggsactly_Rearing_Layer_Match.xlsx

Updating data:
- Upload the refreshed Amino_Eggsactly_Data_V1.xlsx from the sidebar, or replace the file in the data folder.
- Previous data files are backed up in data/backups.

Current features:
- Saved Excel backend data
- Cross-farm compare mode
- Fixed default metrics
- Plotly legend show/hide
- Standards shown once
- Latest partial week excluded in the background
