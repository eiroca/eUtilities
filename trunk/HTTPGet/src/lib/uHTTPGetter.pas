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
unit uHTTPGetter;

interface

uses
  Classes, INIFiles, IdHTTP, IdCoderMIME;

type
  THTTPGetterConf = class
    public
     useProxy: boolean;
     proxyHost: string;
     proxyPort: integer;
     isProxyAuth: boolean;
     proxyUsr: string;
     proxyPwd: string;
     useAnonimizer: boolean;
     anonimizerURL: string;
     anonimizerGZIP: boolean;
    private
     decoder: TIdDecoderMIME;
     encoder: TIdEncoderMIME;
    public
     constructor Create;
     procedure loadFromINI(INI: TINIFile);
     procedure saveToINI(INI: TINIFile);
     destructor Destroy; override;
  end;

procedure HTTP_get(aURL: string; fl: TStream; const conf: THTTPGetterConf);

implementation

uses
  eLibCore;

const
  PASSWORD = 'password';

var
  _httpClient: TIdHTTP;

constructor THTTPGetterConf.Create;
begin
  useProxy:= false;
  isProxyAuth:= false;
  proxyHost:= '';
  proxyPort:= 8080;
  proxyUsr:= '';
  proxyPwd:= '';
  useAnonimizer:= false;
  anonimizerURL:= '';
  anonimizerGZIP:= false;
  decoder:= TIdDecoderMIME.Create(nil);
  encoder:= TIdEncoderMIME.Create(nil);
end;

procedure THTTPGetterConf.loadFromINI(INI: TINIFile);
begin
  useProxy:= INI.ReadBool('proxy', 'useProxy', useProxy);
  isProxyAuth:= INI.ReadBool('proxy', 'useAuthentication', isProxyAuth);
  proxyHost:= INI.ReadString('proxy', 'host', proxyHost);
  proxyPort:= INI.ReadInteger('proxy', 'port', proxyPort);
  proxyUsr:= INI.ReadString('proxy', 'username', proxyUsr);
  proxyPwd:= Crypt.SimpleCrypt(decoder.DecodeString(INI.ReadString('proxy', 'password', '')), PASSWORD);
  useAnonimizer:= INI.ReadBool('anonimizer', 'useAnonimizer', useAnonimizer);
  anonimizerURL:= INI.ReadString('anonimizer', 'URL', anonimizerURL);
  anonimizerGZIP:= INI.ReadBool('anonimizer', 'useGZ', anonimizerGZIP);
end;

procedure THTTPGetterConf.saveToINI(INI: TINIFile);
begin
  INI.WriteBool('proxy', 'useProxy', useProxy);
  INI.WriteBool('proxy', 'useAuthentication', isProxyAuth);
  INI.WriteString('proxy', 'host', proxyHost);
  INI.WriteInteger('proxy', 'port', proxyPort);
  INI.WriteString('proxy', 'username', proxyUsr);
  INI.WriteString('proxy', 'password',  encoder.Encode(Crypt.SimpleCrypt(proxyPwd, PASSWORD)));
  INI.WriteBool('anonimizer', 'useAnonimizer', useAnonimizer);
  INI.WriteString('anonimizer', 'URL', anonimizerURL);
  INI.WriteBool('anonimizer', 'useGZ', anonimizerGZIP);
end;

destructor THTTPGetterConf.Destroy;
begin
  decoder.Free;
  encoder.Free;
end;

function getHTTPClient: TIdHTTP;
begin
  Result:= _httpClient
end;

procedure SetupProxy(var httpClient: TIdHTTP; const conf: THTTPGetterConf);
begin
  with conf do begin
    if useProxy then begin
      httpClient.ProxyParams.ProxyServer:= proxyHost;
      httpClient.ProxyParams.ProxyPort:= proxyPort;
      if isProxyAuth then begin
        httpClient.ProxyParams.ProxyUsername:= proxyUsr;
        httpClient.ProxyParams.ProxyPassword:= proxyPwd;
        httpClient.ProxyParams.BasicAuthentication:= true;
      end;
    end
    else begin
      httpClient.ProxyParams.BasicAuthentication:= false;
      httpClient.ProxyParams.ProxyServer:= '';
      httpClient.ProxyParams.ProxyPort:= 0;
      httpClient.ProxyParams.ProxyUsername:= '';
      httpClient.ProxyParams.ProxyPassword:= '';
    end;
  end;
end;


procedure HTTP_get(aURL: string; fl: TStream; const conf: THTTPGetterConf);
var
  prm: TStrings;
  httpClient: TIdHTTP;
begin
  httpClient:= getHTTPClient;
  SetupProxy(httpClient, conf);
  with conf do begin
    if not useAnonimizer then begin
      httpClient.Get(aURL, fl);
    end
    else begin
      prm:= TStringList.Create;
      try
        prm.Values['URL']:= encoder.Encode(aURL);
        if (anonimizerGZIP) then begin
          prm.Values['GZIP']:= '1';
        end;
        httpClient.Post(anonimizerURL, prm, fl);
      finally
        prm.Free;
      end;
    end;
  end;
end;

initialization
  _httpClient:= TIdHTTP.Create();
finalization
  _httpClient.Free;
end.

