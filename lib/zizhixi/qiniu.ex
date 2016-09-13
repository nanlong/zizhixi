defmodule Zizhixi.Qiniu do
  def upload(file) do
    filename = generate_filename(file)
    upload(file, filename)
  end

  def upload(file, filename) do
    put_policy = Qiniu.PutPolicy.build("zizhixi")
    response = Qiniu.Uploader.upload put_policy, file.path, key: filename
    
    case response.body do
      %{"hash" => hash, "key" => key} ->
        {:ok, %{
          hash: hash,
          key: key,
          url: "https://odf91nqvz.qnssl.com/#{filename}"
        }}
      errors ->
        {:error, errors}
    end
  end

  def filename_and_url(file) do
    filename = generate_filename(file)
    [filename, "https://odf91nqvz.qnssl.com/#{filename}"]
  end

  defp generate_filename(file) do
    filetype = file.filename |> String.split(".") |> List.last
    str = "#{file.content_type}#{file.path}#{file.filename}"

    filename = :crypto.hash(:md5, str)
    |> Base.encode16(case: :lower)

    "#{filename}.#{filetype}"
  end
end
