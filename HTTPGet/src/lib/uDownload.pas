(* GPL > 3.0
Copyright (C) 1996-2014 eIrOcA Enrico Croce & Simona Burzio

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
unit uDownload;

interface

uses
  Forms, SysUtils, Classes, StrUtils, uHTTPGetter;

procedure download(urls: TStrings; conf: THTTPGetterConf);

implementation

uses
  IdBaseComponent, IdURI, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdCoderMIME, IdCoder, eLibCore;

procedure makePath(const aPath: string);
begin
  try
    mkDir(aPath);
  except
  end;
end;

procedure decodeURL(const aURL: string; var path, fileName: string);
var
  url: TURL;
  i: integer;
begin
  url:= TURL.Create(aURL);
  try
    path:= url.Path;
    for i:= 1 to length(path) do begin
      if path[i]='/' then path[i]:= '_'
      else if path[i]='.' then path[i]:= '_';
    end;
    fileName:= url.FileName;
  finally
    url.Free;
  end;
end;

function getStream(const aURL: string): TFileStream;
var
  path, fileName: string;
  name, ext: string;
  fullPath, suffix: string;
  ok: boolean;
  i: integer;
  startPos, endPos: integer;
begin
  decodeURL(aURL, path, fileName);
  startPos:= PosEx('_it', path);
  endPos:= startPos;
  for i:= endPos+1 to length(path) do begin
    if path[i] = '_' then endPos:= i;
  end;
  if (endPos=startPos) then begin
    endPos:= length(path);
  end;
  path:= Copy(path, startPos+1, endPos-startPos-1);
  if path='' then begin
    path:= '.';
  end;
  makePath(path);
  fullPath:= path+'/'+fileName;
  if (fullPath='./') then fullPath:='./default';
  if (FileExists(fullPath)) then begin
    i:= 0;
    name:= ExtractFileName(fileName);
    ext:= ExtractFileExt(fileName);
    if (ext<>'') then begin
      name:= copy(name,1, length(name)-length(ext));
    end;
    repeat
      inc(i);
      suffix:= '_'+IntToStr(i);
      ok:= not FileExists(path+'/'+name+suffix+ext);
    until ok;
    fullPath:= path+'/'+name+suffix+ext;
  end;
  Result:= TFileStream.Create(fullPath, fmCreate);
end;

procedure download(urls: TStrings; conf: THTTPGetterConf);
var
  i: integer;
  url: string;
  fl: TFileStream;
begin
  for i:= 0 to urls.Count-1 do begin
    Application.ProcessMessages;
    url:= trim(urls[i]);
    if (url<>'') then begin
      fl:= getStream(url);
      HTTP_get(url, fl, conf);
      fl.Free;
    end;
  end;
end;

end.

