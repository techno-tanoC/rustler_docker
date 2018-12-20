defmodule Client do
  use Rustler, otp_app: :rustler_docker, crate: :client

  def add(_a, _b), do: exit(:nif_not_loaded)
end
