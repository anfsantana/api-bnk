defmodule ApiBnK.Utils.StatusResponse do
  @moduledoc """
  Módulo que contém a definição dos códigos de resposta
  """

  @type status_response :: %{code: integer, message: String.t()}

  @doc """
  Obtém o map %{code message} de código de resposta de sua descrição

  ## Parâmetros

    - key: Chave de tipo atomo do map que contêm os códigos de resposta com as descrições

  ## Exemplos

      iex> ApiBnK.Utils.StatusResponse.get_status_response_by_key(:OK)
      %{ code: 200, message: "OK" }

      iex> ApiBnK.Utils.StatusResponse.get_status_response_by_key(:UNPROCESSABLE_ENTITY)
      %{ code: 422, message: "Unprocessable Entity"}
  """
  @spec get_status_response_by_key(Atom.t()) :: status_response
  def get_status_response_by_key(key) do
     map = %{OK: %{code: 200, message: "OK" },
        CREATED: %{code: 201, message: "Created" },
        NO_CONTENT: %{code: 204, message: "No Content"},
        UNPROCESSABLE_ENTITY: %{code: 422, message: "Unprocessable Entity"},
        INTERNAL_SERVER_ERROR: %{code: 500, message: "Internal Server Error"}}
     map[key]
  end

  @doc """
  Obtém o map %{code message} de código de resposta com a nova mensagem informada

  ## Parâmetros

    - key: Chave do map que contêm os códigos de resposta
    - message: Nova mensagem do código de resposta

  ## Exemplos

      iex> ApiBnK.Utils.StatusResponse.format_output(:OK, "Nova mensagem")
      %{ code: 200, message: "Nova mensagem" }

      iex> ApiBnK.Utils.StatusResponse.format_output(:UNPROCESSABLE_ENTITY, "Mensagem nova")
      %{ code: 422, message: "Mensagem nova"}
  """
  @spec format_output(Atom.t(), String.t()) :: status_response
  def format_output(key, message) do
    %{get_status_response_by_key(key) | message: message}
  end

end
