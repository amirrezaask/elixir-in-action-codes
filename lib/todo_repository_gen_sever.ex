defmodule ElixirInAction.TodoRepositoryGenServer do
  use GenServer

  # interface

  def get(server, user_id) do
    GenServer.call(server, {:get, user_id})
  end


  def add(server, user_id, todo) do
    GenServer.cast(server, {:add, user_id, todo})
  end

  # implementation
  @impl true
  def init(_) do
    {:ok, Map.new()}
  end

  @impl true
  def handle_call({:get, id}, _from, state) do
    {:reply, Map.get(state, id), state}
  end

  @impl true
  def handle_cast({:add, user_id, todo_content}, state) do
    user_todos = Map.get(state, user_id, [])
    user_todos = [todo_content | user_todos]
    {:noreply, Map.put(state, user_id, user_todos)}
  end
end
