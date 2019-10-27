object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'RDP Port Knocking'
  ClientHeight = 395
  ClientWidth = 504
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PanelMain: TPanel
    Left = 0
    Top = 0
    Width = 504
    Height = 395
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object GbRdpService: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 498
      Height = 80
      Align = alTop
      Caption = 'Remote Desktop'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object GpRdpService: TGridPanel
        AlignWithMargins = True
        Left = 5
        Top = 18
        Width = 488
        Height = 57
        Align = alClient
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = RdpPortLbl
            Row = 0
          end
          item
            Column = 1
            Control = RdpPortIpt
            Row = 0
          end
          item
            Column = 0
            Control = RdpStatusLbl
            Row = 1
          end
          item
            Column = 1
            Control = RdpStatusIpt
            Row = 1
          end>
        RowCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        ShowCaption = False
        TabOrder = 0
        object RdpPortLbl: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 238
          Height = 22
          Align = alClient
          Alignment = taCenter
          Caption = 'Port'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 21
          ExplicitHeight = 13
        end
        object RdpPortIpt: TLabel
          AlignWithMargins = True
          Left = 247
          Top = 3
          Width = 238
          Height = 22
          Align = alClient
          Alignment = taCenter
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsUnderline]
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
          OnClick = RdpPortIptClick
          ExplicitWidth = 6
          ExplicitHeight = 13
        end
        object RdpStatusLbl: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 31
          Width = 238
          Height = 23
          Align = alClient
          Alignment = taCenter
          Caption = 'Status'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
          ExplicitTop = 29
          ExplicitWidth = 32
          ExplicitHeight = 13
        end
        object RdpStatusIpt: TLabel
          AlignWithMargins = True
          Left = 247
          Top = 31
          Width = 238
          Height = 23
          Align = alClient
          Alignment = taCenter
          Caption = 'DISABLED'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsUnderline]
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
          OnClick = RdpStatusIptClick
          ExplicitTop = 29
          ExplicitWidth = 50
          ExplicitHeight = 13
        end
      end
    end
    object GbPortKnocking: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 89
      Width = 498
      Height = 80
      Align = alTop
      Caption = 'Port Knocking'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      object GpPortKnocking: TGridPanel
        AlignWithMargins = True
        Left = 5
        Top = 18
        Width = 488
        Height = 57
        Align = alClient
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 33.333333333333340000
          end
          item
            Value = 33.333333333333340000
          end
          item
            Value = 33.333333333333340000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = NetPort1Lbl
            Row = 0
          end
          item
            Column = 1
            Control = NetPort2Lbl
            Row = 0
          end
          item
            Column = 2
            Control = NetPort3Lbl
            Row = 0
          end
          item
            Column = 0
            Control = NetPort1Ipt
            Row = 1
          end
          item
            Column = 1
            Control = NetPort2Ipt
            Row = 1
          end
          item
            Column = 2
            Control = NetPort3Ipt
            Row = 1
          end>
        RowCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        ShowCaption = False
        TabOrder = 0
        object NetPort1Lbl: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 156
          Height = 22
          Align = alClient
          Alignment = taCenter
          Caption = 'Port 1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 30
          ExplicitHeight = 13
        end
        object NetPort2Lbl: TLabel
          AlignWithMargins = True
          Left = 165
          Top = 3
          Width = 156
          Height = 22
          Align = alClient
          Alignment = taCenter
          Caption = 'Port 2'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 30
          ExplicitHeight = 13
        end
        object NetPort3Lbl: TLabel
          AlignWithMargins = True
          Left = 327
          Top = 3
          Width = 158
          Height = 22
          Align = alClient
          Alignment = taCenter
          Caption = 'Port 3'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 30
          ExplicitHeight = 13
        end
        object NetPort1Ipt: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 31
          Width = 156
          Height = 23
          Align = alClient
          Alignment = taCenter
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsUnderline]
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
          OnClick = NetPort1IptClick
          ExplicitTop = 29
          ExplicitWidth = 6
          ExplicitHeight = 13
        end
        object NetPort2Ipt: TLabel
          AlignWithMargins = True
          Left = 165
          Top = 31
          Width = 156
          Height = 23
          Align = alClient
          Alignment = taCenter
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsUnderline]
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
          OnClick = NetPort2IptClick
          ExplicitTop = 29
          ExplicitWidth = 6
          ExplicitHeight = 13
        end
        object NetPort3Ipt: TLabel
          AlignWithMargins = True
          Left = 327
          Top = 31
          Width = 158
          Height = 23
          Align = alClient
          Alignment = taCenter
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsUnderline]
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
          OnClick = NetPort3IptClick
          ExplicitTop = 29
          ExplicitWidth = 6
          ExplicitHeight = 13
        end
      end
    end
    object GbStatus: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 175
      Width = 498
      Height = 80
      Align = alTop
      Caption = 'Status'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      object GpStatus: TGridPanel
        AlignWithMargins = True
        Left = 5
        Top = 18
        Width = 488
        Height = 53
        Align = alTop
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = StatusAccessLbl
            Row = 0
          end
          item
            Column = 1
            Control = StatusAccessIpt
            Row = 0
          end
          item
            Column = 0
            Control = StatusSvcLbl
            Row = 1
          end
          item
            Column = 1
            Control = StatusSvcIpt
            Row = 1
          end>
        ParentShowHint = False
        RowCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        ShowCaption = False
        ShowHint = False
        TabOrder = 0
        object StatusAccessLbl: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 238
          Height = 20
          Align = alClient
          Alignment = taCenter
          Caption = 'Access'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 33
          ExplicitHeight = 13
        end
        object StatusAccessIpt: TLabel
          AlignWithMargins = True
          Left = 247
          Top = 3
          Width = 238
          Height = 20
          Align = alClient
          Alignment = taCenter
          Caption = 'LOCKED'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 41
          ExplicitHeight = 13
        end
        object StatusSvcLbl: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 29
          Width = 238
          Height = 21
          Align = alClient
          Alignment = taCenter
          Caption = 'Service'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 35
          ExplicitHeight = 13
        end
        object StatusSvcIpt: TLabel
          AlignWithMargins = True
          Left = 247
          Top = 29
          Width = 238
          Height = 21
          Align = alClient
          Alignment = taCenter
          Caption = 'STOPPED'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 46
          ExplicitHeight = 13
        end
      end
    end
    object GpBtns: TGridPanel
      AlignWithMargins = True
      Left = 3
      Top = 361
      Width = 498
      Height = 31
      Align = alBottom
      BevelOuter = bvNone
      ColumnCollection = <
        item
          Value = 50.000000000000000000
        end
        item
          Value = 50.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = SbStart
          Row = 0
        end
        item
          Column = 1
          Control = SbStop
          Row = 0
        end>
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      ShowCaption = False
      TabOrder = 3
      object SbStart: TSpeedButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 243
        Height = 25
        Align = alClient
        AllowAllUp = True
        Caption = 'Start'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = SbStartClick
        ExplicitLeft = 200
        ExplicitTop = 24
        ExplicitWidth = 23
        ExplicitHeight = 22
      end
      object SbStop: TSpeedButton
        AlignWithMargins = True
        Left = 252
        Top = 3
        Width = 243
        Height = 25
        Align = alClient
        AllowAllUp = True
        Caption = 'Stop'
        Enabled = False
        OnClick = SbStopClick
        ExplicitLeft = 312
        ExplicitTop = 8
        ExplicitWidth = 23
        ExplicitHeight = 22
      end
    end
    object GbLog: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 261
      Width = 498
      Height = 94
      Align = alClient
      Caption = 'Messages'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      object MemoMain: TMemo
        AlignWithMargins = True
        Left = 5
        Top = 18
        Width = 488
        Height = 71
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  object TimerTrimAppMemory: TTimer
    Interval = 86400000
    OnTimer = TimerTrimAppMemoryTimer
    Left = 328
    Top = 304
  end
  object ServSock1: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnListen = ServSock1Listen
    OnClientConnect = ServSock1ClientConnect
    Left = 27
    Top = 301
  end
  object ServSock2: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnListen = ServSock2Listen
    OnClientConnect = ServSock2ClientConnect
    Left = 83
    Top = 301
  end
  object ServSock3: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnListen = ServSock3Listen
    OnClientConnect = ServSock3ClientConnect
    Left = 139
    Top = 301
  end
  object TimerClearConnCache: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = TimerClearConnCacheTimer
    Left = 219
    Top = 301
  end
  object TimerLockRDP: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = TimerLockRDPTimer
    Left = 419
    Top = 301
  end
end
