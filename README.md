<div align="center">
<img width="188" height="200" alt="image" src="https://github.com/user-attachments/assets/60d8a531-d1b0-4282-a91c-0d24467ffd8b" /></div><p>

# <div align="center"><strong>TKAFSConexaoMongo</strong></div> 

<div align="center">
Componente Delphi/FireMonkey para conexão MongoDB Atlas com suporte a reconexão automática,<br> 
persistência de configurações e interface de fallback para entrada manual de dados.
</p>

[![Delphi](https://img.shields.io/badge/Delphi-12.3+-B22222?logo=delphi)](https://www.embarcadero.com/products/delphi)
[![FireDAC](https://img.shields.io/badge/FireDAC-Connector-FF6600)]([https://www.embarcadero.com/products/firedac](https://docwiki.embarcadero.com/RADStudio/Athens/en/FireDAC))
[![MongoDB](https://img.shields.io/badge/MongoDB-Atlas-47A248?logo=mongodb)](https://www.mongodb.com/atlas)
[![Multiplatform](https://img.shields.io/badge/Multiplatform-Win/Linux-8250DF)]([https://www.embarcadero.com/products/delphi/cross-platform](https://docwiki.embarcadero.com/RADStudio/Athens/en/Developing_Multi-Device_Applications))
[![License](https://img.shields.io/badge/License-GPLv3-blue)](LICENSE)
</div><br>

## ⚠️ Dependências externas
Este componente utiliza a seguinte unit externa que deve ser adicionada ao projeto:
- [uKAFSFuncoes](https://github.com/ViniciusdoAmaralReis/uKAFSFuncoes)
<div></div><br><br>


## ⚡ Instanciação básica
```pascal
var _conexao := TKAFSConexaoMongo.Create(nil);
try
  // A conexão é estabelecida automaticamente no construtor
finally
  FreeAndNil(_conexao);
end;
```
<div></div><br><br>


---
**Nota**: Este componente é parte do ecossistema KAFS para integração com MongoDB Atlas. Requer configuração prévia do MongoDB Atlas e das credenciais apropriadas para funcionamento completo. Certifique-se de ter todas as unidades externas baixadas e configuradas corretamente no projeto.
