# ApiBnK

A API foi desenvolvida com:

1. Elixir;
2. GraphQL;
3. Postgres.

Para iniciar o serviço:

  * Instale as dependências com `mix deps.get`;
  * Crie e migre seu banco de dados com `mix ecto.create && mix ecto.migrate`;
  * Incie o endpoint do serviço com `mix phx.server`.

Utilize a rota [`localhost:4000/api/graphiql`](http://localhost:4000/api/graphiql) para ter acesso aos recursos da API.

Existem duas documentações:

1. A do projeto, que está disponibilizada no diretório 'doc';
2. A do esquema GraphQL em que para visualizar essa documentação é necessário utilizar uma GUI utilizada para editar e testar queries e mutations GraphQL. Recomendo esta https://electronjs.org/apps/graphiql


Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).


