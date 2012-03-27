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
unit RenameMain;

interface

procedure Main;

implementation

uses
  Windows, SysUtils, Classes, eLibCore;

var
  files: TFiles;

procedure Rename2(const path: string);
var
  OldName, NewName: string;
  j, i: integer;
begin
  files:= TFiles.Create;
  files.ReadDirectory(path, '*.*', false, false);
  for j:= 0 to files.Count-1 do begin
    write(j,#13);
    OldName:= files.FileElem[j].Path;
    NewName:= lowercase(OldName);
    for i:= length(NewName)-1 downto 1 do begin
      if (NewName[i+1]='_') and (NewName[i]='_') then Delete(NewName, i+1, 1);
    end;
    for i:= 1 to length(NewName) do if NewName[i]='_' then NewName[i]:= ' ';
    for i:= 1 to length(NewName) do begin
      if NewName[i] in ['a'..'z'] then begin
        NewName[i]:= UpCase(NewName[i]);
        break;
     end;
    end;
    if NewName <> OldName then begin
      RenameFile(Path+OldName, Path+NewName);
    end;
  end;
end;

procedure Rename1(const path: string);
var
  i,j: integer;
  ps: integer;
  num_grp: integer;
  num_img: integer;
  old_grp: string;
  new_grp: string;
  name: string;
  new_name: string;
  ext: string;
begin
  files:= TFiles.Create;
  files.ReadDirectory(path, '*.*', false, false);
  files.SortFiles(soName);
  num_grp:= 0;
  num_img:= 0;
  old_grp:= '';
  for i:= 0 to files.Count-1 do begin
    write(i,#13);
    name:= files.FileElem[i].Path;
    if (name[1]='_') then continue;
    ps:= pos('_', name);
    if (ps=-1) then begin
      new_grp:= '*';
    end
    else begin
      new_grp:= copy(name, 1, ps-1);
    end;
    if (new_grp <> old_grp) then begin
      num_img:= 1;
      num_grp:= num_grp+1;
      old_grp:= new_grp;
    end
    else begin
      num_img:= num_img + 1;
    end;
    ext:= ExtractFileExt(name);
    new_name:= Format('_%3d_%3d%s', [num_grp, num_img, ext]);
    for j:= 1 to length(new_name) do begin
      if (new_name[j]=' ') then new_name[j]:= '0';
    end;
    RenameFile(path+name, path+new_name);
  end;
  files.ClearItems;
  files.ReadDirectory(path, '*.*', false, false);
  writeln;
  for i:= 0 to files.Count-1 do begin
    write(i,#13);
    name:= files.FileElem[i].Path;
    if (name[1]<>'_') then continue;
    new_name:= copy(name,2, length(name)-1);
    RenameFile(path+name, path+new_name);
  end;
  writeln('Done');
end;

procedure Main;
var
  path: string;
  mode: integer;
begin
  if ParamCount>=1 then path:= ParamStr(1) else path:= '.';
  if ParamCount>=2 then mode:= StrToInt(ParamStr(2)) else mode:= 1;
  if (path='-?') or (path='?') or (path='-h') then begin
    writeln(ExtractFileName(ParamStr(0)),' [path [mode]]');
  end
  else begin
    case mode of
      2: Rename2(path);
      else Rename1(path);
    end;
  end;
end;

end.

