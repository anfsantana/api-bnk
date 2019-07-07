defmodule ApiBnK.Blog.PostResolver do
  alias ApiBnK.Blog
  alias ApiBnK.Accounts.UserResolver

  def all(_args, %{context: %{current_user: current_user}}) do
    {:ok, Blog.list_posts()}
  end

  def all(_args, _info) do
	  {:error, "Not Authorized"}
  end

  def find(%{id: id}, %{context: %{current_user: _current_user}}) do
    case Blog.get_post_by_id(id) do
      nil -> {:error, "Post id #{id} not found"}
      post -> {:ok, post}
    end
  end

  def find(_args, _info) do
	  {:error, "Not Authorized"}
  end

  # TODO Modificado por anf
  def create(args, ctx = %{context: %{current_user: _current_user}}) do
    case Blog.create_post(args) do
      {:ok, post} -> UserResolver.logout(args, ctx)
      {:error, msg} -> {:error, "Message: #{msg}}"}
    end
  end

  def create(_args, _info) do
	  {:error, "Not Authorized"}
  end

  def update(%{id: id, post: post_params}, %{context: %{current_user: _current_user}} = info) do
    case find(%{id: id}, info) do
      {:ok, post} -> post |> Blog.update_post(post_params)
      {:error, _} -> {:error, "Post id #{id} not found"}
    end

  end

  def update(_args, _info) do
	  {:error, "Not Authorized"}
  end

  def delete(%{id: id}, %{context: %{current_user: _current_user}} = info) do
    case find(%{id: id}, info) do
      {:ok, post} -> post |> Blog.delete_post()
      {:error, _} -> {:error, "Post id #{id} not found"}
    end

  end

  def delete(_args, _info) do
	  {:error, "Not Authorized"}
  end
end
