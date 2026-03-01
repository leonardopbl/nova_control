defmodule NovaControlWeb.FallbackController do
  use NovaControlWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> json(%{error: "Resource not found"})
  end

  def call(conn, {:error, :invalid_credentials}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "Invalid email or password"})
  end

  def call(conn, {:error, :no_valid_fields}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{
      error: "Invalid data",
      details: %{params: ["No valid fields provided for update"]}
    })
  end

  def call(conn, {:error, :invalid_user, changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: NovaControlWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: NovaControlWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end
end
