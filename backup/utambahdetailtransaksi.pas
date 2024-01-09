unit uTambahDetailTransaksi;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, odbcconn, DB, Forms, Controls, Graphics, Dialogs,
  StdCtrls, DBCtrls, LR_Class, LR_DBSet, DateUtils;

type

  { TTfrmTambahDetailTransaksi }

  TTfrmTambahDetailTransaksi = class(TForm)
    BTambahDetailTransaksi: TButton;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DBLookupBarang: TDBLookupComboBox;
    EJumlah: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SQLConnector1: TSQLConnector;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure BTambahDetailTransaksiClick(Sender: TObject);
    procedure DBLookupBarangChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    customer: string;
    id_transaksi: integer;
    s: string;

  public
    procedure SetCustomer(const ACustomer: string);
    procedure logicTransaksi(jumlahBeli: string; idBarang: string; nama_customer: string);
    procedure ambilDataBarang;

  end;

var
  TfrmTambahDetailTransaksi: TTfrmTambahDetailTransaksi;

implementation

{$R *.lfm}

procedure TTfrmTambahDetailTransaksi.logicTransaksi(jumlahBeli: string; idBarang: string; nama_customer: string);
var
  diskon_barang, diskon_transaksi, harga_jual: integer;
  sub_total, total: Double;
  today: TDateTime;
begin
  try
    with SQLQuery1 do
    begin
      Close;
      SQL.Text:='SELECT * FROM data_barang WHERE id = :id';
      Params.ParamByName('id').AsString := idBarang;
      Open;

      harga_jual := FieldByName('harga_jual').AsInteger;
      if (FieldByName('stok').AsInteger >= StrToInt(jumlahBeli)) AND (FieldByName('stok').AsInteger <> 0) then
      begin
         with SQLQuery2 do
         begin
           today := Now;
           diskon_barang := 0;
           sub_total := harga_jual * StrToInt(jumlahBeli);
           if StrToInt(jumlahBeli) > 100 then
           begin
              diskon_barang := 10;
              sub_total -= (sub_total * diskon_barang / 100);
           end;

           total := sub_total;
           diskon_transaksi := 0;
           if (sub_total > 100000) then
           begin
              diskon_transaksi := 20;
              total -= (total * diskon_transaksi / 100);
           end;

           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('INSERT INTO transaksi (tanggal, customer, sub_total, diskon, total)');
           SQL.Add('VALUES (:today, :customer, :sub_total, :diskon_transaksi, :total)');
           Params.ParamByName('today').AsDateTime := today;
           Params.ParamByName('customer').AsString:= nama_customer;
           Params.ParamByName('sub_total').AsFloat:= sub_total;
           Params.ParamByName('diskon_transaksi').AsInteger:= diskon_transaksi;
           Params.ParamByName('total').AsFloat:= total;
           ExecSQL;

           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('SELECT id FROM transaksi WHERE customer = :customer ORDER BY tanggal DESC');
           Params.ParamByName('customer').AsString := nama_customer;
           Open;
           if IsEmpty then
           begin
              ShowMessage('tidak ditemukan');
              ModalResult:= mrOk;
           end;

           id_transaksi := FieldByName('id').AsInteger;

           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, diskon)');
           SQL.Add('VALUES(:transaksi_id, :barang_id, :jumlah, :diskon)');
           Params.ParamByName('transaksi_id').AsInteger := id_transaksi;
           Params.ParamByName('barang_id').AsInteger:= StrToInt(idBarang);
           Params.ParamByName('jumlah').AsInteger:= StrToInt(jumlahBeli);
           Params.ParamByName('diskon').AsInteger:= diskon_barang;
           ExecSQL;

           Close;
           SQL.Clear;
           SQL.Add('UPDATE data_barang SET stok := stok - :jumlah_beli WHERE id = :id_barang');
           Params.ParamByName('jumlah_beli').AsInteger := StrToInt(jumlahBeli);
           Params.ParamByName('id_barang').AsInteger:= StrToInt(idBarang);
           ExecSQL;

           SQLTransaction1.Commit;
           ModalResult := mrOk;
         end;
      end
      else
          ShowMessage('Stok tersisa '+ FieldByName('stok').AsString);
    end;
    ambilDataBarang;
    DBLookupBarang.KeyValue:= idBarang;
  except
    on E: Exception do
       ShowMessage('Terjadi Kesalahan : ' + E.message);
  end;
end;

procedure TTfrmTambahDetailTransaksi.ambilDataBarang;
begin
  try
    with SQLQuery1 do
    begin
      Close;
      SQL.Text:='SELECT * FROM data_barang';
      Open;
    end;
  except
    on E: Exception do
       ShowMessage('Terjadi Kesalahan : ' + E.message);
  end;
end;

procedure TTfrmTambahDetailTransaksi.SetCustomer(const ACustomer: string);
begin
  customer := ACustomer;
end;

procedure TTfrmTambahDetailTransaksi.FormCreate(Sender: TObject);
begin
  SQLQuery1.Open;
end;

procedure TTfrmTambahDetailTransaksi.DBLookupBarangChange(Sender: TObject);
begin

end;

procedure TTfrmTambahDetailTransaksi.BTambahDetailTransaksiClick(Sender: TObject);
var
  id: string;
begin
   id := IntToStr(DBLookupBarang.KeyValue);
   logicTransaksi(EJumlah.Text, id, customer);
end;

end.

