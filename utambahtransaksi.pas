unit uTambahTransaksi;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, uTambahDetailTransaksi;

type

  { TTfrmTambahTransaksi }

  TTfrmTambahTransaksi = class(TForm)
    BTambahTransaksi: TButton;
    ECustomer: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure BTambahTransaksiClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private

  public

  end;

var
  TfrmTambahTransaksi: TTfrmTambahTransaksi;

implementation

{$R *.lfm}

{ TTfrmTambahTransaksi }

procedure TTfrmTambahTransaksi.BTambahTransaksiClick(Sender: TObject);
var
  frmTambahDetailTransaksi: TTfrmTambahDetailTransaksi;
begin

    if Length(ECustomer.Text) > 3 then
    begin
      try
      frmTambahDetailTransaksi := TTfrmTambahDetailTransaksi.Create(Self);
      frmTambahDetailTransaksi.SetCustomer(ECustomer.Text);
      Self.Hide;
      if frmTambahDetailTransaksi.ShowModal = mrOk then
      begin
          ModalResult := mrOk;
      end
      else
          ModalResult := mrCancel;
      finally
          frmTambahDetailTransaksi.Free;
      end;
    end
    else
        ShowMessage('Nama customer tidak boleh kurang dari 3');
end;

procedure TTfrmTambahTransaksi.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin

end;

end.

