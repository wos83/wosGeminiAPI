# https://github.com/HanaokaYuzu/Gemini-API
# pip install -U gemini_webapi
# pip install -U browser-cookie3

import asyncio
import os
import datetime

from gemini_webapi import set_log_level
from gemini_webapi import GeminiClient

set_log_level("DEBUG")


async def cNow():
    dh = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    return dh


async def cDir():
    directory = os.path.join(
        os.getcwd(),
        "Delphi\\Python\\images",
        datetime.datetime.now().strftime("%Y%m%d"),
    )
    if not os.path.exists(directory):
        os.mkdir(directory)
    return directory


async def main():
    client = GeminiClient()
    await client.init(
        verbose=False,
        timeout=30,
        auto_close=False,
        close_delay=300,
        auto_refresh=True,
    )
    prompt = """create images of dog, realistic, photographic, cinematic images, high resolution, high level of detail on your skin, full body, 16k"""
    response = await client.generate_content(prompt)

    for image in response.images:
        dtm = await cNow()
        dir = await cDir()
        file = f"gemini-image-{dtm}.png"
        await image.save(
            path=dir,
            filename=file,
            skip_invalid_filename=True,
            verbose=False,
        )
        # print(image, "\n\n----------------------------------------\n")


asyncio.run(main())
