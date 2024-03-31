#
# WOS (Gemini) Google
# Código-Fonte em Python interpretado pelo Delphi
# Atualização: 2024.03.28 - 15:53:16
#

import asyncio
import datetime
import sqlite3
import os
import markdown
from gemini_webapi import GeminiClient


async def convertToBinaryData(filename):
    with open(filename, "rb") as file:
        blobData = file.read()
    return blobData


async def main():
    task_begin = datetime.datetime.now()

    print(f" ** Começou em {task_begin} ** ")
    print(f"\n")

    current_date = datetime.datetime.now().strftime("%Y%m%d")
    current_time = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")

    # directory = os.path.join("#directory", "results")
    directory = os.path.join(os.getcwd(), "results")
    file_db = os.path.join(directory, "gemini-" + current_date + ".db")

    if not os.path.exists(directory):
        os.mkdir(directory)

    conn = sqlite3.connect(file_db)
    cursor = conn.cursor()

    cursor.execute(
        """
    CREATE TABLE IF NOT EXISTS GEMINI (
    ID_GEMINI INTEGER PRIMARY KEY AUTOINCREMENT
    ,NR_GEMINI VARCHAR(255) DEFAULT 0
    ,DS_PROMPT TEXT DEFAULT NULL
    ,DS_RESULT TEXT DEFAULT NULL
    ,NR_RESULT VARCHAR(255) DEFAULT NULL
    ,DS_HTML TEXT DEFAULT NULL
    ,DS_FILE_HTML VARCHAR(255) DEFAULT NULL    
    ,DS_OBS TEXT DEFAULT NULL
    ,FL_REG_STATUS INTEGER DEFAULT 1
    ,DT_REG_INS DATETIME DEFAULT CURRENT_TIMESTAMP
    ,DT_REG_UPD DATETIME DEFAULT NULL
    ,DT_REG_DEL DATETIME DEFAULT NULL
    )"""
    )

    # prompt = """#prompt"""
    prompt = """create 4 images of panda, realistic, photographic, cinematographic """

    client = GeminiClient()

    await client.init(
        verbose=False,
        timeout=30,
        auto_close=False,
        close_delay=300,
        auto_refresh=True,
    )

    response = await client.generate_content(prompt)

    for candidate in response.candidates:
        print(candidate.text)

        html_images = ""
        for image in response.images:
            html_images = f"""{html_images}<br>\n
            <label>{image.title} {image.alt}</label><br>\n
            <img src="{image.url}"\n
            alt="{image.alt}" width="512" height="512">\n"""

        html_string = f"""
        <!DOCTYPE html>
        <html lang="pt-BR">
        <head>
        <meta charset="utf-8">
            <title>Gemini API (Google) {task_begin}</title>
            <link href='https://fonts.googleapis.com/css?family=PT+Sans' 
        rel='stylesheet' type='text/css'>
            <style>
                body {{
                    font-family: PT Sans;
                }}
            </style>
        </head>
        <body>
            {markdown.markdown(candidate.text)}
            {html_images}
        </body>
        </html>
        """

        file_html = os.path.join(directory, "gemini-answer-" + current_time + ".html")
        with open(file_html, "w", encoding="utf-8") as file:
            file.write(html_string)
        file_html_bin = await convertToBinaryData(file_html)

        task_end = datetime.datetime.now()
        task_total = task_end - task_begin

        print(f"\n")
        print(f" ** Terminou em {task_begin} ** ")
        print(f" ** Tempo de Processamento: {task_total} ** ")
        print(f"\n")

        conn = sqlite3.connect(file_db)
        cursor = conn.cursor()

        cursor.execute(
            """
        INSERT INTO GEMINI (
        DS_PROMPT
        ,DS_RESULT
        ,NR_RESULT
        ,DS_HTML
        ,DS_FILE_HTML
        ) VALUES (?,?,?,?,?)""",
            (
                str(prompt),
                str(candidate.text),
                str(task_total),
                file_html_bin,
                file_html,
            ),
        )

        conn.commit()
        conn.close()

        # os.remove(file_html)


asyncio.run(main())
