defmodule NovaControlWeb.ExpensesController do
  use NovaControlWeb, :controller

  alias NovaControl.Expense
  alias NovaControl.Repo

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{data: Repo.all(Expense)})
  end

  def create(conn, params) do
    case %Expense{}
         |> Expense.changeset(expense_params(params))
         |> Repo.insert() do
      {:ok, expense} ->
        conn
        |> put_status(:created)
        |> json(%{message: "Expense created successfully", data: expense})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          error: "Invalid data",
          details: Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
        })
    end
  end

  def update(conn, %{"id" => id} = params) do
    case Repo.get(Expense, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Expense not found"})

      expense ->
        attrs = expense_params(params)

        if map_size(attrs) == 0 do
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{
            error: "Invalid data",
            details: %{params: ["No valid fields provided for update"]}
          })
        else
          case expense
               |> Expense.changeset(attrs)
               |> Repo.update() do
            {:ok, updated_expense} ->
              conn
              |> put_status(:ok)
              |> json(%{message: "Expense updated successfully", data: updated_expense})

            {:error, changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> json(%{
                error: "Invalid data",
                details: Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
              })
          end
        end
    end
  end

  defp expense_params(%{"expense" => attrs}) when is_map(attrs), do: attrs
end
