defmodule NovaControlWeb.ChangesetJSON do
  alias Ecto.Changeset

  def error(%{changeset: changeset}) do
    %{
      error: "Validation failed",
      details: translate_errors(changeset)
    }
  end

  defp translate_errors(changeset) do
    Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
