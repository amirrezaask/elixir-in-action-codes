defmodule ElixirInActionTest.TodoGenServerRepositoryTest do
  use ExUnit.Case
  alias ElixirInAction.TodoRepositoryGenServer, as: Repository

  test "adding a todo" do
    {:ok, pid } = GenServer.start_link(Repository, nil)
    assert is_pid(pid)
    assert Repository.add(pid, "amirreza", "first todo")
    assert Repository.get(pid, "amirreza") == ["first todo"]
  end
end
