# API Banking

### Introdução
API Banking é um projeto que simula um processo de transações financeiras desde cadastro de contas até o logout da conta.

O projeto contribuiu para o aprendizado sobre a linguagem Elixir.

### Ações disponibilizadas pela API
1.	Cadastro de contas;
2.	Autenticação da conta (entrar na conta);
3.	Autorização da conta;
4.	Atualização de dados cadastrais da conta;
5.	Transferência de valores entre as contas;
6.	Saque;
7.	Emissão de relatório back office;
8.	Consultar saldo da conta logada;
9.	Remover autenticação (sair da conta).

### Fluxo do negócio
- Cadastrar conta
  - Pré-requisito(s): 
    - Nenhum
- Autenticar conta
    - Pré-requisito(s):
        - Cadastrar conta
- Autorizar conta
    - Pré-requisito(s):
        - Autenticar conta
- Atualizar dados cadastrais da conta
    - Pré-requisito(s): 
        - Autenticar conta
- Transferir valor 
    - Pré-requisito(s)
        - Autenticar conta
        - Autorizar conta
- Saque
    - Pré-requisito(s)
        - Autenticar conta
        - Autorizar conta
- Consultar saldo da conta logada
    - Pré-requisito(s)
        - Autenticar conta
- Emitir relatório back office
    - Pré-requisito(s)
        - Nenhum
    - Sair da conta
        - Pré-requisito(s):
            - Autenticar conta

### Detalhamento das funcionalidades

---

#### Cadastro de contas
Qualquer usuário pode criar sua própria conta. Para esse simulador é necessário informar:
- Conta (obrigatório); Ex.: 0001
- Agência (obrigatório); Ex.: 05289
- Código do banco (obrigatório); Ex.: 004
- CPF do titular da conta (obrigatório); Ex.: 06401173173
- Nome do titular da conta (obrigatório); Ex.: Maria Joana Silva
- E-mail (obrigatório); Ex.: email@email.com
- Senha da conta

#### Autenticação da conta
O processo de autenticação da conta, pode se entender como processo de entrar/logar na conta. Para efetuar essa ação, é necessário informar:
- Conta (obrigatório); Ex.: 0001
- Agência (obrigatório); Ex.: 04589
- Código do banco (obrigatório); Ex.: 002
- Senha (obrigatório)

#### Autorização da conta
O processo de autorização da conta, só será possível se o usuário estiver logado. Esse processo é basicamente a confirmação de alguma operação específica; portanto, é necessário informar a senha da conta autenticada.

#### Atualização de dados cadastrais da conta
Só é possível atualizar dados cadastrais da conta, se ela estiver logada. Os dados que são permitidos para alteração são:
- E-mail (obrigatório)
- Nome do titular da conta (obrigatório)

#### Transferência de valores entre contas
Para realizar transferência de valores, é necessário informar os seguintes dados da conta de destino:
- Conta (obrigatório); Ex.: 0001
- Agência (obrigatório); Ex.: 01548
- Código do banco (obrigatório); Ex.: 005
- Valor
    - É permitido apenas transferir valores superiores a zero;
    - É necessário ter saldo maior ou igual ao valor da transferência.
    
Não é permitido transferir para própria conta logada.

Para efetuar essa operação, é necessário que a conta esteja logada e autorizada.

#### Saque
Para realizar a operação de saque, é necessário: 
- Informar o valor para saque;
- Possuir saldo para saque;
- A conta precisa estar autenticada e autorizada.

#### Emissão de relatório back office
Exibe um sumário das transações feitas no dia, no mês e no ano corrente.
#### Consultar saldo da conta logada
Exibe o saldo atual da conta.
#### Remover autenticação da conta (efetuar logout)
Desconecta da conta logada.

### Documentação técnica

---

#### Requerimentos

1. Erlang/OTP 22 \[erts-10.4.2\]
2. Elixir 1.8.2 (compiled with Erlang/OTP 20)   
3. Postgres 10.9.

#### API desenvolvida utilizando:

- Elixir;
- Postgres;
- **[GraphQL](https://graphql.org/)**.

### Principais dependências:
- [absinthe](https://absinthe-graphql.org/): Conjunto de ferramentas GraphQL para Elixir;
- [phoenix](https://phoenixframework.org/): Para a API; 
- [guardian](https://hexdocs.pm/guardian/Guardian.html): Para autenticação e autorização;
- [ecto](https://hexdocs.pm/ecto/Ecto.html): Conjuntos de ferramentas para mapeamento de dados e consulta integrada.
    
### Utilizando o serviço:
   
- Executando o projeto:   
   * Instale as dependências com `mix deps.get`;
   * Crie e migre seu banco de dados com `mix ecto.create && mix ecto.migrate`;
   * Inicie o endpoint do serviço com `mix phx.server`.
    
- Executar utilizando **docker**:
    1. Execute o comando: `docker build --tag apibnk .`
    2. Execute o comando: `docker-compose up`
    
- Executar os testes:

Executar o comando `mix test`.

- Executar o analisador de código fonte estático [credo](https://github.com/rrrene/credo):

Executar o comando `mix credo`.

- A **documentação** dos **módulos** estão localizadas no diretório do projeto `api_bnk/doc`, em que foi gerado utilizando o comando `mix docs`.

- A **documentação** das consultas **[GraphQL](https://graphql.org/)** são disponibilizadas na própria rota do 
serviço [`localhost:4000/api/graphiql`](http://127.0.0.1:4000/api/graphiql); para visualizar a documentação GraphQL, utilize uma espécie 
de postman para **[GraphQL](https://graphql.org/)**; recomendo https://electronjs.org/apps/graphiql .

- Utilize a rota [`http://127.0.0.1:4000/api/graphiql`](http://127.0.0.1:4000/api/graphiql) para ter acesso aos recursos da API.
    - Existem dois tipos de HTTP Headers:
        1. Token de autenticação
            - Header name: **Authentication**
            - Header value: **Bearer** \<Token\>
                - Ex.: **Authentication : Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9**
        2. Token de autorização: Utilizado para efetuar determinadas operações financeiras
            - Header name: **Authentication**
            - Header value: **Bearer** \<Token\>
                - Ex.: **Authentication : Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9**
        
