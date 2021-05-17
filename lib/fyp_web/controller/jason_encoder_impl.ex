defmodule FypWeb.JasonEncoderImpl do
  defimpl Jason.Encoder, for: Paginator.Page.Metadata do
    def encode(value, opts) do
      Jason.Encode.map(Map.take(value, [:after, :before, :limit, :total_count, :total_count_cap_exceeded]), opts)
    end
  end
end
