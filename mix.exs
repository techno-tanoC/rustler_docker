defmodule RustlerDocker.MixProject do
  use Mix.Project

  def project do
    [
      app: :rustler_docker,
      version: "0.1.0",
      elixir: "~> 1.7",
      compilers: compilers(),
      rustler_crates: rustler_crates(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler, "~> 0.18.0"}
    ]
  end

  defp compilers do
    if System.get_env("NO_RUSTLER_COMPILE") do
      Mix.compilers
    else
      [:rustler] ++ Mix.compilers
    end
  end

  defp rustler_crates() do
    [
      client: [
        path: "native/client",
        mode: (if Mix.env == :prod, do: :release, else: :debug)
      ]
    ]
  end
end
