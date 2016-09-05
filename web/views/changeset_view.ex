defmodule Zizhixi.ChangesetView do
  use Zizhixi.Web, :view

  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` and
  `Zizhixi.ErrorHelpers.translate_error/1` for more details.
  """
  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{errors: translate_errors(changeset)}
  end

  def translate_errors(:flash, changeset) do
    changeset_errors = translate_errors(changeset)

    changeset_errors = Enum.map(changeset_errors, fn {field, errors} ->
      field_errors = Enum.map(errors, fn error -> "#{field} #{error}" end)
      Enum.join(field_errors, ". ")
    end)

    "#{Enum.join(changeset_errors, ". ")}."
  end
end
