defmodule NovaControl.Auth do
  alias NovaControl.{Repo, Register, User}

  def auth(email, password) do
    case Repo.get_by(Register, email: email, provider: "password") do
      nil ->
        {:error, :invalid_credentials, "No user found"}

      register ->
        if Bcrypt.verify_pass(password, register.password_hash) do
          user = Repo.get(User, register.user_id)
          {:ok, user}
        else
          {:error, :invalid_credentials, "Invalid password"}
        end
    end
  end
end
