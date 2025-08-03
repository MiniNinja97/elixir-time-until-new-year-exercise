defmodule NewyearAppTest do
  use ExUnit.Case
  doctest NewyearApp

  test "greets the world" do
    assert NewyearApp.hello() == :world
  end
end
