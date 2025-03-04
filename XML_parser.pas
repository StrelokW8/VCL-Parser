unit XML_parser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,Xml.XMLDoc, Xml.XMLIntf;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  XMLDoc: IXMLDocument;
  RootNode, HeaderNode, GroupNode, TaskNode, StepNode, MeasurementNode: IXMLNode;
  // Alternativa TFileStream pokud by vadilo použití paměti
  CSVData: TStringList;
  Line: string;
  Serial, DateOfTest, TimeOfTest, Judge, GNo, Parts, Comment, Loc, RefVal, Unit10, TestVal, Ptol, Unit13, Mtol, Unit14: string;
  i, j, k, l: Integer;
begin
  // Načíst XML soubor
  XMLDoc := TXMLDocument.Create(nil);

  XMLDoc.LoadFromFile(Edit1.Text);
  XMLDoc.Active := True;

  CSVData := TStringList.Create;
  try
    // Pokud je potřeba, názvy sloupců
    //CSVData.Add('Serial;DateOfTest;TimeOfTest;Judge;G.No;Parts;Comment;Loc;Ref.Val;Unit10;Test.Val;P.Tol;Unit13;M.Tol;Unit14');

    RootNode := XMLDoc.DocumentElement;
    if Assigned(RootNode) and (RootNode.NodeName = 'Testdata') then
    begin
      HeaderNode := RootNode.ChildNodes.FindNode('Header');
      if Assigned(HeaderNode) then
      begin
        // Načíst údaje z hlavičky
        Serial := HeaderNode.ChildNodes['Serial'].Text;
        DateOfTest := HeaderNode.ChildNodes['DateOfTest'].Text;
        TimeOfTest := HeaderNode.ChildNodes['TimeOfTest'].Text;
        Judge := HeaderNode.ChildNodes['Judge'].Text;

        // Projít všechny skupiny
        for i := 0 to RootNode.ChildNodes.Count - 1 do
        begin
          if RootNode.ChildNodes[i].NodeName = 'Group' then
          begin
            GroupNode := RootNode.ChildNodes[i];
            GNo := GroupNode.Attributes['G.No'];

            // Projít všechny úkoly
            for j := 0 to GroupNode.ChildNodes.Count - 1 do
            begin
              if GroupNode.ChildNodes[j].NodeName = 'Task' then
              begin
                TaskNode := GroupNode.ChildNodes[j];

                // Projít všechny kroky
                for k := 0 to TaskNode.ChildNodes.Count - 1 do
                begin
                  if TaskNode.ChildNodes[k].NodeName = 'Step' then
                  begin
                    StepNode := TaskNode.ChildNodes[k];

                    // Projít všechny měření
                    for l := 0 to StepNode.ChildNodes.Count - 1 do
                    begin
                      if StepNode.ChildNodes[l].NodeName = 'Measurement' then
                      begin
                        MeasurementNode := StepNode.ChildNodes[l];

                        // Načíst data
                        Parts := MeasurementNode.ChildNodes['Parts'].Text;
                        Comment := MeasurementNode.ChildNodes['Comment'].Text;
                        Loc := MeasurementNode.ChildNodes['Loc'].Text;
                        RefVal := MeasurementNode.ChildNodes['Ref.Val'].Text;
                        Unit10 := MeasurementNode.ChildNodes['Ref.Val'].Attributes['Unit'];
                        TestVal := MeasurementNode.ChildNodes['Test.Val'].Text;
                        Ptol := MeasurementNode.ChildNodes['P.Tol'].Text;
                        Unit13 := MeasurementNode.ChildNodes['P.Tol'].Attributes['Unit'];
                        Mtol := MeasurementNode.ChildNodes['M.Tol'].Text;
                        Unit14 := MeasurementNode.ChildNodes['M.Tol'].Attributes['Unit'];

                        // Vytvořit řádek pro CSV
                        Line := Format('%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s',
                          [Serial, DateOfTest, TimeOfTest, Judge, GNo, Parts, Comment, Loc, RefVal, Unit10, TestVal, Ptol, Unit13, Mtol, Unit14]);
                        CSVData.Add(Line);
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
    // Uložit do CSV souboru
    CSVData.SaveToFile(Edit2.Text);

    ShowMessage('Done.')
  finally
    CSVData.Free;
  end;
end;

// Kopie z posledního projektu
procedure TForm1.Button2Click(Sender: TObject);
var
  SelectDirectoryDialog: TFileOpenDialog;
  SelectedFolder: string;
begin
  // Vytvoření instance TFileOpenDialog
  SelectDirectoryDialog := TFileOpenDialog.Create(nil);

  try
    // Nastavení vlastností dialogu (nepovinné)
    SelectDirectoryDialog.Title := 'Vyberte složku';
    SelectDirectoryDialog.Options := SelectDirectoryDialog.Options + [fdoPickFolders]; // Povolit výběr složky

    // Zobrazení dialogu a kontrola, jestli uživatel stiskl tlačítko OK
    if SelectDirectoryDialog.Execute then
    begin
      // Získání vybrané složky
      SelectedFolder := SelectDirectoryDialog.FileName;
      Edit2.Text :=  SelectedFolder + '\' + ChangeFileExt(ExtractFileName(Edit1.Text), '.csv');
    end
    else
    begin
      // Uživatel zrušil dialog
      ShowMessage('Operace byla zrušena.');
    end;
  finally
    // Uvolnění instance TFileOpenDialog
    SelectDirectoryDialog.Free;
  end;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   OpenDialog1 := TOpenDialog.Create(nil);

  try
    // Nastavení vlastností dialogu (nepovinné)
    OpenDialog1.Title := 'Vyberte soubor';
    OpenDialog1.Filter := 'XML soubory (*.XML)|*.XML|Všechny soubory (*.*)|*.*';

    // Zobrazení dialogu a kontrola, jestli uživatel stiskl tlačítko OK
    if OpenDialog1.execute then
    begin
      // Zde můžete provést akce s vybraným souborem
      edit1.Text:=OpenDialog1.FileName;
    end
    else
    begin
      // Uživatel zrušil dialog
      ShowMessage('Operace byla zrušena.');
    end;
  finally
    // Uvolnění instance TOpenDialog
    OpenDialog1.Free;
  end;
end;

end.
