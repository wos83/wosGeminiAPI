object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'FrmMain'
  ClientHeight = 606
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object svN1: TSplitter
    AlignWithMargins = True
    Left = 3
    Top = 316
    Width = 778
    Height = 4
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 314
  end
  object btnOK: TButton
    AlignWithMargins = True
    Left = 3
    Top = 578
    Width = 778
    Height = 25
    Align = alBottom
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnOKClick
    ExplicitTop = 577
    ExplicitWidth = 774
  end
  object mmoChat: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 326
    Width = 778
    Height = 120
    Align = alBottom
    Lines.Strings = (
      'Chat')
    ScrollBars = ssVertical
    TabOrder = 1
    ExplicitTop = 325
    ExplicitWidth = 774
  end
  object mmoCode: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 452
    Width = 778
    Height = 120
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '#'
      '# WOS (Gemini) Google'
      '# C'#243'digo-Fonte em Python interpretado pelo Delphi'
      '# Atualiza'#231#227'o: 2024.03.28 - 15:53:16'
      '#'
      ''
      'import asyncio'
      'import datetime'
      'import sqlite3'
      'import os'
      'import markdown'
      'from gemini_webapi import GeminiClient'
      ''
      ''
      'async def convertToBinaryData(filename):'
      '    with open(filename, "rb") as file:'
      '        blobData = file.read()'
      '    return blobData'
      ''
      ''
      'async def main():'
      '    task_begin = datetime.datetime.now()'
      ''
      '    print(f" ** Come'#231'ou em {task_begin} ** ")'
      '    print(f"\n")'
      ''
      '    current_date = datetime.datetime.now().strftime("%Y%m%d")'
      
        '    current_time = datetime.datetime.now().strftime("%Y%m%d-%H%M' +
        '%S")'
      ''
      '    directory = os.path.join("#directory", "results")'
      '    # directory = os.path.join(os.getcwd(), "results")'
      
        '    file_db = os.path.join(directory, "gemini-" + current_date +' +
        ' ".db")'
      ''
      '    if not os.path.exists(directory):'
      '        os.mkdir(directory)'
      ''
      '    conn = sqlite3.connect(file_db)'
      '    cursor = conn.cursor()'
      ''
      '    cursor.execute('
      '        """'
      '    CREATE TABLE IF NOT EXISTS GEMINI ('
      '    ID_GEMINI INTEGER PRIMARY KEY AUTOINCREMENT'
      '    ,NR_GEMINI VARCHAR(255) DEFAULT 0'
      '    ,DS_PROMPT TEXT DEFAULT NULL'
      '    ,DS_RESULT TEXT DEFAULT NULL'
      '    ,NR_RESULT VARCHAR(255) DEFAULT NULL'
      '    ,DS_HTML TEXT DEFAULT NULL'
      '    ,DS_FILE_HTML VARCHAR(255) DEFAULT NULL'
      '    ,DS_OBS TEXT DEFAULT NULL'
      '    ,FL_REG_STATUS INTEGER DEFAULT 1'
      '    ,DT_REG_INS DATETIME DEFAULT CURRENT_TIMESTAMP'
      '    ,DT_REG_UPD DATETIME DEFAULT NULL'
      '    ,DT_REG_DEL DATETIME DEFAULT NULL'
      '    )"""'
      '    )'
      ''
      '    prompt = """#prompt"""'
      
        '    # prompt = """create 4 images of panda, realistic, photograp' +
        'hic, cinematographic """'
      ''
      '    client = GeminiClient()'
      ''
      '    await client.init('
      '        verbose=False,'
      '        timeout=30,'
      '        auto_close=False,'
      '        close_delay=300,'
      '        auto_refresh=True,'
      '    )'
      ''
      '    response = await client.generate_content(prompt)'
      ''
      '    for candidate in response.candidates:'
      '        print(candidate.text)'
      ''
      '        html_images = ""'
      '        for image in response.images:'
      '            html_images = f"""{html_images}<br>\n'
      '            <label>{image.title} {image.alt}</label><br>\n'
      '            <img src="{image.url}"\n'
      '            alt="{image.alt}" width="512" height="512">\n"""'
      ''
      '        html_string = f"""'
      '        <!DOCTYPE html>'
      '        <html lang="pt-BR">'
      '        <head>'
      '        <meta charset="utf-8">'
      '            <title>Gemini API (Google) {task_begin}</title>'
      
        '            <link href='#39'https://fonts.googleapis.com/css?family=' +
        'PT+Sans'#39
      '        rel='#39'stylesheet'#39' type='#39'text/css'#39'>'
      '            <style>'
      '                body {{'
      '                    font-family: PT Sans;'
      '                }}'
      '            </style>'
      '        </head>'
      '        <body>'
      '            {markdown.markdown(candidate.text)}'
      '            {html_images}'
      '        </body>'
      '        </html>'
      '        """'
      ''
      
        '        file_html = os.path.join(directory, "gemini-answer-" + c' +
        'urrent_time + ".html")'
      '        with open(file_html, "w", encoding="utf-8") as file:'
      '            file.write(html_string)'
      '        file_html_bin = await convertToBinaryData(file_html)'
      ''
      '        task_end = datetime.datetime.now()'
      '        task_total = task_end - task_begin'
      ''
      '        print(f"\n")'
      '        print(f" ** Terminou em {task_begin} ** ")'
      '        print(f" ** Tempo de Processamento: {task_total} ** ")'
      '        print(f"\n")'
      ''
      '        conn = sqlite3.connect(file_db)'
      '        cursor = conn.cursor()'
      ''
      '        cursor.execute('
      '            """'
      '        INSERT INTO GEMINI ('
      '        DS_PROMPT'
      '        ,DS_RESULT'
      '        ,NR_RESULT'
      '        ,DS_HTML'
      '        ,DS_FILE_HTML'
      '        ) VALUES (?,?,?,?,?)""",'
      '            ('
      '                str(prompt),'
      '                str(candidate.text),'
      '                str(task_total),'
      '                file_html_bin,'
      '                file_html,'
      '            ),'
      '        )'
      ''
      '        conn.commit()'
      '        conn.close()'
      ''
      '        # os.remove(file_html)'
      ''
      ''
      'asyncio.run(main())'
      '')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
    ExplicitTop = 451
    ExplicitWidth = 774
  end
  object pnlContent: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 778
    Height = 307
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 774
    ExplicitHeight = 306
    object pgcMain: TPageControl
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 770
      Height = 299
      ActivePage = tsHTML
      Align = alClient
      MultiLine = True
      TabOrder = 0
      ExplicitWidth = 766
      ExplicitHeight = 298
      object tsResponse: TTabSheet
        Caption = 'Result'
        ImageIndex = 1
        object mmoResponse: TMemo
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 756
          Height = 263
          Align = alClient
          Lines.Strings = (
            'Result')
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object tsHTML: TTabSheet
        Caption = 'Result +'
        ImageIndex = 1
        object ebResponse: TEdgeBrowser
          Left = 0
          Top = 0
          Width = 762
          Height = 269
          Align = alClient
          TabOrder = 0
          UserDataFolder = '%LOCALAPPDATA%\bds.exe.WebView2'
          ExplicitWidth = 758
          ExplicitHeight = 268
        end
      end
    end
  end
  object pyEngine: TPythonEngine
    DatetimeConversionMode = dcmToDatetime
    IO = pyInOut
    Left = 192
    Top = 348
  end
  object pyInOut: TPythonGUIInputOutput
    MaxLines = 16384
    MaxLineLength = 4096
    UnicodeIO = True
    RawOutput = False
    Output = mmoResponse
    Left = 300
    Top = 348
  end
  object pyInOutNot: TPythonGUIInputOutput
    MaxLines = 16384
    MaxLineLength = 4096
    UnicodeIO = True
    RawOutput = False
    Left = 420
    Top = 348
  end
end
