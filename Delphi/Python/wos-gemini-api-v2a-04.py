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
    prompt = """Create images of Lions, African savanna, cinematic images, high resolution, high level of detail on your skin, full body"""
    response = await client.generate_content(prompt)
    for image in response.images:
        print(image, "\n\n----------------------------------------\n")


asyncio.run(main())
