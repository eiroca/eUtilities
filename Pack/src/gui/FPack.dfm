object fmPack: TfmPack
  Left = 200
  Top = 108
  Caption = 'fmPack'
  ClientHeight = 446
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object tvPack: TTreeView
    Left = 0
    Top = 178
    Width = 688
    Height = 268
    Align = alBottom
    Indent = 19
    TabOrder = 0
  end
  object meOut: TRichEdit
    Left = 0
    Top = 41
    Width = 688
    Height = 137
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'meOut')
    ParentFont = False
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 41
    Align = alTop
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 14
      Width = 34
      Height = 13
      Caption = 'Source'
    end
    object Label2: TLabel
      Left = 183
      Top = 14
      Width = 20
      Height = 13
      Caption = 'Size'
    end
    object Label3: TLabel
      Left = 271
      Top = 14
      Width = 16
      Height = 13
      Caption = 'MB'
    end
    object iSource: TEdit
      Left = 53
      Top = 12
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'c:\temp'
    end
    object iSize: TEdit
      Left = 213
      Top = 12
      Width = 52
      Height = 21
      TabOrder = 1
      Text = '640'
    end
  end
  object MainMenu1: TMainMenu
    Left = 402
    Top = 7
    object Action1: TMenuItem
      Caption = 'Action'
      object Generate1: TMenuItem
        Caption = 'Generate'
        OnClick = Generate1Click
      end
    end
  end
end
