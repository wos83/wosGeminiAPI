@echo off
chcp 65001

python --version
python -m pip install --upgrade pip

python -m pip install asyncio
python -m pip install mistune
python -m pip install translang
python -m pip install browser-cookie3
python -m pip install gemini_webapi

python -m pip install -U asyncio
python -m pip install -U mistune
python -m pip install -U translang
python -m pip install -U browser-cookie3
python -m pip install -U gemini_webapi