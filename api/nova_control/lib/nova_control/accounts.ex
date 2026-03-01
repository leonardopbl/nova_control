defmodule NovaControl.Accounts do
  alias Ecto.Multi
  alias NovaControl.Repo
  alias NovaControl.Accounts.{User, Register}

  @user_fields ["name", "email", "phone", "birth_date"]

  def create_user(user_attrs, password) do
    multi =
      Multi.new()
      |> Multi.insert(:user, User.changeset(%User{}, user_attrs))
      |> Multi.insert(:register, fn %{user: user} ->
        Register.changeset(%Register{}, %{
          "user_id" => user.id,
          "email" => user.email,
          "password" => password,
          "provider" => "password"
        })
      end)

    case Repo.transaction(multi) do
      {:ok, %{user: user, register: register}} ->
        {:ok, %{user: user, register: register}}

      {:error, :user, changeset, _} ->
        {:error, :invalid_user, changeset}

      {:error, :register, changeset, _} ->
        {:error, :invalid_register, changeset}
    end
  end

  def list_users do
    Repo.all(User)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def update_user(id, attrs) when not is_struct(id) do
    case get_user(id) do
      nil ->
        {:error, :not_found}

      user ->
        filtered_attrs = Map.take(attrs, @user_fields)

        if map_size(filtered_attrs) == 0 do
          {:error, :no_valid_fields}
        else
          update_user(user, filtered_attrs)
        end
    end
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(id) when not is_struct(id) do
    case get_user(id) do
      nil -> {:error, :not_found}
      user -> delete_user(user)
    end
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def authenticate_user(email, password) do
    case get_register_by_email(email) do
      nil ->
        {:error, :invalid_credentials}

      register ->
        if Bcrypt.verify_pass(password, register.password_hash) do
          case get_user(register.user_id) do
            nil -> {:error, :invalid_credentials}
            user -> {:ok, user}
          end
        else
          {:error, :invalid_credentials}
        end
    end
  end

  defp get_register_by_email(email) do
    Repo.get_by(Register, email: email, provider: "password")
  end
end
