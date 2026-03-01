defmodule NovaControlWeb.UsersController do
  use NovaControlWeb, :controller

  alias NovaControl.Accounts

  action_fallback(NovaControlWeb.FallbackController)

  def index(conn, _params) do
    users = Accounts.list_users()

    conn
    |> put_status(:ok)
    |> render(:index, users: users)
  end

  def update(conn, %{"id" => id, "user" => user_attrs}) do
    with {:ok, user} <- Accounts.update_user(id, user_attrs) do
      conn
      |> put_status(:ok)
      |> render(:show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, _user} <- Accounts.delete_user(id) do
      send_resp(conn, :no_content, "")
    end
  end
end
