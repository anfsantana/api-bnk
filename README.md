# ApiBnK

A API foi desenvolvida com:

1. Elixir;
2. **[GraphQL](https://graphql.org/)**;
3. Postgres.

Para executar o projeto, é necessário possuir:

- Elixir;
- Postgres.

A **documentação** dos **módulos** estão localizadas em ...

A **documentação** das consultas **[GraphQL](https://graphql.org/)** são disponibilizadas na própria rota do 
serviço [`localhost:4000/api/graphiql`](http://localhost:4000/api/graphiql). 
 Para visualizar essa documentação GraphQL, utilize uma espécie 
de postman para **[GraphQL](https://graphql.org/)**; recomendo https://electronjs.org/apps/graphiql .

Para iniciar o serviço:

  * Instale as dependências com `mix deps.get`;
  * Crie e migre seu banco de dados com `mix ecto.create && mix ecto.migrate`;
  * Incie o endpoint do serviço com `mix phx.server`.

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
        



Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).


