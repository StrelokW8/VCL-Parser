program XML_project;

uses
  Vcl.Forms,
  XML_parser in 'XML_parser.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
