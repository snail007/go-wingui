object Form1: TForm1
  Left = 480
  Top = 109
  Width = 777
  Height = 428
  BorderIcons = [biSystemMenu, biMinimize]
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ChromiumWindow1: TChromiumWindow
    Left = 0
    Top = 0
    Width = 761
    Height = 390
    Align = alClient
    TabOrder = 0
    OnAfterCreated = ChromiumWindow1AfterCreated
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 300
    OnTimer = Timer1Timer
    Left = 56
    Top = 88
  end
  object Chromium1: TChromium
    OnLoadEnd = Chromium1LoadEnd
    OnRunContextMenu = Chromium1RunContextMenu
    OnContextMenuCommand = Chromium1ContextMenuCommand
    OnBeforePopup = Chromium1BeforePopup
    Left = 72
    Top = 48
  end
  object pm1: TPopupMenu
    Left = 160
    Top = 88
    object m_exit: TMenuItem
      Caption = #36864#20986
      OnClick = m_exitClick
    end
  end
end
