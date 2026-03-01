defmodule NovaControl.Finances.Expenses do
  alias NovaControl.Repo
  alias NovaControl.Finances.Expense

  def list_expenses do
    Repo.all(Expense)
  end

  def get_expense(id) do
    Repo.get(Expense, id)
  end

  def create_expense(attrs) do
    %Expense{}
    |> Expense.changeset(attrs)
    |> Repo.insert()
  end

  def update_expense(id, attrs) when not is_struct(id) do
    case get_expense(id) do
      nil ->
        {:error, :not_found}

      expense ->
        if map_size(attrs) == 0 do
          {:error, :no_valid_fields}
        else
          update_expense(expense, attrs)
        end
    end
  end

  def update_expense(%Expense{} = expense, attrs) do
    expense
    |> Expense.changeset(attrs)
    |> Repo.update()
  end
end
