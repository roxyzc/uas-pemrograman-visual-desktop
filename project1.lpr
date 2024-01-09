program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uMain, uLogin, uTambahbarang, uUpdateBarang, uDataBarang, uTransaksi,
  uTambahTransaksi, uTambahDetailTransaksi, uReport, uDataKategoriBarang,
uTambahKategori, uUpdateKategori
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TTfrmMain, TfrmMain);
  Application.CreateForm(TTfrmLogin, TfrmLogin);
  Application.CreateForm(TTfrmTambahBarang, TfrmTambahBarang);
  Application.CreateForm(TTfrmUpdateBarang, TfrmUpdateBarang);
  Application.CreateForm(TTfrmTransaksi, TfrmTransaksi);
  Application.CreateForm(TTfrmTambahTransaksi, TfrmTambahTransaksi);
  Application.CreateForm(TTfrmTambahDetailTransaksi, TfrmTambahDetailTransaksi);
  Application.CreateForm(TTfrmReport, TfrmReport);
  Application.CreateForm(TTfrmDataBarang, TfrmDataBarang);
  Application.CreateForm(TTfrmDataKategoriBarang, TfrmDataKategoriBarang);
  Application.CreateForm(TTfrmTambahKategori, TfrmTambahKategori);
  Application.CreateForm(TTfrmUpdateKategori, TfrmUpdateKategori);
  Application.Run;
end.

