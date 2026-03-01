defmodule NovaControlWeb.ExpensesController do
  use NovaControlWeb, :controller

  alias Ecto.Changeset
  alias NovaControl.Finances.Expenses

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{data: Expenses.list_expenses()})
  end

  def create(conn, %{"expense" => attrs}) do
    case Expenses.create_expense(attrs) do
      {:ok, expense} ->
        conn
        |> put_status(:created)
        |> json(%{message: "Expense create successfully", data: expense})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          error: "Invalid data",
          details: errors(changeset)
        })
    end
  end

  def update(conn, %{"id" => id, "expense" => attrs}) do
    case Expenses.update_expense(id, attrs) do
      {:ok, expense} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Expense updated successfully", data: expense})

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Expense not found"})

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

  defp errors(changeset) do
    Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
