# https://github.com/HanaokaYuzu/Gemini-API
# pip install -U gemini_webapi
# pip install -U browser-cookie3

import asyncio
from gemini_webapi import GeminiClient


async def main():
    client = GeminiClient()
    await client.init(
        verbose=False,
        timeout=30,
        auto_close=False,
        close_delay=300,
        auto_refresh=True,
    )
    prompt = """Descreva a imagem"""

    image = "wos-gemini-api-v2a-02.jpg"

    response = await client.generate_content(prompt, image)
    print(response.text)


asyncio.run(main())
