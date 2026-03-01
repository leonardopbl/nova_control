defmodule NovaControl.Finances.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:name, :amount, :type, :due_date, :payment_date, :user_id]
  @required_fields [:name, :amount, :type, :user_id]
  @derive {Jason.Encoder, only: [:id, :type, :due_date, :payment_date, :user_id]}

  schema "expenses" do
    field(:name, :string)
    field(:amount, :decimal)
    field(:type, :string)
    field(:due_date, :date)
    field(:payment_date, :date)

    belongs_to(:user, NovaControl.Accounts.User)

    timestamps()
  end

  def changeset(expense, attrs) do
    expense
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 3, max: 50)
    |> validate_number(:amount, greater_than: 0)
    |> validate_length(:type, min: 3, max: 50)
    |> foreign_key_constraint(:user_id)
  end
end
