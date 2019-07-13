# API Banking

### Introdução
A API Banking é um projeto que simula um processo de transações financeiras, desde do cadastro de contas,
autenticação de contas, autorização para efetuar transações atualização de dados da conta, 

1. A API foi desenvolvida com:

    1. Elixir;
    2. **[GraphQL](https://graphql.org/)**;
    3. Postgres.

2. Para executar o projeto, é necessário possuir:

    - Elixir;
    - Postgres.
    
    2.1. Para iniciar o serviço:
       
       * Instale as dependências com `mix deps.get`;
       * Crie e migre seu banco de dados com `mix ecto.create && mix ecto.migrate`;
       * Incie o endpoint do serviço com `mix phx.server`.
    
3. Para utilizar **docker**:
    1. Execute o comando: `docker build --tag apibnk .`
    2. Execute o comando: `docker-compose up`

A **documentação** dos **módulos** estão localizadas no diretório `api_bnk/doc`

A **documentação** das consultas **[GraphQL](https://graphql.org/)** são disponibilizadas na própria rota do 
serviço [`localhost:4000/api/graphiql`](http://localhost:4000/api/graphiql). 
 Para visualizar essa documentação GraphQL, utilize uma espécie 
de postman para **[GraphQL](https://graphql.org/)**; recomendo https://electronjs.org/apps/graphiql .

- Utilize a rota [`localhost:4000/api/graphiql`](http://localhost:4000/api/graphiql) para ter acesso aos recursos da API.
    - Existem dois tipos de HTTP Headers:
        1. Token de autenticação
            - Header name: **Authentication**
            - Header value: **Bearer** \<Token\>
                - Exemplo: **Authentication : Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9**
        2. Token de autorização: Utilizado para efetuar determinadas operações financeiras
            - Header name: **Authentication**
            - Header value: **Bearer** \<Token\>
                - Exemplo: **Authentication : Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9**
        
