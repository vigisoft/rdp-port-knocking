unit UProjectUtilities;

interface

uses
  Winapi.Windows, System.SysUtils, System.StrUtils, System.Types, Vcl.Forms, Vcl.StdCtrls;

type
  TPuParamPrefix = (puParamPrefixNone = 0, puParamPrefixSlash = 1,puParamPrefixBackslash = 2,puParamPrefixDash = 3);
  TLogType = (ltInfo = 0,ltWarning = 1,ltError = 2,ltDebug = 3);

  TProjectUtilities = class
    class var
      NullDateTime: TDateTime; // -700000 + 1
    protected
      class function GetParamPrefixChar(Prefix: TPuParamPrefix): Char;
    private
    public
      class procedure TrimAppMemorySize(IsApplication: Boolean = True);
      class function CurrentProcessIsRunning: Boolean;

      class function GetSysLangId: Integer;
      class function GetSysLangName(LangId: Integer = Integer.MinValue): String;

      class function GetCurrentUsername(): String;

      class function GetAppVersion: String;
      class function GetAppParam(Name: String; ParamCutCount: Integer = 0; ParamPrefix: TPuParamPrefix = puParamPrefixNone; KeyValue: Boolean = False): String;

      class procedure WriteLog(Memo: TMemo; Msg: String; MsgType: TLogType);
  end;

implementation

{ TProjectUtilities }

class function TProjectUtilities.CurrentProcessIsRunning: Boolean;
var
    hMutex: THandle;
begin
  hMutex := System.NativeUInt.MinValue;

  try
    hMutex := CreateMutex(nil, True, PChar(ExtractFileName(ParamStr(0))));
    Result := not((hMutex <> 0) and (GetLastError = 0));
  finally
    ReleaseMutex(hMutex);
 end;
end;

class function TProjectUtilities.GetAppVersion: String;
var
  Exe: string;
  Size, Handle: DWORD;
  Buffer: TBytes;
  FixedPtr: PVSFixedFileInfo;
begin
  Exe := ParamStr(0);
  Size := GetFileVersionInfoSize(PChar(Exe), Handle);
  if Size = 0 then
    RaiseLastOSError;
  SetLength(Buffer, Size);
  if not GetFileVersionInfo(PChar(Exe), Handle, Size, Buffer) then
    RaiseLastOSError;
  if not VerQueryValue(Buffer, '\', Pointer(FixedPtr), Size) then
    RaiseLastOSError;
  Result := Format('%d.%d.%d.%d',
    [LongRec(FixedPtr.dwFileVersionMS).Hi,  //major
     LongRec(FixedPtr.dwFileVersionMS).Lo,  //minor
     LongRec(FixedPtr.dwFileVersionLS).Hi,  //release
     LongRec(FixedPtr.dwFileVersionLS).Lo]) //build
end;

class function TProjectUtilities.GetCurrentUsername: String;
begin
  Result := GetEnvironmentVariable('USERNAME');
end;

class function TProjectUtilities.GetParamPrefixChar(Prefix: TPuParamPrefix): Char;
begin
  Result := #0;

  case Prefix of
    puParamPrefixNone: Result := #0;
    puParamPrefixSlash: Result := '/';
    puParamPrefixBackslash: Result := '\';
    puParamPrefixDash: Result := '-';
  end;
end;

class function TProjectUtilities.GetSysLangId: Integer;
begin
  Result := Languages.IndexOf(SysLocale.DefaultLCID);
end;

class function TProjectUtilities.GetSysLangName(LangId: Integer): String;
begin
  try
    if LangId < 0 then Result := Languages.Name[GetSysLangId] else Result := Languages.Name[LangId];
  except on E:Exception do
    begin
      Result := EmptyStr;
    end;
  end;
end;

class function TProjectUtilities.GetAppParam(Name: String; ParamCutCount: Integer; ParamPrefix: TPuParamPrefix; KeyValue: Boolean): String;
var
  Count: Integer;
  Param, ParamKey, ParamVal: String;

  SplitKeyVal: TStringDynArray;

  Prefix: Char;
  PrefixKey: String;
begin
  Result := EmptyStr;
  Prefix := #0;

  if Name = EmptyStr then Exit;

  if (ParamCutCount > 0) then Prefix := GetParamPrefixChar(ParamPrefix);

  try
    for Count := 1 to ParamCount do begin
      Param := ParamStr(Count);

      // Check if parameter prefix is valid
      if (ParamCutCount > 0) then begin
        PrefixKey := Copy(Param,0,ParamCutCount);

        if not Trim(StringReplace(PrefixKey,Prefix,'',[rfReplaceAll, rfIgnoreCase])).Equals('') then Continue;

        Delete(Param,1,ParamCutCount);
      end;

      if KeyValue then begin
        SplitKeyVal := SplitString(Param,'=');

        if Length(SplitKeyVal) <> 2 then Continue;

        ParamKey := SplitKeyVal[0];
        ParamVal := SplitKeyVal[1];
      end else ParamKey := Param;

      if LowerCase(ParamKey).Equals(LowerCase(Name)) then begin
        if KeyValue then Result := ParamVal else Result := ParamKey;        
        break;
      end;
    end;
  except on E:Exception do
    begin
    end;
  end;
end;

class procedure TProjectUtilities.TrimAppMemorySize(IsApplication: Boolean);
var
   Handle : THandle;
begin
  try
    Handle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID);
    SetProcessWorkingSetSize(Handle, $FFFFFFFF, $FFFFFFFF);
    CloseHandle(Handle);
  finally
    // IMPORTANT: If it's a service or DLL, don't execute this!
    if IsApplication then Application.ProcessMessages;
  end;
end;

class procedure TProjectUtilities.WriteLog(Memo: TMemo; Msg: String; MsgType: TLogType);
var
  MsgTypeStr: String;
begin
  MsgTypeStr := 'INFO';

  case MsgType of
    TLogType.ltWarning: if GetSysLangId = 21 then MsgTypeStr := 'ATENÇÃO' else MsgTypeStr := 'WARNING';
    TLogType.ltError: if GetSysLangId = 21 then MsgTypeStr := 'ERRO' else MsgTypeStr := 'ERROR';
    TLogType.ltDebug: MsgTypeStr := 'DEBUG';
  end;

  if Memo.Lines.Count > 30 then Memo.Lines.Clear;

  Memo.Lines.Add(DateTimeToStr(Now) + ' | [' + MsgTypeStr + '] ' + Msg);
end;

end.
