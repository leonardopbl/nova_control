defmodule NovaControl.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:name, :string)
      add(:email, :string)
      add(:phone, :string)
      add(:birth_date, :date)

      timestamps()
    end

    create(unique_index(:users, [:email]))
    create(index(:users, [:name]))
  end
end
