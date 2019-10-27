unit UFormUtilities;

{
!!!! IMPORTANT !!!!
Always put this Unit after Vcl.Masks. (Prevents fatigue and puts at the end of all statements)
****
}

interface

uses
  Dialogs, System.SysUtils, System.MaskUtils, Vcl.Forms, Vcl.Mask;


type
  TMAskEdit = class (Vcl.Mask.TMaskEdit)
    function GetMask:String;
    function Validate(const Value: string; var Pos: Integer): Boolean; Override;
  end;

type
  TFormUtilities = class
    protected
    private
    public
      class function IsNullMaskedEdit(Edit: TMaskEdit; Separators: array of String; Blanks: String = ' '): Boolean;
      class procedure WaitFor(Time: Cardinal);
  end;

implementation

{ TMAskEdit }
// Credit: https://marcosalles.wordpress.com/2013/06/21/maskedit-invalid-input-value-use-escape-key-to-abandon-change/

function TMAskEdit.GetMask: String;
var
MaskOffset: Integer;
CType: TMaskCharType;
FMaskBlank:Char;
Mask:String;
begin
FMaskBlank:= MaskGetMaskBlank(Self.EditMask);
for MaskOffset := 1 to Length(Editmask) do
begin
CType := MaskGetCharType(EditMask, MaskOffset);
case CType of
mcLiteral, mcIntlLiteral: Mask:=Mask+EditMask[MaskOffset];
mcMaskOpt,mcMask:Mask:=Mask+FMaskBlank;
end;
end;
result:= Mask;
end;

function TMAskEdit.Validate(const Value: string; var Pos: Integer): Boolean;
var
CType: TMaskCharType;
Offset, MaskOffset: Integer;
FMaskBlank:Char;
Mask:String;
begin
Result := True;
Mask:= GetMask;
if Value = Mask then exit;

Offset := 1;

for MaskOffset := 1 to Length(EditMask) do
begin
FMaskBlank:= MaskGetMaskBlank(Self.EditMask);
CType := MaskGetCharType(EditMask, MaskOffset);

if CType in [mcLiteral, mcIntlLiteral, mcMaskOpt] then
Inc(Offset)
else
if (CType = mcMask) and (Value <> '') then
begin
if (Value [Offset] = FMaskBlank) or
((Value [Offset] = ' ') and (EditMask[MaskOffset] <> mMskAscii)) then
begin
Result := False;
Pos := Offset - 1;
showmessage('Invalid input'); // @TODO: Aplicar a verificação de linguagem
self.SetFocus;
abort;
end;
Inc(Offset);
end;
end;
end;

{ TFormUtilities }

class function TFormUtilities.IsNullMaskedEdit(Edit: TMaskEdit; Separators: array of String; Blanks: String): Boolean;
var
  Count: Integer;

  SanitizedString: String;
begin
  SanitizedString := StringReplace(Trim(String(Edit.Text)),Blanks,'' ,[rfReplaceAll]);

  for Count := 0 to Pred(Length(Separators)) do begin
    SanitizedString := Trim(StringReplace(SanitizedString,Separators[Count],'',[rfReplaceAll,rfIgnoreCase]));
  end;

  Result := Length(SanitizedString) = 0;
end;

class procedure TFormUtilities.WaitFor(Time: Cardinal);
begin
  while Time > 0 do begin
    Sleep(1);
    Application.ProcessMessages;

    Dec(Time);  
  end;  
end;

end.
