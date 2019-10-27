unit UWinUtilities;

interface

uses
  Winapi.Messages,Winapi.Windows,System.SysUtils,System.Win.Registry;

type
  TWinUtilities = class
    public
      class function RegWriteInt(RootKey: HKEY; Key: String; Name: String; Value: Integer): Boolean;
      class function RegWriteStr(RootKey: HKEY; Key: String; Name: String; Value: String): Boolean;
      class function RegReadInt(RootKey: HKEY; Key: String; Value: String): Integer;
      class function RegReadStr(RootKey: HKEY; Key: String; Value: String): String;
      class function RegExists(RootKey: HKEY; Key: String; Value: String = ''): Boolean;
      class function RegDelete(RootKey: HKEY; Key: String; Value: String = ''): Boolean;

      class function OptimizeNetworkHeavyLoad: Boolean;
  end;

implementation

class function TWinUtilities.RegReadInt(RootKey: HKEY; Key, Value: String): Integer;
var
  Reg: TRegistry;
begin
  try
    Reg := TRegistry.Create(KEY_READ);
    Reg.RootKey := RootKey;
    Reg.OpenKeyReadOnly(Key);
    Result := Reg.ReadInteger(Value);
  finally
    FreeAndNil(Reg);
  end;
end;

class function TWinUtilities.RegReadStr(RootKey: HKEY; Key, Value: String): String;
var
  Reg: TRegistry;
begin
  try
    Reg := TRegistry.Create(KEY_READ);
    Reg.RootKey := RootKey;
    Reg.OpenKeyReadOnly(Key);
    Result := Reg.ReadString(Value);
  finally
    FreeAndNil(Reg);
  end;
end;

class function TWinUtilities.OptimizeNetworkHeavyLoad: Boolean;
const
  ROOT = HKEY_LOCAL_MACHINE;
  KEY = 'SYSTEM\CurrentControlSet\Services\TCPIP\Parameters';
  N1 = 'TcpTimedWaitDelay';
  V1 = 60;
  N2 = 'MaxUserPort';
  V2 = 65535;
begin
  // https://docs.oracle.com/cd/E26180_01/Search.94/ATGSearchAdmin/html/s1207adjustingtcpsettingsforheavyload01.html
  // https://docs.microsoft.com/en-us/biztalk/technical-guides/settings-that-can-be-modified-to-improve-network-performance
  if RegExists(ROOT,KEY,N1) then RegDelete(ROOT,KEY,N1);
  if RegExists(ROOT,KEY,N2) then RegDelete(ROOT,KEY,N2);

  Result := RegWriteInt(ROOT,KEY,N1,V1) and RegWriteInt(ROOT,KEY,N2,V2);
end;

class function TWinUtilities.RegDelete(RootKey: HKEY; Key: String; Value: String): Boolean;
var
  Reg : TRegistry;
begin
  Result := False;

  Reg := TRegistry.Create(KEY_WRITE);

  try
    try
      Reg.RootKey := RootKey;

      if Value = EmptyStr then begin
        Result := Reg.DeleteKey(Key);
      end else begin
        if Reg.OpenKey(Key,False) then Result := Reg.DeleteValue(Value);
      end;
    except
    end;
  finally
    Reg.CloseKey();

    SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, 0, LPARAM(PChar('intl')), SMTO_NORMAL, 100, {$IF RTLVersion >= 23}nil{$ELSE}PDWORD(nil)^{$ENDIF});

    FreeAndNil(Reg);
  end;
end;

class function TWinUtilities.RegExists(RootKey: HKEY; Key,Value: String): Boolean;
var
  Reg: TRegistry;
begin
  Result := False;

  Reg := TRegistry.Create(KEY_READ);

  try
    try
      Reg.RootKey := RootKey;
      if Value = '' then begin
        Result := Reg.KeyExists(Key)
      end else begin
        if Reg.OpenKeyReadOnly(Key) then Result := Reg.ValueExists(Value);        
      end;
    except
    end;
  finally
    Reg.CloseKey;
    FreeAndNil(Reg);
  end;
end;

class function TWinUtilities.RegWriteInt(RootKey: HKEY; Key, Name: String; Value: Integer): Boolean;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create(KEY_WRITE);

  try
    try
      Reg.RootKey := RootKey;

      if Reg.OpenKey(Key,True) then begin
        Reg.WriteInteger(Name,Value);
      end;
    except
    end;
  finally
    Reg.CloseKey();

    SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, 0, LPARAM(PChar('intl')), SMTO_NORMAL, 100, {$IF RTLVersion >= 23}nil{$ELSE}PDWORD(nil)^{$ENDIF});

    FreeAndNil(Reg);

    Result := RegReadInt(RootKey,Key,Name) = Value;
  end;
end;

class function TWinUtilities.RegWriteStr(RootKey: HKEY; Key, Name, Value: String): Boolean;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create(KEY_WRITE);

  try
    try
      Reg.RootKey := RootKey;

      if Reg.OpenKey(Key,True) then begin
        Reg.WriteString(Name,Value);
      end;
    except
    end;
  finally
    Reg.CloseKey();

    SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, 0, LPARAM(PChar('intl')), SMTO_NORMAL, 100, {$IF RTLVersion >= 23}nil{$ELSE}PDWORD(nil)^{$ENDIF});

    FreeAndNil(Reg);

    Result := RegReadStr(RootKey,Key,Name) = Value;
  end;
end;

end.
