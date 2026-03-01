defmodule NovaControl.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:name, :email, :phone, :birth_date]
  @required_fields [:name, :email]
  @derive {Jason.Encoder,
           only: [:id, :name, :email, :phone, :birth_date, :inserted_at, :updated_at]}

  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:phone, :string)
    field(:birth_date, :date)

    has_many(:expenses, NovaControl.Finances.Expense)

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 3, max: 50)
    |> validate_length(:email, min: 6, max: 50)
    |> validate_length(:phone, min: 8, max: 14)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> unique_constraint(:email)
  end
end
