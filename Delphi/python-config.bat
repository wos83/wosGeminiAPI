@echo off
chcp 65001

rem https://github.com/HanaokaYuzu/Gemini-API.git

python --version
python -m pip install --upgrade pip

pip install markdown
pip install mistune
pip install translang
pip install opengpt

pip install -U gemini_webapi
pip install -U browser-cookie3