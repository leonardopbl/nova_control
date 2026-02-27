defmodule NovaControlWeb.UsersController do
  use NovaControlWeb, :controller

  alias NovaControl.Repo
  alias NovaControl.User

  @user_fields ["name", "email", "phone", "birth_date"]

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{data: Repo.all(User)})
  end

  def create(conn, params) do
    case %User{}
         |> User.changeset(user_params(params))
         |> Repo.insert() do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(%{data: user})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          error: "Invalid data",
          details: Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
        })
    end
  end

  def update(conn, %{"id" => id} = params) do
    case Repo.get(User, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      user ->
        attrs = user_params(params)

        if map_size(attrs) == 0 do
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{
            error: "Invalid data",
            details: %{params: ["No valid fields provided for update"]}
          })
        else
          case user
               |> User.changeset(attrs)
               |> Repo.update() do
            {:ok, updated_user} ->
              conn
              |> put_status(:ok)
              |> json(%{data: updated_user})

            {:error, changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> json(%{
                error: "Invalid data",
                details: Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
              })
          end
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Repo.get(User, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      user ->
        Repo.delete(user)

        conn
        |> put_status(:no_content)
        |> send_resp(:no_content, "")
    end
  end

  # so aceita dados no formato { "user": { "name": "John", "email": "
  defp user_params(%{"user" => attrs}) when is_map(attrs), do: Map.take(attrs, @user_fields)
  defp user_params(attrs) when is_map(attrs), do: Map.take(attrs, @user_fields)

  # defp user_params(attrs) when is_map(attrs), do: attrs // aceita dados no formato raiz, sem a chave "user"
end
