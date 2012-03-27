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
unit PurgeMain;

interface

procedure Main;

implementation

uses
  Windows, SysUtils, eLibCore;

var
  files: TFiles;
  undo: TCondFile;

procedure CompareAndDelete(FE1, FE2: TFileElem);
var
  tmp: TFileElem;
begin
  if (FE1.Path='') or (FE2.Path='') then exit;
  if FileUtil.Compare(FE1.Path, FE2.Path) then begin
    if FE2.Time < FE1.Time then begin
      tmp:= FE1;
      FE1:= FE2;
      FE2:= tmp;
    end;
    if DeleteFile(FE2.Path) then begin
      undo.writeln('copy "'+FE1.Path+'" "'+FE2.Path+'"');
      FE2.Path:= '';
    end
    else begin
      Writeln('Problem error erasing "', FE2.Path, '"');
    end;
  end;
end;

procedure CheckFile(first, last: integer);
var
  i, j: integer;
  FE1, FE2: TFileElem;
begin
  if (last-first) < 1 then exit;
  if (last-first) > 1 then begin
    for i:= first to last do begin
      FE1:= files.FileElem[i];
      FE1.TAG:= FileUtil.calcCRC(FE1.Path);
    end;
    for i:= first to last-1 do begin
      for j:= i+1 to last do begin
        FE1:= files.FileElem[i];
        FE2:= files.FileElem[j];
        if (FE1.TAG=FE2.TAG) then begin
          CompareAndDelete(FE1, FE2);
        end;
      end;
    end;
  end
  else begin
    CompareAndDelete(files.FileElem[first], files.FileElem[last]);
  end;
end;

procedure Purge(const path, Mask: string);
var
  count, Pos: integer;
  lastSize, curSize: integer;
  lastIndex: integer;
begin
  files:= TFiles.Create;
  undo:= TCondFile.Create('undo_purge.bat');
  try
    writeln('Adding files...');
    files.ReadDirectory(Path, Mask, true, true);
    if files.Count < 2 then exit;
    writeln('Comparing files...');
    files.SortFiles(soSize);
    lastSize:= -1;
    lastIndex:= -1;
    count:= Files.Count;
    for pos:= 0 to Files.Count-1 do begin
      write(count,' '#13); dec(count);
      curSize:= files.FileElem[pos].Size;
      if lastSize <> curSize then begin
        if lastIndex > -1 then begin
          CheckFile(lastIndex, pos-1);
        end;
        lastIndex:= pos;
        lastSize:= curSize;
      end;
    end;
    CheckFile(lastIndex, Files.Count-1);
  finally
    Files.Free;
    undo.Free;
    writeln('Done');
  end;
end;

procedure Main;
var
  Path, Mask: string;
begin
  if ParamCount>=1 then Mask:= ParamStr(1) else Mask:= '*.*';
  if ParamCount>=2 then Path:= ParamStr(2) else Path:= '';
  if (Mask='-?') or (Mask='?') or (Mask='-h') then begin
    writeln(ExtractFileName(ParamStr(0)),' [mask [path]]');
  end
  else begin
    Purge(path, mask);
  end;
end;

end.

