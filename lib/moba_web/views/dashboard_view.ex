defmodule MobaWeb.DashboardView do
  use MobaWeb, :view

  alias Moba.Accounts

  def next_medal_percentage(%{season_tier: current_tier, season_points: season_points}) do
    max = Accounts.season_points_for(current_tier + 1)
    season_points * 100 / max
  end

  def next_medal(%{season_tier: current_tier}) do
    cond do
      current_tier >= Moba.max_season_tier() -> nil
      true -> current_tier + 1
    end
  end

  def rewards_for(ranking) do
    number = round(3 / ranking)

    medals =
      Enum.reduce(1..number, "", fn _n, acc ->
        acc <> "<i class='fa fa-medal'></i>"
      end)

    raw(medals)
  end

  def shards_for(ranking, league_tier) do
    number = round(3 / ranking)
    total = 50 + number * 50

    if league_tier == Moba.max_league_tier() do
      total
    else
      div(total, 2)
    end
  end
end