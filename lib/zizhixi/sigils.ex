defmodule Zizhixi.Sigils do

  def sigil_t(string, []) do
    Gettext.gettext(Zizhixi.Gettext, string)
  end
end
