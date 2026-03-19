defmodule NovaControl.Accounts.Register do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :user_id,
    :email,
    :provider,
    :provider_user_id,
    :last_login_at,
    :confirmed_at
  ]
  @required_fields [:user_id, :email, :password]
  @derive {Jason.Encoder,
           only: [
             :id,
             :user_id,
             :email,
             :password_hash,
             :provider,
             :provider_user_id,
             :last_login_at,
             :confirmed_at,
             :inserted_at,
             :updated_at
           ]}

  schema "registers" do
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    field(:provider, :string)
    field(:provider_user_id, :string)
    field(:last_login_at, :utc_datetime)
    field(:confirmed_at, :utc_datetime)

    belongs_to(:user, NovaControl.Accounts.User)

    timestamps()
  end

  def changeset(register, attrs) do
    register
    |> cast(attrs, @fields ++ [:password])
    |> validate_required(@required_fields)
    |> validate_length(:password, min: 8, max: 72)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> put_password_hash()
    |> validate_required([:password_hash])
    |> foreign_key_constraint(:user_id)
  end

  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
    end
  end
end
