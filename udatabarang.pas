unit uDataBarang;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, SQLDB, odbcconn, Forms, Controls, Graphics, Dialogs, uTambahbarang, uUpdateBarang,
  StdCtrls, DBCtrls, DBGrids;

type

  { TTfrmDataBarang }

  TTfrmDataBarang = class(TForm)
    BCari: TButton;
    BReset: TButton;
    BTambahBarang: TButton;
    BUpdateBarang: TButton;
    BHapusData: TButton;
    DataSourceDataBarang: TDataSource;
    DBGridDataBarang: TDBGrid;
    ECari: TEdit;
    LJudul: TLabel;
    SQLConnector1: TSQLConnector;
    SQLQueryDataBarang: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure BCariClick(Sender: TObject);
    procedure BHapusDataClick(Sender: TObject);
    procedure BResetClick(Sender: TObject);
    procedure BTambahBarangClick(Sender: TObject);
    procedure BUpdateBarangClick(Sender: TObject);
    procedure DBGridDataBarangCellClick(Column: TColumn);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public
    procedure AmbilDataBarang;
  end;

var
  TfrmDataBarang: TTfrmDataBarang;
  idGrid: integer;

implementation

{$R *.lfm}

{ TTfrmDataBarang }

procedure TTfrmDataBarang.AmbilDataBarang;
begin
with SQLQueryDataBarang do
  begin
    Close;
    SQL.Text := 'SELECT d.id, d.nama, k.nama as kategori, d.harga_beli, d.harga_jual, d.stok  FROM data_barang as d JOIN kategori as k ON k.id = d.kategori_id';
    Open;
  end;
end;

procedure TTfrmDataBarang.FormCreate(Sender: TObject);
begin
  AmbilDataBarang;
end;

procedure TTfrmDataBarang.BCariClick(Sender: TObject);
begin
  with SQLQueryDataBarang do
  begin
    Close;
    SQL.Text := 'SELECT d.id, d.nama, k.nama as kategori, d.harga_beli, d.harga_jual, d.stok  FROM data_barang as d JOIN kategori as k ON k.id = d.kategori_id WHERE d.nama LIKE :nama ';
    Params.ParamByName('nama').AsString := '%' + ECari.Text + '%';
    Open;
  end;
end;

procedure TTfrmDataBarang.BHapusDataClick(Sender: TObject);
var
  Response: Integer;
begin
  if idGrid <> 0 then
  begin
       Response := MessageDlg('Anda yakin ingin menghapus?', mtConfirmation, mbYesNo, 0);
       if Response = mrYes then
       begin
       try
          with SQLQueryDataBarang do
          begin
               Close;
               SQL.Text := 'DELETE FROM data_barang WHERE id = :id ';
               Params.ParamByName('id').AsString := IntToStr(idGrid);
               ExecSQL;
               SQLTransaction1.Commit;
               AmbilDataBarang;
          end;
       except
         on E: Exception do
         begin
            ShowMessage('Terjadi Kesalahan : ' + E.Message);
            SQLTransaction1.Rollback;
         end;
      end;
  end;
  end
  else
    ShowMessage('Klik data yang ingin dihapus terlebih dahulu');
end;

procedure TTfrmDataBarang.BResetClick(Sender: TObject);
begin
  ECari.Text := '';
  AmbilDataBarang;
end;

procedure TTfrmDataBarang.BTambahBarangClick(Sender: TObject);
var
  frmTambahBarang: TTfrmTambahBarang;
begin
  try
    frmTambahBarang := TTfrmTambahBarang.Create(Self);
    Self.Hide;
    if frmTambahBarang.ShowModal = mrOk then
    begin
       ModalResult := mrOk;
    end
    else
       Self.Show;
  finally
    frmTambahBarang.Free;
  end;
end;

procedure TTfrmDataBarang.BUpdateBarangClick(Sender: TObject);
var
  frmUpdateBarang: TTfrmUpdateBarang;
begin
  try
    frmUpdateBarang := TTfrmUpdateBarang.Create(Self);
    Self.Hide;
    if frmUpdateBarang.ShowModal = mrOk then
    begin
      ModalResult := mrOk;
    end
    else
      Self.Show;
  finally
    frmUpdateBarang.Free;
  end;
end;

procedure TTfrmDataBarang.DBGridDataBarangCellClick(Column: TColumn);
begin
  idGrid := StrToInt(DBGridDataBarang.DataSource.DataSet.FieldByName('id').AsString);
end;

procedure TTfrmDataBarang.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
   ModalResult := mrOk;
end;

end.

