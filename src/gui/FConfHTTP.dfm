object fmConfHTTP: TfmConfHTTP
  Left = 0
  Top = 0
  Caption = 'fmConfHTTP'
  ClientHeight = 194
  ClientWidth = 252
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 156
    Width = 252
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btOk: TBitBtn
      Left = 8
      Top = 5
      Width = 75
      Height = 25
      TabOrder = 0
      Kind = bkOK
    end
    object btCancel: TBitBtn
      Left = 96
      Top = 5
      Width = 75
      Height = 25
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 252
    Height = 156
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Proxy Configuration'
      object lbPassword: TLabel
        Left = 8
        Top = 96
        Width = 46
        Height = 13
        Caption = 'Password'
      end
      object lbUser: TLabel
        Left = 8
        Top = 72
        Width = 48
        Height = 13
        Caption = 'Username'
      end
      object Label1: TLabel
        Left = 188
        Top = 18
        Width = 4
        Height = 13
        Caption = ':'
      end
      object cbProxy: TCheckBox
        Left = 8
        Top = 17
        Width = 66
        Height = 17
        Caption = 'UseProxy'
        TabOrder = 0
        OnClick = cbProxyClick
      end
      object iProxyHost: TEdit
        Left = 92
        Top = 15
        Width = 91
        Height = 21
        TabOrder = 1
        Text = '10.1.24.4'
      end
      object iProxyUsername: TEdit
        Left = 62
        Top = 68
        Width = 171
        Height = 21
        TabOrder = 2
        OnChange = iProxyUsernameChange
      end
      object iProxyPassword: TEdit
        Left = 62
        Top = 92
        Width = 171
        Height = 21
        PasswordChar = '*'
        TabOrder = 4
        OnChange = iProxyUsernameChange
      end
      object cbProxyAuth: TCheckBox
        Left = 8
        Top = 42
        Width = 116
        Height = 17
        Caption = 'Authenticated'
        TabOrder = 3
      end
      object iProxyPort: TEdit
        Left = 199
        Top = 15
        Width = 34
        Height = 21
        TabOrder = 5
        Text = '8080'
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Anonimizer'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 276
      ExplicitHeight = 0
      object cbAnonimizer: TCheckBox
        Left = 5
        Top = 16
        Width = 180
        Height = 21
        Caption = 'Use Anonimizer'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = cbAnonimizerClick
      end
      object iAnonimizerURL: TEdit
        Left = 5
        Top = 44
        Width = 228
        Height = 21
        TabOrder = 1
        Text = 'http://www.eiroca.net/admin/proxy.php'
      end
      object cbGZ: TCheckBox
        Left = 5
        Top = 72
        Width = 88
        Height = 17
        Caption = 'Force GZIP'
        TabOrder = 2
      end
    end
  end
end
