defmodule NovaControl.Repo.Migrations.CreateExpenses do
  use Ecto.Migration

  def change do
    create table(:expenses) do
      add(:name, :string)
      add(:amount, :decimal)
      add(:type, :string)
      add(:due_date, :date)
      add(:payment_date, :date)
      add(:user_id, references(:users, on_delete: :nothing), null: false)

      timestamps()
    end

    create(index(:expenses, [:type]))
    create(index(:expenses, [:name]))
    create(index(:expenses, [:user_id]))
  end
end
