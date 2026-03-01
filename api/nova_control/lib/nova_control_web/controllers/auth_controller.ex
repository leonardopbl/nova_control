defmodule NovaControlWeb.AuthController do
  use NovaControlWeb, :controller

  alias Ecto.Changeset
  alias NovaControl.Accounts

  def signup(conn, %{"user" => user_attrs, "password" => password}) do
    case Accounts.create_user(user_attrs, password) do
      {:ok, _result} ->
        conn
        |> put_status(:created)
        |> json(%{
          message: "User created successfully"
        })

      {:error, :invalid_user, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Invalid user data", details: errors(changeset)})

      {:error, :invalid_register, changeset} ->
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
    Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
