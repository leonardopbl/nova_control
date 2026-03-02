defmodule NovaControlWeb.Auth.ErrorHandler do
  import Plug.Conn
  import Phoenix.Controller

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "Unauthorized"})
  end
end
