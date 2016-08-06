defmodule BibleStudy.Sermons do
  @resource_sources Application.get_env(:bible_study, :resource_sources)

  def start_link(source, passage, sermon_ref, owner) do
    source.start_link(passage, sermon_ref, owner)
  end

  def find(passage) do
    @resource_sources
    |> Enum.map(&find_sermons(&1, passage))
    |> await_results
  end

  defp find_sermons(source, passage) do
    sermon_ref = make_ref()
    opts = [source, passage, sermon_ref, self()]
    {:ok, pid} = BibleStudy.Sermons.Supervisor.start_child(opts)
    monitor_ref = Process.monitor(pid)
    {pid, monitor_ref, sermon_ref}
  end

  defp await_results(children) do
    timer = Process.send_after(self(), :timedout, 5000)
    results = await_result(children, [], :infinity)
    cleanup(timer)
    results
  end

  defp await_result([head|tail], acc, timeout) do
    {pid, monitor_ref, sermon_ref} = head

    receive do
      {:results, ^sermon_ref, results} ->
        Process.demonitor(monitor_ref, [:flush])
        await_result(tail, results ++ acc, timeout)
      {:DOWN, ^monitor_ref, :process, ^pid, _reason} ->
        await_result(tail, acc, timeout)
      :timedout ->
        kill(pid, monitor_ref)
        await_result(tail, acc, 0)
    after
      timeout ->
        kill(pid, monitor_ref)
        await_result(tail, acc, 0)
    end
  end
  defp await_result([], acc, _), do: acc

  defp kill(pid, ref) do
    Process.demonitor(ref, [:flush])
    Process.exit(pid, :kill)
  end

  defp cleanup(timer) do
    :erlang.cancel_timer(timer)
    receive do
      :timedout -> :ok
    after
      0 -> :ok
    end
  end
end
