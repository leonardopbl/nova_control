defmodule NovaControlWeb.UsersController do
  use NovaControlWeb, :controller

  alias Ecto.Changeset
  alias NovaControl.Accounts

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{data: Accounts.list_users()})
  end

  def update(conn, %{"id" => id, "user" => user_attrs}) do
    case Accounts.update_user(id, user_attrs) do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> json(%{data: user})

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      {:error, :no_valid_fields} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          error: "Invalid data",
          details: %{params: ["No valid fields provided for update"]}
        })

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          error: "Invalid data",
          details: errors(changeset)
        })
    end
  end

  def delete(conn, %{"id" => id}) do
    case Accounts.delete_user(id) do
      {:ok, _user} ->
        conn
        |> put_status(:no_content)
        |> json(%{message: "User deleted successfully"})

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})
    end
  end

  defp errors(changeset) do
    Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
