defmodule NovaControlWeb.SessionController do
  use NovaControlWeb, :controller

  alias Ecto.Changeset
  alias NovaControl.LoginParams
  alias NovaControl.Auth

  def login(conn, params) do
    case LoginParams.changeset(params)
         |> Changeset.apply_action(:validate) do
      {:ok, data} ->
        case Auth.auth(data.email, data.password) do
          {:ok, user} ->
            conn
            |> put_status(:ok)
            |> json(%{message: "Login successful", user: user})

          {:error, _code, message} ->
            conn
            |> put_status(:unauthorized)
            |> json(%{error: message})
        end

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Invalid login data", details: errors(changeset)})
    end
  end

  defp errors(changeset) do
    Changeset.traverse_errors(changeset, fn {msg, _opt} -> msg end)
  end
end
