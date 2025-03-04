object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 134
  ClientWidth = 521
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Button1: TButton
    Left = 419
    Top = 85
    Width = 97
    Height = 41
    Caption = 'Run'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 40
    Width = 161
    Height = 23
    TabOrder = 1
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 316
    Top = 40
    Width = 169
    Height = 23
    TabOrder = 2
    Text = 'Edit2'
  end
  object StaticText1: TStaticText
    Left = 8
    Top = 15
    Width = 87
    Height = 19
    Caption = 'Vstupn'#237' soubor:'
    TabOrder = 3
  end
  object StaticText2: TStaticText
    Left = 340
    Top = 15
    Width = 122
    Height = 19
    Caption = 'Kde ulo'#382'it csv. soubor:'
    TabOrder = 4
  end
  object Button2: TButton
    Left = 491
    Top = 39
    Width = 25
    Height = 25
    Caption = '...'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 175
    Top = 39
    Width = 26
    Height = 25
    Caption = '...'
    TabOrder = 6
    OnClick = Button3Click
  end
  object OpenDialog1: TOpenDialog
    Left = 24
    Top = 88
  end
end
