defmodule NovaControlWeb.SessionJSON do
  def show(%{user: user, access_token: token}) do
    %{
      message: "Login successful",
      user: %{
        id: user.id,
        name: user.name,
        email: user.email
      },
      access_token: token
    }
  end
end
