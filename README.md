# API Banking

### Introdução

API Banking é um projeto que simula um processo de transações financeiras desde cadastro de contas até o logout da conta.
Como o foco é simular transações financeiras, a API **permite que você informe a conta, agência e código do banco**, com o objetivo de deixar mais flexível a simulação. É de consciência que em uma situação real, essas informações devem ser geradas pelo serviço, e não ser informado pelo usuário que está criando a conta.

O projeto contribuiu para o aprendizado sobre a linguagem Elixir.

#### Requerimentos

1. Erlang/OTP 22 \[erts-10.4.2\]
2. Elixir 1.8.2 (compiled with Erlang/OTP 20)   
3. Postgres 10.9.

#### API desenvolvida utilizando:

- **[Elixir](https://elixir-lang.org/)**
- **[Postgres](https://www.postgresql.org/)**
- **[GraphQL](https://graphql.org/)**

#### Principais dependências:
- [absinthe](https://absinthe-graphql.org/): Conjunto de ferramentas GraphQL para Elixir;
- [phoenix](https://phoenixframework.org/): Para a API; 
- [guardian](https://hexdocs.pm/guardian/Guardian.html): Para autenticação e autorização;
- [ecto](https://hexdocs.pm/ecto/Ecto.html): Conjuntos de ferramentas para mapeamento de dados e consulta integrada.

### Ações disponibilizadas pela API
1.	Cadastro de contas;
2.	Autenticação da conta (entrar na conta);
3.	Autorização da conta;
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
---

### Detalhamento das funcionalidades
#### Cadastro de contas
Qualquer usuário pode criar sua própria conta. Para esse simulador é necessário informar:
- Conta (obrigatório); `Ex.: 0001`
- Agência (obrigatório); `Ex.: 05289`
- Código do banco (obrigatório); `Ex.: 004`
- CPF do titular da conta (obrigatório); `Ex.: 06401173173`
- Nome do titular da conta (obrigatório); `Ex.: Maria Joana Silva`
- E-mail (obrigatório); `Ex.: email@email.com`
- Senha da conta (obrigatório)

1. Quando o cadastro for concluido, o usuário terá **R$ 1000,00** creditado em sua conta;
2. A composição de Conta, Agência e Código do banco, são únicos;
3. O CPF é único;
4. O e-mail é único.

#### Autenticação da conta
O processo de autenticação da conta, pode se entender como processo de entrar/logar na conta. Para efetuar essa ação, é necessário informar:
- Conta (obrigatório); `Ex.: 0001`
- Agência (obrigatório); `Ex.: 04589`
- Código do banco (obrigatório); `Ex.: 002`
- Senha (obrigatório)

#### Autorização da conta
O processo de autorização da conta, só será possível se o usuário estiver logado. Esse processo é basicamente a confirmação de alguma operação específica; portanto, é necessário informar a senha da conta autenticada.

#### Transferência de valores entre contas
Para realizar transferência de valores, é necessário informar os seguintes dados da conta de destino:
- Conta (obrigatório); `Ex.: 0001`
- Agência (obrigatório); `Ex.: 01548`
- Código do banco (obrigatório); `Ex.: 005`
- Valor (obrigatório)
    - É permitido apenas transferir valores superiores a zero;
    - É necessário ter saldo maior ou igual ao valor da transferência.
    
> Obs.: Não é permitido transferir para própria conta logada.
> Para efetuar essa operação, é necessário que a conta esteja logada e autorizada.

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

---
### Documentação técnica

#### Utilizando o serviço:
   
##### 1. Executando o projeto:   
```sh
mix deps.get # Instale as dependências
mix ecto.create # Criar o banco de dados
mix phx.server # Iniciar o endpoint do serviço
```
  
##### 2. Executar utilizando **docker**:

```sh
docker build --tag apibnk .
docker-compose up
``` 
##### 3. Executar os testes:
```sh
mix test # Executar o comando
```
 
> Obs.: Para executar o analisador de código fonte estático [credo](https://github.com/rrrene/credo):
```sh
mix credo 
```

- A **documentação** dos **módulos** estão localizadas no diretório do projeto `doc`, em que foi gerado utilizando o comando `$ mix docs`.

- A **documentação** das consultas **[GraphQL](https://graphql.org/)** são disponibilizadas na própria rota do 
serviço [`localhost:4000/api/graphiql`](http://127.0.0.1:4000/api/graphiql).

- Utilize a rota [`http://127.0.0.1:4000/api/graphiql`](http://127.0.0.1:4000/api/graphiql) para ter acesso aos recursos da API.
    - Existem dois tipos de HTTP Headers:
        1. Token de autenticação
            - Header name: **Authentication**
            - Header value: **Bearer** \<Token\>
                - Ex.: **Authentication : Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9**
        2. Token de autorização: Utilizado para efetuar determinadas operações financeiras
            - Header name: **Authorization**
            - Header value: **Bearer** \<Token\>
                - Ex.: **Authorization : Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9**
    - Efetuar todas a requisições via **POST**, informando os respecitivos tokens a depender da operação, por exemplo:
        - Para acessar seu saldo, é necessário informar o token de autenticação, ou seja, `Authentication : Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9`
        - Para efetuar um saque, é necessário informar o token de autenticação e autorização,  ou seja:
            - `Authentication : Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9`; 
            - `Authorization : Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9`.          
        
### Consultas GraphQL

#### POST /api/graphiql

OBS.: Seguindo o padrão da notação do GraphQL, a exclamação (**!**) indica que o campo é obrigatório.

Exemplos de consultas GraphQL:

#### Criar conta

---

Observações: 
1. Existe a unicidade de CPF;
2. Existe a unidade de E-mail;
3. Existe a unicidade da composição de: **Conta**, **Agência** e **Código do banco**.

##### Request - Schema

```javascript
mutation {
  createAccount(
   account: String!
   agency: String!
   bankCode: String!
   cpf: String!
   email: String!
   name: String!
   password: String!    
  ){
    code
    message
  }
}
````

##### Request - Exemplo
```javascript
mutation {
  createAccount(
    account: "14026",
    agency: "0001",
    bankCode: "003",
    name: "Joana",
    password: "123456",
    cpf: "95875628600",
    email:"joana@email.com"
    
  ){
    code
    message
  }
}
````
##### Response
```json
{
  "data": {
    "createAccount": {
      "code": 201,
      "message": "Created"
    }
  }
}
````

#### Login

---
##### Request - Schema

```javascript
query {
  login(
   account: String!
   agency: String!
   bankCode: String!
   password: String!
  ) {
    token
  }
}
````
##### Request - Exemplo
```javascript
query {
  login(bankCode:"003" agency: "0001", account: "14025", password: "123456") {
    token
  }
}
````
##### Response
```json
{
  "data": {
    "login": {
      "token": "eyJhbGciOiJIUzUxMdWQiOBjzLZIjJ2Ur5lGRtD-ifKeOA"
    }
  }
}
````
#### Autorização

---

Lembrete: Deverá ter o header **Authentication**, informando o token, para efetuar essa requisição. Lembrando que o formato do header é `Authentication : Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9`.
##### Request - Schema
```javascript
query {
  authorization(password: String!) {
    token
  }
}
````
##### Request - Exemplo
```javascript
query {
  authorization(password: "123456") {
    token
  }
}
````
##### Response
```json
{
  "data": {
    "authorization": {
      "token": "eyJhbGciOiJIUzUxMdWQiOBjzLZIjJ2Ur5lGRtD-ifKeOA"
    }
  }
}
````
#### Relatório back office

---
##### Request - Exemplo
```javascript
query {
  reportBackOffice {
    totalDay
    totalYear
    totalMonth
  }
}
````
##### Response
```json
{
  "data": {
    "reportBackOffice": {
      "totalDay": "1000",
      "totalMonth": "1000",
      "totalYear": "1000"
    }
  }
}
````
#### Saque

---

Lembrete: Deverá ter o header **Authentication** e **Authorization**, informando seus respectivos tokens, para efetuar essa requisição. Lembrando que o formato do header é `Authentication : Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9` e `Authorization : Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9`; para cada saque é necessário gerar um novo token de autorização.
##### Request -  Schema
```javascript
mutation {
  withdrawal(value: Float!){
    message
    code
  }
}
````
##### Request -  Exemplo
```javascript
mutation {
  withdrawal(value: 50.55){
    message
    code
  }
}
````
##### Response
```json
{
  "data": {
    "withdrawal": {
      "code": 200,
      "message": "Saque realizado com sucesso. Um e-mail foi enviado para maria@email.com"
    }
  }
}
````
#### Transferência

---

Lembrete: Deverá ter o header **Authentication** e **Authorization**, informando seus respectivos tokens, para efetuar essa requisição. Lembrando que o formato do header é `Authentication : Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9` e `Authorization : Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9`; para cada transferência é necessário gerar um novo token de autorização.
##### Request - Schema
```javascript
mutation {
  transferency(
   account: String!
   agency: String!
   bankCode: String!
   value: Float!
  ){
    message
    code
  }
}
````
##### Request - Exemplo
```javascript
mutation {
  transferency(account: "14026", agency: "0001", bankCode: "003", value: 100.63){
    message
    code
  }
}
````
##### Response
```json
{
  "data": {
    "createAccount": {
      "code": 201,
      "message": "Created"
    }
  }
}
````
#### Saldo

---

Lembrete: Deverá ter o header **Authentication**, informando o token, para efetuar essa requisição. Lembrando que o formato do header é `Authentication : Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9`.
##### Request - Exemplo
```javascript
query {
  balance
}
````
##### Response
```json
{
  "data": {
    "balance": "949.45"
  }
}
````
#### Logout

---
##### Request - Exemplo
```javascript
mutation{
  logout{
  	code
    message
  }
}

````
##### Response
```json
{
  "data": {
    "logout": {
      "code": 200,
      "message": "OK"
    }
  }
}
````

