object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'HTTP Get'
  ClientHeight = 326
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object meInput: TRichEdit
    Left = 0
    Top = 0
    Width = 426
    Height = 326
    Align = alClient
    TabOrder = 0
    WordWrap = False
  end
  object MainMenu1: TMainMenu
    Left = 192
    Top = 104
    object File1: TMenuItem
      Caption = '&File'
      object miConfigure: TMenuItem
        Caption = '&Configuration'
        OnClick = miConfigureClick
      end
      object miDownload: TMenuItem
        Caption = 'Start &download'
        OnClick = miDownloadClick
      end
      object miExit: TMenuItem
        Caption = 'E&xit'
        OnClick = miExitClick
      end
    end
  end
end
