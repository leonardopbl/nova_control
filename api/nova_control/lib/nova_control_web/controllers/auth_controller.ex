defmodule NovaControlWeb.AuthController do
  use NovaControlWeb, :controller

  alias Ecto.Multi
  alias NovaControl.{Repo, User, Register}

  def signup(conn, %{"user" => user_attrs, "password" => password})
      when is_map(user_attrs) and is_binary(password) do
    multi =
      Multi.new()
      |> Multi.insert(:user, User.changeset(%User{}, user_attrs))
      |> Multi.insert(:register, fn %{user: user} ->
        Register.changeset(%Register{}, %{
          "user_id" => user.id,
          "email" => user.email,
          "password" => password,
          "provider" => "password"
        })
      end)

    case Repo.transaction(multi) do
      {:ok, %{user: user, register: register}} ->
        conn
        |> put_status(:created)
        |> json(%{
          data: %{
            user: user,
            register: %{
              id: register.id,
              user_id: register.user_id,
              email: register.email,
              provider: register.provider,
              inserted_at: register.inserted_at
            }
          }
        })

      {:error, :user, changeset, _} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Invalid user data", details: errors(changeset)})

      {:error, :register, changeset, _} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Invalid auth data", details: errors(changeset)})
    end
  end

  def signup(conn, _params) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: "Invalid payload. Expected user object and password"})
  end

  defp errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
