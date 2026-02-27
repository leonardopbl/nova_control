defmodule NovaControl.LoginParams do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:email, :password]

  @primary_key false
  embedded_schema do
    field(:email, :string)
    field(:password, :string)
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> validate_length(:password, min: 8, max: 72)
  end
end
