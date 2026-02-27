defmodule NovaControl.Repo.Migrations.CreateRegister do
  use Ecto.Migration

  def change do
    create table(:registers) do
      add(:email, :string)
      add(:password_hash, :string)
      add(:provider, :string)
      add(:provider_user_id, :string)
      add(:last_login_at, :date)
      add(:confirmed_at, :date)
      add(:user_id, references(:users, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(index(:registers, [:email]))
    create(index(:registers, [:provider]))
  end
end
