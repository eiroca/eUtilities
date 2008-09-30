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
unit FMain;

interface

uses
  Forms, INIFiles,
  Windows, uHTTPGetter, Menus, Classes, Controls, StdCtrls, ComCtrls;

type
  TfmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    miConfigure: TMenuItem;
    miExit: TMenuItem;
    meInput: TRichEdit;
    miDownload: TMenuItem;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure miDownloadClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure miConfigureClick(Sender: TObject);
  private
    { Private declarations }
    configINI: TINIFile;
    config: THTTPGetterConf;
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

uses
  FConfHTTP, uDownload;

{$R *.dfm}

procedure TfmMain.miConfigureClick(Sender: TObject);
begin
  editConfig(config);
end;

procedure TfmMain.miExitClick(Sender: TObject);
begin
  close;
end;

procedure TfmMain.miDownloadClick(Sender: TObject);
begin
  download(meInput.Lines, config);
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  configINI:= TIniFile.Create('./config.ini');
  config:= THTTPGetterConf.Create;
  config.loadFromINI(configINI);
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  config.saveToINI(configINI);
  config.Free;
  configINI.UpdateFile;
  configINI.Free;
end;

end.
