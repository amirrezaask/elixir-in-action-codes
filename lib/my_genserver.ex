defmodule MyGenserver do
  def start(mod) do
    spawn(fn ->
      initial_state = mod.init()
      loop(mod, initial_state)
    end)
  end

  def cast(pid, req) do
    send(pid, {:cast, req})
  end

  def call(pid, req) do
    send(pid, {:call, req, self()})

    receive do
      {:response, resp} -> resp
    end
  end

  defp loop(mod, state) do
    receive do
      {:call, req, caller} ->
        {resp, new_state} = mod.handle_call(req, state)
        send(caller, {:response, resp})
        loop(mod, new_state)

      {:cast, req} ->
        new_state = mod.handle_call(req, state)
        loop(mod, new_state)
    end
  end
end

defmodule KVStore do
  def init do
    Map.new()
  end

  def handle_call({:put, k, v}, state) do
    {:ok, Map.put(state, k, v)}
  end

  def handle_call({:get, k}, state) do
    {state[k], state}
  end

  def handle_cast({:put, k, v}, state) do
    Map.put(state, k, v)
  end

  # interface
  def put(server_pid, key, value) do
    MyGenServer.call(server_pid, {:put, key, value})
  end

  def get(server_pid, key) do
    MyGenServer.call(server_pid, {:get, key})
  end
end

pid = MyGenServer.start(KVStore)
IO.puts(MyGenServer.call(pid, {:put, :name, "amirreza"}))
IO.puts(MyGenServer.call(pid, {:get, :name}))
IO.puts(KVStore.get(pid, :name))
