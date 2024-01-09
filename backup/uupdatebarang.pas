unit uUpdateBarang;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, SQLDB, odbcconn, Forms, Controls, Graphics, Dialogs,
  StdCtrls, DBCtrls, Menus;

type

  { TTfrmUpdateBarang }

  TTfrmUpdateBarang = class(TForm)
    BSimpan: TButton;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DataSource3: TDataSource;
    DBLookupId: TDBLookupComboBox;
    DBLookupkategori: TDBLookupComboBox;
    EJumlahStok: TEdit;
    EHargaJual: TEdit;
    EHargaBeli: TEdit;
    ENama: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    SQLConnector1: TSQLConnector;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;
    SQLQuery3: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure BSimpanClick(Sender: TObject);
    procedure DBLookupIdChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public
    upd: boolean;

  end;

var
  TfrmUpdateBarang: TTfrmUpdateBarang;

implementation

{$R *.lfm}

{ TTfrmUpdateBarang }
procedure TTfrmUpdateBarang.BSimpanClick(Sender: TObject);
begin
  try
    with SQLQuery2 do
    begin
      SQL.Clear;
      SQL.Add('UPDATE data_barang SET nama=:nama, kategori_id=:kategori_id, harga_beli=:harga_beli, harga_jual=:harga_jual, stok=:stok');
      SQL.Add('WHERE id = :id');
      Params.ParamByName('nama').AsString:=ENama.Text;
      Params.ParamByName('kategori_id').AsInteger:=DBLookupkategori.KeyValue;
      Params.ParamByName('id').AsInteger:=DBLookupId.KeyValue;
      Params.ParamByName('harga_beli').AsInteger:=StrToInt(EHargaBeli.Text);
      Params.ParamByName('harga_jual').AsInteger:=StrToInt(EHargaJual.Text);
      Params.ParamByName('stok').AsInteger:=StrToInt(EJumlahStok.Text);
      ExecSQL;
      SQLTransaction1.Commit;

      ENama.Text:='';
      EHargaBeli.Text:='';
      EHargaJual.Text:='';
      EJumlahStok.Text:='';
      upd := True;
      ShowMessage('Berhasil bang');
    end;
    SQLQuery1.Open;
    SQLQuery3.Open;
  except
    on E: Exception do
       ShowMessage('Terjadi Kesalahan : ' + E.message);
  end;
end;

procedure TTfrmUpdateBarang.DBLookupIdChange(Sender: TObject);
var
  id: string;
begin
  try
    SQLQuery3.SQL.Clear;
    SQLQuery3.Params.Clear;
    SQLQuery3.SQL.Add('SELECT * FROM data_barang WHERE id = :id');
    SQLQuery3.Params.ParamByName('id').AsInteger := DBLookupId.KeyValue;
    SQLQuery3.Close;
    SQLQuery3.Open;
    id := IntToStr(DBLookupId.KeyValue);

    ENama.Text := SQLQuery3.FieldByName('nama').AsString;
    EHargaJual.Text := SQLQuery3.FieldByName('harga_jual').AsString;
    EHargaBeli.Text := SQLQuery3.FieldByName('harga_beli').AsString;
    EJumlahStok.Text := SQLQuery3.FieldByName('stok').AsString;
    DBLookupkategori.ListSource := Datasource1;
    DBLookupkategori.ListField := 'nama';
    DBLookupkategori.KeyValue:=SQLQuery3.FieldByName('kategori_id').AsString;
  except
    on E: Exception do
      ShowMessage('Terjadi Kesalahan : ' + E.Message);
  end;

  try
    SQLQuery3.SQL.Clear;
    SQLQuery3.Params.Clear;
    SQLQuery3.SQL.Add('SELECT * FROM data_barang');
    SQLQuery3.Close;
    SQLQuery3.Open;
    DBLookupId.keyValue:= id;
  except
    on E: Exception do
      ShowMessage('Terjadi Kesalahan : ' + E.Message);
  end;
end;

procedure TTfrmUpdateBarang.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if upd = True then
  begin
       upd := False;
       ModalResult:= mrOk;
  end
  else
      ModalResult:= mrCancel;
end;

procedure TTfrmUpdateBarang.FormCreate(Sender: TObject);
begin
  SQLConnector1.ConnectorType:= 'ODBC';
  SQLConnector1.DatabaseName:='transaksi_penjualan';
  SQLConnector1.Connected:= True;
  SQLQuery1.Open;
end;

end.

