defmodule NovaControlWeb.AuthController do
  use NovaControlWeb, :controller

  alias Ecto.Changeset
  alias NovaControl.Accounts

  action_fallback(NovaControlWeb.FallbackController)

  def signup(conn, %{"user" => user_attrs, "password" => password}) do
    with {:ok, user} <- Accounts.create_user(user_attrs, password) do
      conn
      |> put_status(:created)
      |> json(%{
        message: "User created successfully"
      })
    end
  end

  def signup(conn, _params) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: "Invalid payload. Expected user object and password"})
  end
end
