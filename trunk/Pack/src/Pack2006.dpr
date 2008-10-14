program Pack2006;

uses
  Forms,
  FPack in 'gui\FPack.pas' {fmPack};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmPack, fmPack);
  Application.Run;
end.
