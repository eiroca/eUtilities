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
unit FPack;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Menus, ExtCtrls;

type
  TNodeInfo = class(TCollectionItem)
    public
     Size: double;
     Count: integer;
  end;

  TfmPack = class(TForm)
    tvPack: TTreeView;
    meOut: TRichEdit;
    MainMenu1: TMainMenu;
    Action1: TMenuItem;
    Generate1: TMenuItem;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    iSource: TEdit;
    iSize: TEdit;
    Label3: TLabel;
    procedure Generate1Click(Sender: TObject);
    private
     tree: TTreeNodes;
     info: TCollection;
    public
     procedure Pack(size: integer; const Inpath, OutPath: string);
     function  ProcessFile(Sender: TObject; const SRec: TSearchRec): boolean;
  end;

var
  fmPack: TfmPack;

implementation

{$R *.DFM}

uses
  eLib;

function TfmPack.ProcessFile(Sender: TObject; const SRec: TSearchRec): boolean;
  procedure AddSize(node: TTreeNode; const SRec: TSearchRec);
  begin
    if (node.Data = nil) then node.Data:= info.Add;
    with TNodeInfo(node.Data) do begin
      Size:= Size + SRec.Size;
    end;
  end;
var
  DS: TDirScan;
  path: string;
  Found: boolean;
  i, LstPos, Pos: integer;
  name: string;
  node: TTreeNode;
begin
   DS:= TDirScan(Sender);
  path:= copy(DS.CurDir, length(DS.StartPath)+1, length(DS.CurDir));
  node:= tree.GetFirstNode;
  AddSize(node, SRec);
  LstPos:= 1;
  for Pos:= 2 to length(path) do begin
    if path[Pos] = '\' then begin
      name:= copy(path, LstPos+1, Pos-LstPos-1);
      Found:= false;
      for i:= node.Count-1 downto 0 do begin
        if (node.Item[i].Text = name) then begin
          Found:= true;
          node:= node.Item[i];
          AddSize(node, SRec);
          break;
        end;
      end;
      if not Found then begin
        node:= tree.AddChild(node, name);
        AddSize(node, SRec);
      end;
      LstPos:= Pos;
    end;
  end;
  inc(TNodeInfo(node.Data).Count);
  Result:= true;
end;

procedure TfmPack.Pack(size: integer; const Inpath, OutPath: string);
  procedure WriteNode(tn: TTreeNode; ni: TNodeInfo; Recurse: boolean);
  var
    tmp: string;
    parent: TTreeNode;
  begin
    tmp:= '';
    repeat
      parent:= tn.Parent;
      if (tn.text<>'/') then begin
        if (tmp<>'') then tmp:= tn.text+'_'+tmp
        else tmp:= tn.text;
      end;
      tn:= parent;
    until (parent = nil);
    if (Recurse) then begin
      meout.Lines.Add(tmp+'='+FloatToStr(ni.Size)+' T');
    end
    else begin
      meout.Lines.Add(tmp+'='+FloatToStr(ni.Size)+' F');
    end;
  end;
  procedure AddDirectory(node: TTreeNode);
  var
    tn: TTreeNode;
    ni: TNodeInfo;
    i: integer;
  begin
    if node.HasChildren then begin
      for i:= 0 to node.Count-1 do begin
        tn:= node.Item[i];
        ni:= TNodeInfo(tn.Data);
        if ni.Size < Size*1024*1024 then begin
          WriteNode(tn, ni, true);
        end
        else begin
          AddDirectory(tn);
        end;
      end;
      ni:= TNodeInfo(node.Data);
      if (ni.Count > 0) then begin
        WriteNode(node, ni, false);
      end;
    end
    else begin
      ni:= TNodeInfo(node.Data);
      WriteNode(node, ni, false);
    end;
  end;
var
  DS: TDirScan;
  root: TTreeNode;
begin
  info:= TCollection.Create(TNodeInfo);
  tvPack.Items.BeginUpdate;
  try
    tree:= tvPack.Items;
    tree.Clear;
    root:= tree.AddChild(nil, '/');
    DS:= TDirScan.Create(nil);
    DS.StartPath:= InPath;
    DS.OnProcessFile:= ProcessFile;
    DS.Scan;
    AddDirectory(root);
  finally
    tvPack.Items.EndUpdate;
    info.Free;
  end;
end;

procedure TfmPack.Generate1Click(Sender: TObject);
var
  sz: integer;
begin
  meOut.Clear;
  sz:= StrToInt(iSize.Text);
  Pack(sz, iSource.Text, '');
end;

end.
