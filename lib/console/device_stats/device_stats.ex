defmodule Console.DeviceStats do
  import Ecto.Query, warn: false
  alias Console.Repo

  alias Console.DeviceStats.DeviceStat

  def create_stat(attrs \\ %{}) do
    %DeviceStat{}
    |> DeviceStat.changeset(attrs)
    |> Repo.insert()
  end

  def create_stat!(attrs \\ %{}) do
    %DeviceStat{}
    |> DeviceStat.changeset(attrs)
    |> Repo.insert!()
  end
end
