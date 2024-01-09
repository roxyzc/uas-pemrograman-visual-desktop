unit uDataMaster;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, SQLDB, odbcconn, Forms, Controls, Graphics, Dialogs, uTambahbarang, uUpdateBarang,
  StdCtrls, DBCtrls, DBGrids;

type

  { TTfrmDataMaster }

  TTfrmDataMaster = class(TForm)
    BCari: TButton;
    BReset: TButton;
    BTambahBarang: TButton;
    BUpdateBarang: TButton;
    BHapusData: TButton;
    BExit: TButton;
    DataSourceKatagori: TDataSource;
    DataSourceDataBarang: TDataSource;
    DBGridKategori: TDBGrid;
    DBGridDataBarang: TDBGrid;
    ECari: TEdit;
    LJudul: TLabel;
    SQLConnector1: TSQLConnector;
    SQLQueryKategori: TSQLQuery;
    SQLQueryDataBarang: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure BCariClick(Sender: TObject);
    procedure BExitClick(Sender: TObject);
    procedure BHapusDataClick(Sender: TObject);
    procedure BResetClick(Sender: TObject);
    procedure BTambahBarangClick(Sender: TObject);
    procedure BUpdateBarangClick(Sender: TObject);
    procedure DBGridDataBarangCellClick(Column: TColumn);
    procedure FormCreate(Sender: TObject);
  private

  public
    procedure AmbilDataBarang;
    procedure AmbilKategori;

  end;

var
  TfrmDataMaster: TTfrmDataMaster;
  idGrid: integer;

implementation

{$R *.lfm}

{ TTfrmDataMaster }

procedure TTfrmDataMaster.AmbilDataBarang;
begin
with SQLQueryDataBarang do
  begin
    Close;
    SQL.Text := 'SELECT * FROM data_barang';
    Open;
  end;
end;

procedure TTfrmDataMaster.AmbilKategori;
begin
with SQLQueryKategori do
  begin
    Close;
    SQL.Text := 'SELECT * FROM kategori';
    Open;
  end;
end;

procedure TTfrmDataMaster.FormCreate(Sender: TObject);
begin
  AmbilDataBarang;
  AmbilKategori;
end;

procedure TTfrmDataMaster.BCariClick(Sender: TObject);
begin
  with SQLQueryDataBarang do
  begin
    Close;
    SQL.Text := 'SELECT * FROM data_barang WHERE nama LIKE :nama ';
    Params.ParamByName('nama').AsString := '%' + ECari.Text + '%';
    Open;
  end;
end;

procedure TTfrmDataMaster.BExitClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TTfrmDataMaster.BHapusDataClick(Sender: TObject);
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
      AmbilKategori;
    end;
  except
     on E: Exception do
     begin
        ShowMessage('Terjadi Kesalahan : ' + E.Message);
        SQLTransaction1.Rollback;
     end;
  end;

end;

procedure TTfrmDataMaster.BResetClick(Sender: TObject);
begin
  ECari.Text := '';
  AmbilDataBarang;
end;

procedure TTfrmDataMaster.BTambahBarangClick(Sender: TObject);
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

procedure TTfrmDataMaster.BUpdateBarangClick(Sender: TObject);
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

procedure TTfrmDataMaster.DBGridDataBarangCellClick(Column: TColumn);
begin
  idGrid := StrToInt(DBGridDataBarang.DataSource.DataSet.FieldByName('id').AsString);
end;
end.

