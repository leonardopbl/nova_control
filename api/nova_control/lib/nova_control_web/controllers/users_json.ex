defmodule NovaControlWeb.UsersJSON do
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      birth_date: user.birth_date
    }
  end
end
