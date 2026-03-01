defmodule NovaControlWeb.ExpensesJSON do
  def index(%{expenses: expenses}) do
    %{data: for(expense <- expenses, do: data(expense))}
  end

  def show(%{expense: expense}) do
    %{data: data(expense)}
  end

  defp data(expense) do
    %{
      id: expense.id,
      name: expense.name,
      amount: expense.amount,
      type: expense.type,
      due_date: expense.due_date,
      payment_date: expense.payment_date,
      user_id: expense.user_id
    }
  end
end
