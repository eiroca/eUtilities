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
unit FConfHTTP;

interface

uses
  uHTTPGetter, SysUtils, 
  Forms, Windows, StdCtrls, Controls, ComCtrls, Buttons, Classes, ExtCtrls;

type

  TfmConfHTTP = class(TForm)
    Panel1: TPanel;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    cbProxy: TCheckBox;
    iProxyHost: TEdit;
    iProxyUsername: TEdit;
    iProxyPassword: TEdit;
    cbProxyAuth: TCheckBox;
    lbPassword: TLabel;
    lbUser: TLabel;
    cbAnonimizer: TCheckBox;
    iAnonimizerURL: TEdit;
    cbGZ: TCheckBox;
    iProxyPort: TEdit;
    Label1: TLabel;
    procedure iProxyUsernameChange(Sender: TObject);
    procedure cbAnonimizerClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cbProxyClick(Sender: TObject);
  private
    { Private declarations }
    procedure updateProxyVisual;
    procedure updateAnoniVisual;
  public
    { Public declarations }
    procedure fromHTTPConf(conf: THTTPGetterConf);
    procedure toHTTPConf(conf: THTTPGetterConf);
  end;

procedure editConfig(conf: THTTPGetterConf);

implementation

{$R *.dfm}

uses
  eLibCore;

procedure editConfig(conf: THTTPGetterConf);
var
  f: TfmConfHTTP;
begin
  f:= TfmConfHTTP.Create(nil);
  try
    f.fromHTTPConf(conf);
    if f.ShowModal = mrOk then begin
      f.toHTTPConf(conf);
    end;
  finally
    f.Free;
  end;
end;

procedure TfmConfHTTP.fromHTTPConf(conf: THTTPGetterConf);
begin
  cbProxy.Checked:= conf.useProxy;
  iProxyHost.Text:= conf.proxyHost;
  iProxyPort.Text:= IntToStr(conf.proxyPort);
  cbProxyAuth.Enabled:= conf.isProxyAuth;
  iProxyUsername.Text:= conf.proxyUsr;
  iProxyPassword.Text:= conf.proxyPwd;
  cbAnonimizer.Checked:= conf.useAnonimizer;
  iAnonimizerURL.Text:= conf.anonimizerURL;
  cbGZ.Enabled:= conf.anonimizerGZIP;
  updateProxyVisual;
  updateAnoniVisual;
end;

procedure TfmConfHTTP.toHTTPConf(conf: THTTPGetterConf);
begin
  conf.useProxy:= cbProxy.Checked;
  conf.proxyHost:= iProxyHost.Text;
  conf.proxyPort:= Parser.IVal(iProxyPort.Text);
  conf.isProxyAuth:= cbProxyAuth.Enabled;
  conf.proxyUsr:= iProxyUsername.Text;
  conf.proxyPwd:= iProxyPassword.Text;
  conf.useAnonimizer:= cbAnonimizer.Checked;
  conf.anonimizerURL:= iAnonimizerURL.Text;
  conf.anonimizerGZIP:= cbGZ.Enabled;
end;

procedure TfmConfHTTP.updateProxyVisual;
var
  status: boolean;
begin
  status:= cbProxy.Checked;
  iProxyHost.Enabled:= status;
  iProxyPort.Enabled:= status;
  cbProxyAuth.Enabled:= status;
  iProxyUsername.Enabled:= status;
  iProxyPassword.Enabled:= status;
  lbUser.Enabled:= status;
  lbPassword.Enabled:= status;
end;

procedure TfmConfHTTP.updateAnoniVisual;
var
  status: boolean;
begin
  status:= cbAnonimizer.Checked;
  iAnonimizerURL.Enabled:= status;
  cbGZ.Enabled:= status;
end;


procedure TfmConfHTTP.cbProxyClick(Sender: TObject);
begin
  updateProxyVisual;
end;

procedure TfmConfHTTP.FormActivate(Sender: TObject);
begin
  updateProxyVisual;
  updateAnoniVisual;
end;

procedure TfmConfHTTP.cbAnonimizerClick(Sender: TObject);
begin
  updateAnoniVisual;
end;

procedure TfmConfHTTP.iProxyUsernameChange(Sender: TObject);
begin
  cbProxyAuth.Checked:= true;
end;

end.
