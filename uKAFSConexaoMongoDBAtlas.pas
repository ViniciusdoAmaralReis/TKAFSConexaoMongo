unit uKAFSConexaoMongoDBAtlas;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  FMX.DialogService, FMX.Forms,
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
      // Caso a tentativa fracasse
      begin
        // Incrementa tentativas
        Inc(_tentativas);

        TThread.Synchronize(nil, procedure
        begin
          TDialogService.InputQuery('Banco n�o encontrado', ['nome', 'senha', 'servidor'], ['', '', ''],
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
