defmodule RustlerDockerTest do
  use ExUnit.Case
  doctest RustlerDocker

  test "greets the world" do
    assert RustlerDocker.hello() == :world
  end
end
