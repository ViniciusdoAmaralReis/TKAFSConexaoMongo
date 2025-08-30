# 🧩 TKAFSConexaoMongoDBAtlas

Componente Delphi/FireMonkey para conexão MongoDB Atlas com suporte a reconexão automática, persistência de configurações e interface de fallback para entrada manual de dados.

## ⚠️ Dependências externas

Este componente utiliza a seguinte unit externa que deve ser adicionada ao projeto:

- 🧩 [uKAFSFuncoes](https://github.com/ViniciusdoAmaralReis/uKAFSFuncoes)

## 💡 Instanciação básica
```pascal
var _conexao := TKAFSConexaoMongoDBAtlas.Create(nil);
try
  // A conexão é estabelecida automaticamente no construtor
finally
  FreeAndNil(_conexao);
end;
```
## 🏛️ Status de compatibilidade

| Sistema operacional | Status FireDAC MongoDB | Observações |
|---------------------|------------------------|-------------|
| **Windows** | ✅ **Totalmente Compatível** | Funcionamento completo com todos os recursos |
| **Linux** | ❌ **Não Suportado** | Limitação técnica do driver FireDAC |

| IDE | Versão mínima | Observações |
|---------------------|------------------------|-------------|
| **Delphi** | ✅ **12.3** | Início do suporte nativo a DNS SRV |

---

**Nota**: Este componente é parte do ecossistema KAFS para integração com MongoDB. Requer configuração prévia do MongoDB Atlas e das credenciais apropriadas para funcionamento completo. Certifique-se de ter todas as unidades externas baixadas e configuradas corretamente no projeto.
