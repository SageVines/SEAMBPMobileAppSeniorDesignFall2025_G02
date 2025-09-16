Update .gitignore as project is expanded so as not to commit certain files which will cause project to fail build. <br>

Note: Backend NEEDS .venv as it keeps Python packages separate from system packages and global packages <br>

**To Implement VENV and run backend** <br>
cd backend <br>
py -3.12 -m venv .venv <br>
.\.venv\Scripts\Activate.ps1 <br>
pip install -r requirements.txt <br>
uvicorn app.main:app --reload <br>

Note: DO NOT COMMIT VENV
