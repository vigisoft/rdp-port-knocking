unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, UProjectUtilities,
  Vcl.StdCtrls, Vcl.Buttons, UWinUtilities, Math, System.Win.ScktComp, UFormUtilities;

type
  TFormMain = class(TForm)
    PanelMain: TPanel;
    TimerTrimAppMemory: TTimer;
    GbRdpService: TGroupBox;
    GbPortKnocking: TGroupBox;
    GbStatus: TGroupBox;
    GpBtns: TGridPanel;
    SbStart: TSpeedButton;
    GpRdpService: TGridPanel;
    GpPortKnocking: TGridPanel;
    GpStatus: TGridPanel;
    GbLog: TGroupBox;
    MemoMain: TMemo;
    RdpPortLbl: TLabel;
    RdpPortIpt: TLabel;
    RdpStatusLbl: TLabel;
    RdpStatusIpt: TLabel;
    NetPort1Lbl: TLabel;
    NetPort2Lbl: TLabel;
    NetPort3Lbl: TLabel;
    NetPort1Ipt: TLabel;
    NetPort2Ipt: TLabel;
    NetPort3Ipt: TLabel;
    StatusAccessLbl: TLabel;
    StatusAccessIpt: TLabel;
    StatusSvcLbl: TLabel;
    StatusSvcIpt: TLabel;
    SbStop: TSpeedButton;
    ServSock1: TServerSocket;
    ServSock2: TServerSocket;
    ServSock3: TServerSocket;
    TimerClearConnCache: TTimer;
    TimerLockRDP: TTimer;
    procedure TimerTrimAppMemoryTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure RdpPortIptClick(Sender: TObject);
    procedure RdpStatusIptClick(Sender: TObject);
    procedure SbStartClick(Sender: TObject);
    procedure ServSock1Listen(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServSock2Listen(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServSock3Listen(Sender: TObject; Socket: TCustomWinSocket);
    procedure SbStopClick(Sender: TObject);
    procedure ServSock1ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServSock2ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServSock3ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure TimerClearConnCacheTimer(Sender: TObject);
    procedure NetPort1IptClick(Sender: TObject);
    procedure NetPort3IptClick(Sender: TObject);
    procedure NetPort2IptClick(Sender: TObject);
    procedure TimerLockRDPTimer(Sender: TObject);
  private
    RdpPort: Integer;
    RdpStatus: Boolean;

    AccessStatus: Boolean;
    ServiceStatus: Boolean;

    PortKnockD1: Word;
    PortKnockD2: Word;
    PortKnockD3: Word;

    PortKnocks: array of Word;

    procedure SetRdpStatus(Enabled: Boolean);
    procedure SetAccessStatus(Enabled: Boolean);
    procedure SetServiceStatus(Enabled: Boolean);

    procedure ChangeNetServicePort(PortId: Integer; DefPort: Word);
    procedure CheckConnection(Port: Integer; Socket: TCustomWinSocket);

    procedure WriteLog(Msg: String; LogType: TLogType = ltInfo);
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

const
  DEF_RDP_PORT=3389;

  ROOT = HKEY_LOCAL_MACHINE;

  TREE_TS = 'SYSTEM\CurrentControlSet\Control\Terminal Server';
  TREE_RDP = TREE_TS + '\WinStations\RDP-Tcp';
  KEY_RDP_PORTNUM = 'PortNumber';
  KEY_TS_DENYCONN = 'fDenyTSConnections';

  TREE_SOFT_VEN='SOFTWARE\Zamith';
  TREE_SOFT='\RDP Port KnockD';
  KEY_SVC_PORT='ServicePort';
implementation

{$R *.dfm}

procedure TFormMain.ChangeNetServicePort(PortId: Integer; DefPort: Word);
var
  Response: String;
  IbValue: Integer;

  IptLbl: TLabel;
begin
  if PortId = 1 then begin
    IptLbl := NetPort1Ipt;
  end else if PortId = 2 then begin
    IptLbl := NetPort2Ipt;
  end else if PortId = 3 then begin
    IptLbl := NetPort3Ipt;
  end else Exit;

  IbValue := DefPort;

  Response := InputBox('Port Knock ' + IntToStr(PortId),'Choose port to be knocked',IbValue.ToString());

  if Response <> EmptyStr then IbValue := StrToIntDef(Response,DefPort);

  if IbValue = DefPort then begin
    WriteLog('Service port ' + IntToStr(PortId) + ' has not been changed',ltWarning);
    Exit;
  end else begin
   if ((IbValue <> PortKnockD1) and (IbValue <> PortKnockD2) and (IbValue <> PortKnockD3)) then begin
     if TWinUtilities.RegWriteInt(ROOT,TREE_SOFT_VEN + TREE_SOFT,KEY_SVC_PORT + IntToStr(PortId),IbValue) then begin
      IptLbl.Caption := IbValue.ToString();

      if PortId = 1 then PortKnockD1 := IbValue;
      if PortId = 2 then PortKnockD2 := IbValue;
      if PortId = 3 then PortKnockD3 := IbValue;

      WriteLog('Network service port ' + IbValue.ToString() + ' set to ' + IntToStr(PortId));

      WriteLog('Restarting RDP knock daemon services',ltWarning);
      SbStopClick(nil);
      TFormUtilities.WaitFor(2000);
      SbStartClick(nil);
     end else WriteLog('Unable to set network service port ' + IbValue.ToString() + ' to ' + IntToStr(PortId));
   end else WriteLog('Network port already in use',ltError);

  end;
end;

procedure TFormMain.CheckConnection(Port: Integer; Socket: TCustomWinSocket);
var
  Res: Boolean;
  Count: Integer;
begin
  SetLength(PortKnocks,Length(PortKnocks) + 1);
  PortKnocks[High(PortKnocks)] := Port;

  if Length(PortKnocks) = 3 then begin
    Res := True;

    for Count := 0 to Pred(Length(PortKnocks)) do begin
      if Count = 0 then begin
        if PortKnocks[Count] <> PortKnockD1 then  begin
          Res := False;
          break;
        end;
      end else if Count = 1 then begin
        if PortKnocks[Count] <> PortKnockD2 then  begin
          Res := False;
          break;
        end;
      end else begin
        if PortKnocks[Count] <> PortKnockD3 then  begin
          Res := False;
          break;
        end;
      end;
    end;

    if Res then begin
      WriteLog('Accepted connection from ' + Socket.RemoteAddress + ':' + Socket.RemotePort.ToString());
      RdpStatusIptClick(nil);
    end else WriteLog('Connection denied from ' + Socket.RemoteAddress + ':' + Socket.RemotePort.ToString(),ltError);

    TimerClearConnCache.Enabled := False;
    WriteLog('Connection cache control stopped');
    SetLength(PortKnocks,0);
  end else if Length(PortKnocks) = 1 then begin
    WriteLog('Connection cache control started');
    TimerClearConnCache.Enabled := True;
  end;
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Stop services
  SbStopClick(Sender);

  TProjectUtilities.TrimAppMemorySize();

  Action := caFree;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  if TProjectUtilities.CurrentProcessIsRunning then begin
    Application.MessageBox(PWideChar('Application is running'),PWideChar(FormMain.Caption),MB_OK+MB_ICONERROR);
    Application.Terminate;
  end;

  FormMain.Caption := FormMain.Caption + ' - Version ' + TProjectUtilities.GetAppVersion;

  RdpPort := 0;
  RdpStatus := False;

  AccessStatus := False;
  ServiceStatus := False;

  if not TWinUtilities.RegExists(ROOT,TREE_SOFT_VEN + TREE_SOFT) then begin
    // Let's consider that it is running for the first time, and block RDP access
    try
      if not TWinUtilities.RegWriteInt(ROOT,TREE_TS,KEY_TS_DENYCONN,1) then WriteLog('Unable to block RDP access at first-run',ltWarning);
    except on E:Exception do
      begin
        WriteLog('Unable to block RDP access at first-run: ' + E.Message,ltError);
      end;
    end;
  end;

  // Service ports
  // -> Port 1
  if TWinUtilities.RegExists(ROOT,TREE_SOFT_VEN + TREE_SOFT,KEY_SVC_PORT + '1') then begin
    try
      PortKnockD1 := TWinUtilities.RegReadInt(ROOT,TREE_SOFT_VEN + TREE_SOFT,KEY_SVC_PORT + '1');
    except on E:Exception do
      begin
        WriteLog('Unable to get port 1 for port knocking daemon: ' + E.Message,ltError);
        Exit;
      end;
    end;
  end else begin
    PortKnockD1 := RandomRange(49152,50000);

    if not TWinUtilities.RegWriteInt(ROOT,TREE_SOFT_VEN + TREE_SOFT,KEY_SVC_PORT + '1',PortKnockD1) then begin
      WriteLog('Unable to set port 1 for port knocking daemon',ltError);
      Exit;
    end;
  end;

  // -> Port 2
  if TWinUtilities.RegExists(ROOT,TREE_SOFT_VEN + TREE_SOFT,KEY_SVC_PORT + '2') then begin
    try
      PortKnockD2 := TWinUtilities.RegReadInt(ROOT,TREE_SOFT_VEN + TREE_SOFT,KEY_SVC_PORT + '2');
    except on E:Exception do
      begin
        WriteLog('Unable to get port 2 for port knocking daemon: ' + E.Message,ltError);
        Exit;
      end;
    end;
  end else begin
    PortKnockD2 := RandomRange(50001,60000);

    if not TWinUtilities.RegWriteInt(ROOT,TREE_SOFT_VEN + TREE_SOFT,KEY_SVC_PORT + '2',PortKnockD2) then begin
      WriteLog('Unable to set port 2 for port knocking daemon',ltError);
      Exit;
    end;
  end;

  // -> Port 3
  if TWinUtilities.RegExists(ROOT,TREE_SOFT_VEN + TREE_SOFT,KEY_SVC_PORT + '3') then begin
    try
      PortKnockD3 := TWinUtilities.RegReadInt(ROOT,TREE_SOFT_VEN + TREE_SOFT,KEY_SVC_PORT + '3');
    except on E:Exception do
      begin
        WriteLog('Unable to get port 3 for port knocking daemon: ' + E.Message,ltError);
        Exit;
      end;
    end;
  end else begin
    PortKnockD3 := RandomRange(60001,65535);

    if not TWinUtilities.RegWriteInt(ROOT,TREE_SOFT_VEN + TREE_SOFT,KEY_SVC_PORT + '3',PortKnockD3) then begin
      WriteLog('Unable to set port 3 for port knocking daemon',ltError);
      Exit;
    end;
  end;

  NetPort1Ipt.Caption := PortKnockD1.ToString();
  NetPort2Ipt.Caption := PortKnockD2.ToString();
  NetPort3Ipt.Caption := PortKnockD3.ToString();

  // RDP port
  if TWinUtilities.RegExists(ROOT,TREE_RDP,KEY_RDP_PORTNUM) then begin
    try
      RdpPort := TWinUtilities.RegReadInt(ROOT,TREE_RDP,KEY_RDP_PORTNUM);
      RdpPortIpt.Caption := RdpPort.ToString();
    except on E:Exception do
      begin
        WriteLog('Unable to get RDP service port: ' + E.Message,ltError);
        Exit;
      end;
    end;
  end else begin
    WriteLog('RDP port settings not found',ltError);
    Exit;
  end;

  // TS access control
  if TWinUtilities.RegExists(ROOT,TREE_TS,KEY_TS_DENYCONN) then begin
    try
      RdpStatus := not TWinUtilities.RegReadInt(ROOT,TREE_TS,KEY_TS_DENYCONN).ToBoolean;
      SetRdpStatus(RdpStatus);
    except on E:Exception do
      begin
        WriteLog('Unable to get terminal services connection settings: ' + E.Message,ltError);
        Exit;
      end;
    end;
  end else begin
    WriteLog('Terminal services connection settings not found',ltError);
    Exit;
  end;

  // Start services
  SbStartClick(Sender);
end;

procedure TFormMain.NetPort1IptClick(Sender: TObject);
begin
  ChangeNetServicePort(1,PortKnockD1);
end;

procedure TFormMain.NetPort2IptClick(Sender: TObject);
begin
  ChangeNetServicePort(2,PortKnockD2);
end;

procedure TFormMain.NetPort3IptClick(Sender: TObject);
begin
  ChangeNetServicePort(3,PortKnockD3);
end;

procedure TFormMain.RdpPortIptClick(Sender: TObject);
var
  Response: String;
  IbValue: Integer;
begin
  if RdpPort = 0 then Exit;

  Response := InputBox('RDP service port','Choose RDP port',RdpPort.ToString());

  if Response = EmptyStr then IbValue := DEF_RDP_PORT else IbValue := StrToIntDef(Response,DEF_RDP_PORT);

  if IbValue = RdpPort then begin
    WriteLog('RDP port has not been changed',ltWarning);
    Exit;
  end else begin
   if TWinUtilities.RegWriteInt(ROOT,TREE_RDP,KEY_RDP_PORTNUM,IbValue) then begin
    RdpPort := IbValue;
    RdpPortIpt.Caption := RdpPort.ToString();
    WriteLog('RDP port set to ' + RdpPort.ToString());
   end else WriteLog('Unable to set RDP port to ' + IbValue.ToString());
  end;
end;

procedure TFormMain.RdpStatusIptClick(Sender: TObject);
begin
  if TWinUtilities.RegWriteInt(ROOT,TREE_TS,KEY_TS_DENYCONN,RdpStatus.ToInteger) then begin
    RdpStatus := not RdpStatus;
    SetRdpStatus(RdpStatus);

    if RdpStatus then begin
      WriteLog('Terminal services connection ALLOWED');
      TimerLockRDP.Enabled := True;
    end else WriteLog('Terminal services connection DENIED',ltWarning);
  end else begin
    WriteLog('Unable to set terminal services connection status',ltError);
  end;
end;

procedure TFormMain.SbStartClick(Sender: TObject);
begin
  ServSock1.Port := PortKnockD1;
  ServSock2.Port := PortKnockD2;
  ServSock3.Port := PortKnockD3;

  try
    try
      ServSock1.Active := True;
      ServSock2.Active := True;
      ServSock3.Active := True;

      SbStop.Enabled := True;
      SbStart.Enabled := False;

      SetServiceStatus(True);

      if TWinUtilities.RegWriteInt(ROOT,TREE_TS,KEY_TS_DENYCONN,1) then begin
        RdpStatus := False;
        SetRdpStatus(RdpStatus);

        if RdpStatus then WriteLog('Terminal services connection ALLOWED') else WriteLog('Terminal services connection DENIED',ltWarning);
      end else begin
        WriteLog('Unable to set terminal services connection status',ltError);
      end;
    except on E:Exception do
      begin
        WriteLog('Unable to start port knock daemon services: ' + E.Message,ltError);

        SbStop.Enabled := False;
        SbStart.Enabled := True;
      end;
    end;
  finally
    // Initialize port knocks
    SetLength(PortKnocks,0);
  end;
end;

procedure TFormMain.SbStopClick(Sender: TObject);
begin
  try
    try
      ServSock1.Close;
      ServSock2.Close;
      ServSock3.Close;

      SbStart.Enabled := True;
      SbStop.Enabled := False;

      SetServiceStatus(False);

      WriteLog('RDP knock daemons stopped',ltWarning);
    except on E:Exception do
      begin
        WriteLog('Unable to stop knock daemon services: ' + E.Message,ltError);
      end;
    end;
  finally
    ServSock1.Active := False;
    ServSock2.Active := False;
    ServSock3.Active := False;
  end;

  // Reset port knocks cache
  SetLength(PortKnocks,0);
end;

procedure TFormMain.ServSock1ClientConnect(Sender: TObject;Socket: TCustomWinSocket);
begin
  CheckConnection(ServSock1.Port,Socket);
  Socket.Close;
  Socket.Disconnect(Socket.SocketHandle);
end;

procedure TFormMain.ServSock1Listen(Sender: TObject; Socket: TCustomWinSocket);
begin
  WriteLog('RDP KnockD Server 1 started at port ' + Socket.LocalPort.ToString());
end;

procedure TFormMain.ServSock2ClientConnect(Sender: TObject;Socket: TCustomWinSocket);
begin
  CheckConnection(ServSock2.Port,Socket);
  Socket.Close;
  Socket.Disconnect(Socket.SocketHandle);
end;

procedure TFormMain.ServSock2Listen(Sender: TObject; Socket: TCustomWinSocket);
begin
  WriteLog('RDP KnockD Server 2 started at port ' + Socket.LocalPort.ToString());
end;

procedure TFormMain.ServSock3ClientConnect(Sender: TObject;Socket: TCustomWinSocket);
begin
  CheckConnection(ServSock3.Port,Socket);
  Socket.Close;
  Socket.Disconnect(Socket.SocketHandle);
end;

procedure TFormMain.ServSock3Listen(Sender: TObject; Socket: TCustomWinSocket);
begin
  WriteLog('RDP KnockD Server 3 started at port ' + Socket.LocalPort.ToString());
end;

procedure TFormMain.SetAccessStatus(Enabled: Boolean);
begin
  if Enabled then begin
    StatusAccessIpt.Font.Color := clGreen;
    StatusAccessIpt.Caption := 'UNLOCKED';
  end else begin
    StatusAccessIpt.Font.Color := clRed;
    StatusAccessIpt.Caption := 'LOCKED';
  end;
end;

procedure TFormMain.SetRdpStatus(Enabled: Boolean);
begin
  if Enabled then begin
    RdpStatusIpt.Font.Color := clGreen;
    RdpStatusIpt.Caption := 'ENABLED';
  end else begin
    RdpStatusIpt.Font.Color := clRed;
    RdpStatusIpt.Caption := 'DISABLED';
  end;

  SetAccessStatus(Enabled);
end;

procedure TFormMain.SetServiceStatus(Enabled: Boolean);
begin
  if Enabled then begin
    StatusSvcIpt.Font.Color := clGreen;
    StatusSvcIpt.Caption := 'RUNNING';
  end else begin
    StatusSvcIpt.Font.Color := clRed;
    StatusSvcIpt.Caption := 'STOPPED';
  end;
end;

procedure TFormMain.TimerClearConnCacheTimer(Sender: TObject);
begin
  TimerClearConnCache.Enabled := False;
  WriteLog('Connection cache erased',ltWarning);
  SetLength(PortKnocks,0);
end;

procedure TFormMain.TimerLockRDPTimer(Sender: TObject);
begin
  TimerLockRDP.Enabled := False;
  WriteLog('RDP connection timeout reached, changing access status');
  RdpStatusIptClick(nil);
end;

procedure TFormMain.TimerTrimAppMemoryTimer(Sender: TObject);
begin
  TProjectUtilities.TrimAppMemorySize();
end;

procedure TFormMain.WriteLog(Msg: String; LogType: TLogType);
begin
  TProjectUtilities.WriteLog(MemoMain,Msg,LogType);
end;

end.
