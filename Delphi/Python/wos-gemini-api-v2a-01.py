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
    prompt = """Atue como um Investidor e Trader da Bolsa de Valores.
Você tem mais de 30 anos de experiência em analise grafica e fundamentalista.
Analise a ação do ticket PETR4 e mensione alguma noticia relevante.
Traga todoas as informações do pregão de hoje, preço atual, preço médio, preço mais alto, preço mais baixo, volume negociado em R$ e quantidade de ações negociadas.
Sugira os níveis de suporte e resistencia do dia e o semanal.
Aponte uma tendencia para aonde esta indo o preço nos próximos dias.
Faça uma comparação de quantos porcento ela representa na IBOVESPA."""
    response = await client.generate_content(prompt)
    print(response.text)


asyncio.run(main())
