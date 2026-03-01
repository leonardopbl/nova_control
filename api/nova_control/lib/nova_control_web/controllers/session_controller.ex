defmodule NovaControlWeb.SessionController do
  use NovaControlWeb, :controller

  alias Ecto.Changeset
  alias NovaControl.Accounts
  alias NovaControl.Auth.{LoginParams, Guardian}

  def login(conn, params) do
    case LoginParams.changeset(params)
         |> Changeset.apply_action(:validate) do
      {:ok, data} ->
        case Accounts.authenticate_user(data.email, data.password) do
          {:ok, user} ->
            {:ok, token, _claims} = Guardian.encode_and_sign(user)

            conn
            |> put_status(:ok)
            |> json(%{
              message: "Login successful",
              user: user,
              access_token: token
            })

          {:error, :invalid_credentials} ->
            conn
            |> put_status(:unauthorized)
            |> json(%{error: "Invalid email or password"})
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
