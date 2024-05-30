# https://github.com/HanaokaYuzu/Gemini-API
# pip install -U gemini_webapi
# pip install -U browser-cookie3

import browser_cookie3
import asyncio
import os

from gemini_webapi import GeminiClient, set_log_level

set_log_level("DEBUG")


async def main():
    client = GeminiClient()

    await client.init(
        verbose=False,
        timeout=30,
        auto_close=False,
        close_delay=300,
        auto_refresh=True,
    )

    directory = os.path.join(os.getcwd(), "Delphi\\Python\\images")

    if not os.path.exists(directory):
        os.mkdir(directory)

    file_img_v1a = os.path.join(directory, "img_v1a.jpg")
    file_img_v1b = os.path.join(directory, "img_v1b.jpg")

    prompt = """Descreva todos os detalhes destas imagens"""

    response = await client.generate_content(
        prompt,
        images=[
            file_img_v1a,
            file_img_v1b,
        ],
    )
    print(response.text)


asyncio.run(main())
