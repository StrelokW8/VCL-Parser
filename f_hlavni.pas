unit f_hlavni;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  Tfhlavni = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    Button3: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  end;

var
  fhlavni: Tfhlavni;

implementation

{$R *.dfm}


procedure ConvertInputToCSV(inputFileName, outputFileName: string);
var
  inputFile: TextFile;
  outputFile: TextFile;
  line,marker,outputstring,blockmarker: string;
  posAt: Integer;
  startPos: Integer;
  posPipe: Integer;
  lineArray,part1Array, part2Array: TStringList;
  lineCounter: Integer;
  block_checker :Boolean;
  formattedNumber : string;
  separatorPos: Integer;
  part1, part2: string;
begin
  // Otevření vstupního souboru
  AssignFile(inputFile, inputFileName);
  Reset(inputFile);

  // Otevření výstupního souboru
  AssignFile(outputFile, outputFileName);
  Rewrite(outputFile);
  // vstup osetren try, ale klidne muzu doplnit
  try
    // Čtení by line
    while not EOF(inputFile) do
    begin
      ReadLn(inputFile, line);
      posAt := Pos('@', line);

      // Kontrola pokud je na řádku @ (vynechání prazdných řádků '}' )a zárove kntrl. délky
      if (posAt <> 0) then
      begin
        startPos := posAt + 1;
        posPipe := Pos('|', Copy(line, posAt + 1, Length(line) - posAt));

        if posPipe <> 0 then
        begin
          ///startPos := posAt + 1;
          marker := Copy(line, startPos, posPipe - 1); // Extract characters from '@' to '|', excluding '|'
          Delete(line, 1, 2);
          //Delete(line, Length(line), 1);
          // Zaměna '|' za ','CSV
          line := StringReplace(line, '|', ';', [rfReplaceAll]);
        end;
       end
      else
      begin    // pokud prazdny radek -> konec bloku
          block_checker := False;
          marker := '';
          outputstring := '';
          lineCounter:=0;
          continue;
      end;
      lineArray := TStringList.Create;
      try
        // Delimiter ',' is set to split the line into separate elements
        lineArray.Delimiter := ';';
        lineArray.DelimitedText := line;

        if marker = 'BATCH' then
        begin

            //kntrl prázdných indexů -- check later
          if  (lineArray[2] = '') and  (lineArray[5] = '') and (lineArray[8] = '') and (lineArray[12] = '') and (lineArray[13] = '') then
          begin
              outputstring := 'HL;' + lineArray[1] + ';'+  lineArray[9] + ';' + lineArray[14] + ';';
          end
          else
          begin
              outputstring := 'HLERROR';
              writeln(outputFile, outputstring);

              break;
          end;
        end
        else if (marker = 'BTEST') then
        begin
          if  (lineArray[7] = '') and  (lineArray[11] = '') then
          begin
              outputstring := outputstring + lineArray[1] + ';'+  lineArray[2] + ';' + lineArray[10];
          end
          else
          begin
              outputstring := 'HLERROR';
              writeln(outputFile, outputstring);

              break;
          end;

        end
        else if marker = 'PF' then // <-zeptat se jestli ok
        begin
             writeln(outputFile, outputstring);
             marker := '';
             //continue;
        end
        else if marker = 'BLOCK' then
        begin
            lineCounter:= 0;
            outputstring := lineArray[1];
            blockmarker := lineArray[1];
            block_checker := True;
        end
        else if (Pos('A-', marker) > 0)  then        //and (block_checker = True)
        begin

           formattedNumber := Format('%2.2d', [lineCounter]);    // pocet 0
           lineCounter:= lineCounter+1;
           // Najděte pozici znaku '{'
           separatorPos := Pos('{', line);

           // Oddělte řetězec na dvě části
           part1 := Copy(line, 1, separatorPos - 1);
           part2 := Copy(line, separatorPos, Length(line) - separatorPos + 1);


           part2 := StringReplace(part2, '@', '', [rfReplaceAll]);
           part2 := StringReplace(part2, '{', '', [rfReplaceAll]);
           part2 := StringReplace(part2, '}', '', [rfReplaceAll]);

           part1Array := TStringList.Create;
           part2Array := TStringList.Create;

           part1Array.Delimiter := ';';
           part1Array.DelimitedText := part1;

           part2Array.Delimiter := ';';
           part2Array.DelimitedText := part2;

           if part1Array.Count > 3 then //kontrola delka za A-| (jsou bud 3 nebo 2 dle logů)
           begin
              outputstring := outputstring +'_'+ part1Array[3] + '_QL' + formattedNumber +';'+ part1Array[2]+';';
           end
           else
           begin
               outputstring := outputstring +'_QL' + formattedNumber +';'+ part1Array[2]+';';
           end;

           if part2Array[0] = 'LIM2' then  //LIM 2 nebo LIM3
           begin

              outputstring := outputstring +';' + part2Array[1] +';'+part2Array[2] +';';

           end
           else if part2Array[0] = 'LIM3' then
           begin

             outputstring := outputstring + part2Array[1]+';' + part2Array[2] +';'+part2Array[3] +';';

           end;

           outputstring := outputstring + part1Array[1];
           part1Array.Free;
           part2Array.Free;
           writeln(outputFile, outputstring);
           if block_checker = False then    //Pokud je mimo block
           begin
              outputstring := '';
              lineCounter:=0;
           end
           else
           begin

              outputstring := blockmarker;

           end;
        end;


        finally
        // Free pole -- zase otazka kde
        lineArray.Free;
      end;

    end;

  finally

    // Uzavření souborů
    CloseFile(inputFile);
    CloseFile(outputFile);

  end;
end;


procedure Tfhlavni.Button1Click(Sender: TObject);
begin
 ConvertInputToCSV(Edit1.Text,Edit2.Text);

end;

procedure Tfhlavni.Button2Click(Sender: TObject);

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


procedure Tfhlavni.Button3Click(Sender: TObject);
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
      Edit2.Text :=  SelectedFolder+'\'+ExtractFileName(Edit1.Text)+'.csv';
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

end.
