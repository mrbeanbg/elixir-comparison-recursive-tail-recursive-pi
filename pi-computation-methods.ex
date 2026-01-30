defmodule PiComputationMethods do

  # Leibniz - izpolzwane na rekursia
  defp leibniz_series_recursive(0), do: 1
  defp leibniz_series_recursive(n) do
    sign = if rem(n, 2) == 0, do: 1, else: -1
    sign/(2*n+1) + leibniz_series_recursive(n-1)
  end
  def leibniz_recursive_pi(n), do: 4 * leibniz_series_recursive(n)

  # Leiniz - iterativen podhod / tail-recursion
  defp leibniz_series_iterative_tail_recursive(acc, _sign, n) when n < 0 , do: 4 * acc
  defp leibniz_series_iterative_tail_recursive(acc, sign, n) do
    leibniz_series_iterative_tail_recursive(acc + sign/(2*n+1), sign*(-1), n-1)
  end
  def leibniz_iterative_tail_recursive_pi(n) do
    sign = if rem(n, 2) == 0, do: 1, else: -1
    leibniz_series_iterative_tail_recursive(sign/(2*n+1), sign*(-1), n-1)
  end

  # Wallis - izpolzwane na rekursia
  defp wallis_series_recursive(n) when n < 2, do: 4 / 3
  defp wallis_series_recursive(n) do
    (2*n/(2*n-1)) * (2*n/(2*n+1)) * wallis_series_recursive(n-1)
  end
  def wallis_recursive_pi(n), do: 2 * wallis_series_recursive(n)

  # Wallis - iterativen podhod / tail-recursion
  defp wallis_series_iterative_tail_recursive(acc, n) when n < 1 , do: 2 * acc
  defp wallis_series_iterative_tail_recursive(acc, n) do
    wallis_series_iterative_tail_recursive(acc * (2*n/(2*n-1)) * (2*n/(2*n+1)), n-1)
  end
  def wallis_iterative_tail_recursive_pi(n) do
    wallis_series_iterative_tail_recursive((2*n/(2*n-1)) * (2*n/(2*n+1)), n-1)
  end


  # Viete - izpolzvane na rekursia
  # Vlojen koren: sqrt(2), sqrt(2+sqrt(2)), sqrt(2+sqrt(2+sqrt(2))) √(2+√(2+√2)), ...
  defp nested_sqrt(1), do: :math.sqrt(2)
  defp nested_sqrt(n), do: :math.sqrt(2 + nested_sqrt(n-1))

  defp viete_series_recursive(1), do: :math.sqrt(2) / 2
  defp viete_series_recursive(n) do
    nested_sqrt(n) / 2 * viete_series_recursive(n-1)
  end

  def viete_recursive_pi(n), do: 2 / viete_series_recursive(n)

  # Viete - iterativen podhod / tail-recursion
  defp viete_series_iterative_tail_recursive(acc, _a, n) when n < 1, do: 2 / acc
  defp viete_series_iterative_tail_recursive(acc, a, n) do
    viete_series_iterative_tail_recursive(acc * (a / 2), :math.sqrt(2 + a), n - 1)
  end

  def viete_iterative_tail_recursive_pi(n) do
    a = :math.sqrt(2)
    viete_series_iterative_tail_recursive(a / 2, :math.sqrt(2 + a), n - 1)
  end

  def benchmark do
  n_values = [10, 30, 100, 1000, 10000, 100000]

  Enum.each(n_values, fn n ->
    IO.puts("\n" <> String.duplicate("=", 85))
    IO.puts("n = #{n}")
    IO.puts(String.duplicate("=", 85))

    tests = [
      {"Leibniz recursive", fn -> leibniz_recursive_pi(n) end},
      {"Leibniz iterative", fn -> leibniz_iterative_tail_recursive_pi(n) end},
      {"Wallis recursive",  fn -> wallis_recursive_pi(n) end},
      {"Wallis iterative",  fn -> wallis_iterative_tail_recursive_pi(n) end},
      {"Viete recursive",   fn -> viete_recursive_pi(n) end},
      {"Viete iterative",   fn -> viete_iterative_tail_recursive_pi(n) end}
    ]

    Enum.each(tests, fn {name, func} ->
      :erlang.garbage_collect()
      mem_before = :erlang.process_info(self(), :memory) |> elem(1)

      {time, result} = :timer.tc(func)

      mem_after = :erlang.process_info(self(), :memory) |> elem(1)
      memory_kb = (mem_after - mem_before) / 1024

      error = abs(:math.pi() - result)
      time_ms = time / 1_000

      IO.puts(
        "#{String.pad_trailing(name, 20)} | " <>
        "π ≈ #{Float.round(result, 10)} | " <>
        "error: #{Float.round(error, 15)} | " <>
        "time: #{Float.round(time_ms, 3)} ms | " <>
        "~mem: #{Float.round(memory_kb, 2)} KB"
      )
    end)
  end)

  IO.puts("\n" <> String.duplicate("=", 85))
  IO.puts("Note: ~mem e pribilizitelno izpolzvana pamet (zaradi garbage collection)")
  IO.puts(String.duplicate("=", 85))
end
end
