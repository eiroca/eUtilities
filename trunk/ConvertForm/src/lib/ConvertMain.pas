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
unit ConvertMain;

interface

procedure Main;

implementation

uses
  Windows, SysUtils, Classes, eLibCore;

var
  files: TFiles;

procedure TXT2DFM(const path: string);
var
  OldName, NewName: string;
  i: integer;
  InputStream, OutputStream: TFileStream;
begin
  files:= TFiles.Create;
  files.ReadDirectory(path, '*.dfmt', false, false);
  for i:= 0 to files.Count-1 do begin
    OldName:= files.FileElem[i].Path;
    NewName:= ChangeFileExt(OldName, '.dfm');
    write(Oldname);
    { Create a file stream for the specified file }
    InputStream  := TFileStream.Create(OldName, fmOpenRead);
    OutputStream := TFileStream.Create(NewName, fmCreate);
    { convert }
    try
      try
        ObjectTextToResource(InputStream, OutputStream);
        writeln(' OK');
      except
        on e: exception do writeln(' KO - '+e.Message);
      end
    finally
      { free memory }
      InputStream.Free;
      OutputStream.Free;
    end;
  end;
end;

procedure DFM2TXT(const path: string);
var
  OldName, NewName: string;
  i: integer;
  InputStream, OutputStream: TFileStream;
begin
  files:= TFiles.Create;
  files.ReadDirectory(path, '*.dfm', false, false);
  for i:= 0 to files.Count-1 do begin
    OldName:= files.FileElem[i].Path;
    NewName:= ChangeFileExt(OldName, '.dfmt');
    write(Oldname);
    { Create a file stream for the specified file }
    InputStream  := TFileStream.Create(OldName, fmOpenRead);
    OutputStream := TFileStream.Create(NewName, fmCreate);
    { convert }
    try
      try
        ObjectResourceToText(InputStream, OutputStream);
        writeln(' OK');
      except
        on e: exception do writeln(' KO - '+e.Message);
      end
    finally
      { free memory }
      InputStream.Free;
      OutputStream.Free;
    end;
  end;
end;

procedure Main;
var
  path: string;
  mode: integer;
begin
  if ParamCount>=1 then path:= ParamStr(1) else path:= '.';
  if ParamCount>=2 then mode:= StrToInt(ParamStr(2)) else mode:= 1;
  if (path='-?') or (path='?') or (path='-h') then begin
    writeln(ParamStr(0),' [path [mode]]');
  end
  else begin
    case mode of
      2: TXT2DFM(path);
      else DFM2TXT(path);
    end;
  end;
end;

end.

