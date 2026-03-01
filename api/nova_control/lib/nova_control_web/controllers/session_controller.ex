defmodule NovaControlWeb.SessionController do
  use NovaControlWeb, :controller

  alias Ecto.Changeset
  alias NovaControl.Accounts
  alias NovaControl.Auth.{LoginParams, Guardian}

  action_fallback(NovaControlWeb.FallbackController)

  def login(conn, params) do
    with {:ok, data} <-
           LoginParams.changeset(params)
           |> Changeset.apply_action(:validate),
         {:ok, user} <- Accounts.authenticate_user(data.email, data.password),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:ok)
      |> render(:show, user: user, access_token: token)
    end
  end
end
