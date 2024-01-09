unit uUpdateKategori;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, DB, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TTfrmUpdateKategori }

  TTfrmUpdateKategori = class(TForm)
    BtnUpdateKategori: TButton;
    DataSourceKatagori: TDataSource;
    EKategori: TEdit;
    Label1: TLabel;
    SQLConnector1: TSQLConnector;
    SQLQueryKategori: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure BtnUpdateKategoriClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure AmbilKategori(id_kategori: Integer);

  public
    procedure setId(id: Integer);
    procedure setNama;

  end;

var
  TfrmUpdateKategori: TTfrmUpdateKategori;
  id_kategori: Integer;

implementation

{$R *.lfm}

{ TTfrmUpdateKategori }

procedure TTfrmUpdateKategori.setId(id: Integer);
begin
  id_kategori := id;
end;

procedure TTfrmUpdateKategori.setNama;
begin
  AmbilKategori(id_kategori);
end;

procedure TTfrmUpdateKategori.AmbilKategori(id_kategori: Integer);
var
  nama: string;
begin
with SQLQueryKategori do
  begin
    Close;
    SQL.Add('SELECT * FROM kategori WHERE id = :id_kategori');
    Params.ParamByName('id_kategori').AsInteger := id_kategori;
    Open;

    nama := FieldByName('nama').AsString;
    EKategori.Text := nama;
  end;
end;

procedure TTfrmUpdateKategori.FormCreate(Sender: TObject);
begin
end;

procedure TTfrmUpdateKategori.BtnUpdateKategoriClick(Sender: TObject);
begin
  try
    with SQLQueryKategori do
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE kategori SET nama=:nama');
      SQL.Add('WHERE id = :id_kategori');
      Params.ParamByName('nama').AsString:=EKategori.Text;
      Params.ParamByName('id_kategori').AsInteger := id_kategori;
      ExecSQL;
      SQLTransaction1.Commit;
      ModalResult:= mrOk;
    end;
  except
    on E: Exception do
         ShowMessage('Terjadi Kesalahan : ' + E.message);
end;
end;

end.

