Update .gitignore as project is expanded so as not to commit certain files which will cause project to fail build. <br>

Note: Backend NEEDS .venv as it keeps Python packages separate from system packages and global packages <br>

**To Implement VENV and run backend** <br>
cd backend <br>
py -3.12 -m venv .venv <br>
.\.venv\Scripts\Activate.ps1 <br>
pip install -r requirements.txt <br>
uvicorn app.main:app --reload <br>

Note: DO NOT COMMIT VENV <br>

**For frontend** <br>
- only lib files are used <br>
- flutter pub outdated <br>
- flutter pub upgrade --major-versions <br>
- flutter pub get <br>
- flutter devices <br>
- flutter emulators <br>
- where flutter <br>
- flutter doctor <br>

- After Starting up phone emulator, use command: "flutter run -d emulator-5554" in terminal while cd'd into front end directory <br>


**For Machine Learning** <br>
- pip install tensorflow <br>



**Misc Command** <br>
-  pip install "pydantic>=2.7,<3.0" <br>
-  python --version <br>
- pip install --upgrade pip setuptools wheel <br>
- .\venv\Scripts\activate <br>
-  py -m venv venv  <br>
- flutter run <br>
- python -m pip install --upgrade pip <br>
- flutter --version <br>


**Notes** <br>
- Python 3.12 is used to not involve Rust (DO NOT USE HIGHER VERSIONS OF PYTHON IF POSSIBLE) <br>
