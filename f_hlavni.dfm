object fhlavni: Tfhlavni
  Left = 0
  Top = 0
  Caption = 'fhlavni'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Button1: TButton
    Left = 470
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Run'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 176
    Top = 24
    Width = 369
    Height = 23
    TabOrder = 1
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 176
    Top = 96
    Width = 385
    Height = 23
    TabOrder = 2
    Text = 'Edit2'
  end
  object Button2: TButton
    Left = 176
    Top = 57
    Width = 75
    Height = 25
    Caption = 'Vyber vstup'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 176
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Vyber v'#253'stup'
    TabOrder = 4
    OnClick = Button3Click
  end
  object OpenDialog1: TOpenDialog
    Left = 32
    Top = 24
  end
end
