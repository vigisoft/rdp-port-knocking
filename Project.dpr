program Project;

uses
  Vcl.Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UFormUtilities in 'Utils\UFormUtilities.pas',
  UProjectUtilities in 'Utils\UProjectUtilities.pas',
  UWinUtilities in 'Utils\UWinUtilities.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
