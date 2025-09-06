unit uKAFSConexaoMongoDBAtlas;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  {$IFDEF FMX}
  FMX.DialogService, FMX.Forms,
  {$ENDIF}
  FireDAC.Comp.Client, FireDAC.Phys.MongoDB, FireDAC.Phys.MongoDBDef,
  FireDAC.Phys, FireDAC.Phys.MongoDBWrapper, FireDAC.Stan.Def,
  FireDAC.Stan.Intf;

type
  TKAFSConexaoMongoDBAtlas = class(TFDConnection)
    MongoConnection: TMongoConnection;

    constructor Create(AOwner: TComponent); reintroduce;
    procedure Conectar;
    procedure Desconectar;
    destructor Destroy; override;
  end;

implementation

uses
  uKAFSFuncoes;

constructor TKAFSConexaoMongoDBAtlas.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  with ResourceOptions do
  begin
    AutoReconnect := True;
    SilentMode := True;
  end;

  Conectar;
end;

procedure TKAFSConexaoMongoDBAtlas.Conectar;
begin
  var _tentativas := 0;
  const _max = 3; // Limite de tentativas

  // Repete enquanto n�o conseguir conex�o e n�o exceder tentativas
  while (not Connected) and (_tentativas < _max) do
    try
      // Busca em cache local o endere�o do banco
      with Params do
      begin
        Clear;

        Add('User_Name=' + LerIni('cache', 'mongodb', 'nome'));
        Add('Password=' + LerIni('cache', 'mongodb', 'senha'));
        Add('Server=' + LerIni('cache', 'mongodb', 'servidor'));
        //Necess�rio para MongoDB Atlas. Dispensa configura��o de porta
        Add('UseSRV=True');
      end;

      // Determina o tipo
      DriverName := 'Mongo';

      // Tentativa de conex�o
      Connected := True;
    except
      on E: Exception do
      // Caso a tentativa fracasse
      begin
        Writeln('Erro: ' + E.Message);

        // Incrementa tentativas
        Inc(_tentativas);

        {$IFDEF CONSOLE}
        var _usuario := '';
        var _senha := '';
        var _servidor := '';
        Writeln('Confirme suas credenciais MongoDB Atlas');
        Write('   - Usu�rio >');
        Readln(_usuario);
        Write('   - Senha >');
        Readln(_senha);
        Write('   - Servidor >');
        Readln(_servidor);
        Writeln('----------------------------------------');

        SalvarIni('cache', 'mongodb', 'nome', _usuario);
        SalvarIni('cache', 'mongodb', 'senha', _senha);
        SalvarIni('cache', 'mongodb', 'servidor', _servidor);
        {$ENDIF}

        {$IFDEF FMX}
        TThread.Synchronize(nil, procedure
        begin
          TDialogService.InputQuery('Confirme suas credenciais MongoDB Atlas', ['Usu�rio', 'Senha', 'Servidor'], ['', '', ''],
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

  // Se n�o conseguiu conectar ap�s todas as tentativas
  if not Connected then
    raise Exception.Create('N�o foi poss�vel conectar ao banco');

  MongoConnection := TMongoConnection(CliObj);
end;
procedure TKAFSConexaoMongoDBAtlas.Desconectar;
begin
  Connected := False;
end;

destructor TKAFSConexaoMongoDBAtlas.Destroy;
begin
  Desconectar;

  inherited Destroy;
end;

end.
