defmodule ElixirInAction.TodoServerGenServer do
  use GenServer
  # gets the module name of the repository to use.
  def init(repo) do
    {:ok, repo}
  end

  def handle_call({}, from, state) do

  end

  def handle_cast() do

  end
end
