program SiemensParser;

uses
  Vcl.Forms,
  f_hlavni in 'f_hlavni.pas' {fhlavni};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfhlavni, fhlavni);







  Application.Run;
end.
