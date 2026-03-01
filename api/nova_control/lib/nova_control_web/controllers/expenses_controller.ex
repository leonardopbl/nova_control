defmodule NovaControlWeb.ExpensesController do
  use NovaControlWeb, :controller

  alias NovaControl.Finances.Expenses

  action_fallback(NovaControlWeb.FallbackController)

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> render(:index, expenses: Expenses.list_expenses())
  end

  def create(conn, %{"expense" => attrs}) do
    with {:ok, expense} <- Expenses.create_expense(attrs) do
      conn
      |> put_status(:created)
      |> render(:show, expense: expense)
    end
  end

  def update(conn, %{"id" => id, "expense" => attrs}) do
    with {:ok, expense} <- Expenses.update_expense(id, attrs) do
      conn
      |> put_status(:ok)
      |> render(:show, expense: expense)
    end
  end
end
