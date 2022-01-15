defmodule CalculatorRaw do
  def start do
    spawn(&handler/0)
  end
  # interface functions
  def plus(server, arg1, arg2), do: send(server, {:plus, arg1, arg2, self()})
  def minus(server, arg1, arg2), do: send(server, {:minus, arg1, arg2, self()})
  def div(server, arg1, arg2), do: send(server, {:div, arg1, arg2, self()})
  def mul(server, arg1, arg2), do: send(server, {:mul, arg1, arg2, self()})

  # implementation of the server
  defp calculator({:plus, arg1, arg2, client}), do: send(client, {:result, arg1+arg2})
  defp calculator({:minus, arg1, arg2, client}), do: send(client, {:result, arg1-arg2})
  defp calculator({:mul, arg1, arg2, client}), do: send(client, {:result, arg1*arg2})
  defp calculator({:div, arg1, arg2, client}), do: send(client, {:result, arg1/arg2})

  defp handler do
    receive do
      msg -> calculator(msg)
    end
    handler()
  end
end

server_pid = CalculatorRaw.start()
CalculatorRaw.plus(server_pid, 2, 3)
receive do
  {:result, res} -> IO.puts res
end
