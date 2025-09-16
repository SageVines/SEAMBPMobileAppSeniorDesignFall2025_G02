Update .gitignore as project is expanded so as not to commit certain files which will cause project to fail build.

Note: Backend NEEDS .venv as it keeps Python packages separate from system packages and global packages

**To Implement VENV and run backend**
cd backend
py -3.12 -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
uvicorn app.main:app --reload

Note: DO NOT COMMIT VENV
