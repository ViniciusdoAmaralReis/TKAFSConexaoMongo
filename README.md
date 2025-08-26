# 🚀 TKAFSConexaoMongoDBAtlas

Componente Delphi/FireMonkey para conexão MongoDB Atlas com suporte a reconexão automática, persistência de configurações e interface de fallback para entrada manual de dados.

## 📋 Descrição

Componente especializado em gerenciar conexões MongoDB Atlas em aplicações Delphi/FireMonkey, com suporte multiplataforma (incluindo Android) e recursos de fallback para configuração manual quando a conexão automática falha.

## ✨ Características

- ✅ Conexão automática com MongoDB Atlas
- ✅ Interface de fallback para configuração manual
- ✅ Cache de configurações de conexão
- ✅ Suporte a SRV records (necessário para MongoDB Atlas)
- ✅ Tratamento de erros robusto
- ✅ Dialog service para entrada de dados
- ✅ Reconexão automática

## 🛠️ Configuração

### Parâmetros de Conexão

```
DriverName: Mongo
UseSRV: True (obrigatório para MongoDB Atlas)
AutoReconnect: True
SilentMode: True
```

## 📦 Como Usar

### Instanciação Básica

```pascal
var
  ConexaoMongo: TKAFSConexaoMongoDBAtlas;
begin
  ConexaoMongo := TKAFSConexaoMongoDBAtlas.Create(nil);
  try
    // Sua lógica com a conexão MongoDB aqui
  finally
    ConexaoMongo.Free;
  end;
end;
```

### Métodos Principais

| Método | Descrição |
|--------|-----------|
| `Conectar` | Estabelece conexão com o MongoDB Atlas |
| `Desconectar` | Fecha a conexão atual |
| `Create` | Construtor com configuração inicial |

## 🔧 Dependências

- `System.Classes`
- `System.SysUtils` 
- `System.UITypes`
- `FMX.DialogService`
- `FMX.Forms`
- `FireDAC.Comp.Client`
- `FireDAC.Phys.MongoDBWrapper`
- `uKAFSFuncoes` (para LerIni/SalvarIni)

## 📁 Estrutura do Cache

As configurações são armazenadas em:

```
[cache]
mongodb.nome=usuário_mongodb
mongodb.senha=senha_mongodb  
mongodb.servidor=servidor_mongodb
```

## ⚠️ Tratamento de Erros

- Exibe diálogo para entrada de credenciais em caso de falha
- Permite até 3 tentativas de reconexão automática
- Permite reconfiguração dinâmica das credenciais
- Finaliza aplicação se usuário cancelar a configuração

## 🔐 Segurança

- As credenciais são armazenadas em cache local codificadas
- Utiliza conexão segura com MongoDB Atlas
- Suporte a autenticação por usuário e senha

---

**Nota:** Este componente requer a unit `uKAFSFuncoes` para funcionamento completo, contendo as funções `LerIni` e `SalvarIni` para persistência das configurações.

**Importante:** Para conexão com MongoDB Atlas é obrigatório o uso de SRV Records (`UseSRV=True`), que dispensa a configuração explícita de porta.
