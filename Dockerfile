# ./Dockerfile

# Extend from the official Elixir image
FROM elixir:latest

RUN mkdir /api_bnk
COPY . /api_bnk
WORKDIR /api_bnk

ENV MIX_ENV dev
ENV PGUSER postgres
ENV PGPASSWORD postgres
ENV PGDATABASE api_bnk_dev
ENV PGHOST postgres_db


RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix deps.compile

