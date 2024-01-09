unit uLogin;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, odbcconn, Forms, Controls, Graphics, Dialogs,
  StdCtrls;

type

  { TTfrmLogin }

  TTfrmLogin = class(TForm)
    BLogin: TButton;
    BExit: TButton;
    EUsername: TEdit;
    EPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SQLConnector1: TSQLConnector;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure BExitClick(Sender: TObject);
    procedure BLoginClick(Sender: TObject);

  private

  public
    function Login: boolean;
    function GetRole: integer;
  end;

var
  TfrmLogin: TTfrmLogin;
  Role: integer;

implementation

{$R *.lfm}

procedure TTfrmLogin.BLoginClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TTfrmLogin.BExitClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

function TTfrmLogin.GetRole: integer;
begin
  Result := Role;
end;

function TTfrmLogin.Login: boolean;
begin
  Result := False;
  SQLConnector1.Connected := True;
  try
    with SQLQuery1 do
    begin
      SQL.Text := 'SELECT * FROM user WHERE username = :username AND password = :password';
      Params.ParamByName('username').AsString := EUsername.Text;
      Params.ParamByName('password').AsString := EPassword.Text;
      Open;

      if RecordCount >= 1 then
      begin
          Role := FieldByName('role').AsInteger;
          Result := True;
      end;
    end;
  finally
    SQLConnector1.Connected := False;
    Release;
  end;
end;

end.

