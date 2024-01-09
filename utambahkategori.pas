unit uTambahKategori;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, DB, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TTfrmTambahKategori }

  TTfrmTambahKategori = class(TForm)
    BtnTambahKategori: TButton;
    DataSourceKatagori: TDataSource;
    EKategori: TEdit;
    Label1: TLabel;
    SQLConnector1: TSQLConnector;
    SQLQueryKategori: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure BtnTambahKategoriClick(Sender: TObject);
  private

  public

  end;

var
  TfrmTambahKategori: TTfrmTambahKategori;

implementation

{$R *.lfm}

{ TTfrmTambahKategori }

procedure TTfrmTambahKategori.BtnTambahKategoriClick(Sender: TObject);
begin
  try
    with SQLQueryKategori do
    begin
      SQL.Clear;
      SQL.Add('INSERT INTO kategori (nama)');
      SQL.Add('VALUES (:nama)');
      Params.ParamByName('nama').AsString:=EKategori.Text;
      ExecSQL;
      SQLTransaction1.Commit;
      EKategori.Text:='';
      ShowMessage('Berhasil bang');
      ModalResult := mrOk;
    end;
  except
    on E: Exception do
       ShowMessage('Terjadi Kesalahan : ' + E.message);
  end;
end;

end.

