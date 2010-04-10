(* GPL > 3.0
Copyright (C) 1996-2008 eIrOcA Enrico Croce & Simona Burzio

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*)
(*
 @author(Enrico Croce)
*)
unit FindMain;

interface

procedure Main;

implementation

uses
  eLib, Classes, SysUtils;

var
  outText: TCondFile;

procedure CheckFile(oldFiles: TFiles; NewFE: TFileElem; foundState: boolean; const outFormat: string);
var
  i: integer;
  Found: boolean;
  OldFE: TFileElem;
begin
  Found:= false;
  for i:= 0 to oldFiles.Count-1 do begin
    OldFE:= oldFiles.FileElem[i];
    if OldFE.Size = NewFE.Size then begin
      if NewFE.Size = 0 then Found:= true
      else begin
        if (NewFE.TAG=0) and (NewFE.TAG=OldFE.TAG) then begin
          try
            Found:= FileUtil.Compare(OldFE.Path, NewFE.Path);
          except
            Found:= false;
            writeln('Error processing' + NewFE.Path);
          end;
        end;
      end;
      if Found then break;
    end;
  end;
  if Found = foundState then begin
    outText.writeln(Format(outFormat, [NewFE.Path]));
  end;
end;

procedure Help;
begin
  writeln(ParamStr(0),' miss|dupl OldFilesPath NewFilesPath');
  Halt;
end;

procedure Main;
var
  i: integer;
  cmd: string;
  OldPath, NewPath: string;
  oldFiles: TFiles;
  newFiles: TFiles;
  fmt: string;
  miss: boolean;
begin
  if ParamCount <> 3 then Help;
  cmd:= LowerCase(ParamStr(1));
  if (cmd<>'dupl') and (cmd<>'miss') then Help;
  miss:= (cmd='miss');
  OldPath:= ParamStr(2);
  NewPath:= ParamStr(3);
  oldFiles:= TFiles.Create;
  newFiles:= TFiles.Create;
  writeln('Reading Old files...');
  oldFiles.ReadDirectory(OldPath, '*.*', true, true);
  writeln('Reading New files...');
  newFiles.ReadDirectory(NewPath, '*.*', true, true);
  if (miss) then begin
    writeln('Find missing files...');
    outText:= TCondFile.Create('add_missing.bat');
    fmt:= 'copy "%s" .';
  end
  else begin
    writeln('Find duplicated files...');
    outText:= TCondFile.Create('remove_duplicate.bat');
    fmt:= 'del "%s"';
  end;
  for i:= newFiles.Count-1 downto 0 do begin
    write(i,' '#13);
    CheckFile(oldFiles, newFiles.FileElem[i], not miss, fmt);
  end;
  oldFiles.Free;
  newFiles.Free;
  writeln('Done');
  outText.Free;
end;

end.

