defmodule BibleStudy.Sermons.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child(opts) do
    Supervisor.start_child(__MODULE__, opts)
  end

  def init(_opts) do
    children = [
      worker(BibleStudy.Sermons, [], restart: :temporary)
    ]

    supervise children, strategy: :simple_one_for_one
  end
end
