unit uKAFSConexaoMongo;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  {$IFNDEF CONSOLE}
  FMX.DialogService, FMX.Forms,
  {$ENDIF}
  FireDAC.Comp.Client, FireDAC.Phys.MongoDB, FireDAC.Phys.MongoDBDef,
  FireDAC.Phys, FireDAC.Phys.MongoDBWrapper, FireDAC.Stan.Def,
  FireDAC.Stan.Intf;

type
  TKAFSConexaoMongo = class(TFDConnection)
    MongoConnection: TMongoConnection;

    constructor Create(AOwner: TComponent); reintroduce;
    procedure Conectar;
    procedure Desconectar;
    destructor Destroy; override;
  end;

implementation

uses
  uKAFSFuncoes;

constructor TKAFSConexaoMongo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  with ResourceOptions do
  begin
    AutoReconnect := True;
    SilentMode := True;
  end;

  Conectar;
end;

procedure TKAFSConexaoMongo.Conectar;
begin
  var _tentativas := 0;
  const _max = 3; // Limite de tentativas

  // Repete enquanto não conseguir conexão e não exceder tentativas
  while (not Connected) and (_tentativas < _max) do
    try
      // Busca em cache local o endereço do banco
      with Params do
      begin
        Clear;

        Add('User_Name=' + LerIni('cache', 'mongodb', 'nome'));
        Add('Password=' + LerIni('cache', 'mongodb', 'senha'));
        Add('Server=' + LerIni('cache', 'mongodb', 'servidor'));
        //Necessário para MongoDB Atlas. Dispensa configuração de porta
        Add('UseSRV=True');
      end;

      // Determina o tipo
      DriverName := 'Mongo';

      // Tentativa de conexão
      Connected := True;
    except
      // Caso a tentativa fracasse
      on E: Exception do
      begin
        // Incrementa tentativas
        Inc(_tentativas);

        Writeln(E.Message);

        {$IFDEF CONSOLE}
        var _usuario := '';
        var _senha := '';
        var _servidor := '';
        Writeln('Confirme suas credenciais MongoDB Atlas');
        Write('   - Usuário >');
        Readln(_usuario);
        Write('   - Senha >');
        Readln(_senha);
        Write('   - Servidor >');
        Readln(_servidor);
        Writeln('----------------------------------------');

        SalvarIni('cache', 'mongodb', 'nome', _usuario);
        SalvarIni('cache', 'mongodb', 'senha', _senha);
        SalvarIni('cache', 'mongodb', 'servidor', _servidor);
        {$ELSE}
        TThread.Synchronize(nil, procedure
        begin
          TDialogService.InputQuery('Confirme suas credenciais MongoDB Atlas', ['Usuário', 'Senha', 'Servidor'], ['', '', ''],
          procedure(const AResult: TModalResult; const AValues: array of string)
          begin
            if AResult = mrOk then
            begin
              SalvarIni('cache', 'mongodb', 'nome', AValues[0]);
              SalvarIni('cache', 'mongodb', 'senha', AValues[1]);
              SalvarIni('cache', 'mongodb', 'servidor', AValues[2]);
            end
            else
              Application.Terminate;
          end);
        end);
        {$ENDIF}
      end;
    end;

  // Se não conseguiu conectar após todas as tentativas
  if not Connected then
    raise Exception.Create('Não foi possível conectar ao banco');

  MongoConnection := TMongoConnection(CliObj);
end;
procedure TKAFSConexaoMongo.Desconectar;
begin
  Connected := False;
end;

destructor TKAFSConexaoMongo.Destroy;
begin
  Desconectar;

  inherited Destroy;
end;

end.
