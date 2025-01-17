defmodule Moba.Engine do
  @moduledoc """
  Top-level domain of all battle related logic

  As a top-level domain, it can access its siblings like Game and Accounts, its parent (Moba)
  and all of its children (Core, Battles). It cannot, however, access children of its
  siblings.
  """

  alias Moba.{Game, Engine}
  alias Engine.{Battles, Core}

  def battle_types, do: %{pve: "pve", pvp: "pvp", league: "league", duel: "duel"}

  # BATTLES MANAGEMENT

  def get_battle!(id), do: Battles.get!(id)

  def update_battle!(battle, attrs), do: Battles.update!(battle, attrs)

  def list_battles(hero, type, page \\ 1, limit \\ 5) do
    Battles.list(hero, type, page, limit)
  end

  def first_duel_battle(duel), do: Battles.first_from_duel(duel)

  def last_duel_battle(duel), do: Battles.last_from_duel(duel)

  def pending_battle(hero_id), do: Battles.pending_for(hero_id)

  def latest_battle(hero_id), do: Battles.latest_for(hero_id)

  def latest_duel_battle(duel_id), do: Battles.latest_for_duel(duel_id)

  def read_battle!(battle), do: Battles.read!(battle)

  def unread_battles_count(hero), do: Battles.unreads_for(hero)

  def read_all_battles, do: Battles.read_all()

  def read_all_battles_for(hero) do
    Battles.read_all_for_hero(hero)
    broadcast_unread(hero)
  end

  def broadcast_unread(hero), do: MobaWeb.broadcast("hero-#{hero.id}", "unread", %{hero_id: hero.id})

  def generate_attacker_snapshot!(tuple), do: Battles.generate_attacker_snapshot!(tuple)

  def generate_defender_snapshot!(tuple), do: Battles.generate_defender_snapshot!(tuple)

  def ordered_turns_query, do: Battles.ordered_turns_query()

  # CORE MECHANICS

  defdelegate create_pve_battle!(target), to: Core

  defdelegate create_pvp_battle!(attrs), to: Core

  def create_league_battle!(attacker) do
    Core.create_league_battle!(attacker, Game.league_defender_for(attacker))
  end

  defdelegate create_duel_battle!(attrs), to: Core

  defdelegate start_battle!(battle), to: Core

  defdelegate continue_battle!(battle, orders), to: Core

  defdelegate auto_finish_battle!(battle, orders \\ %{auto: true}), to: Core

  def next_battle_turn(battle), do: Core.build_turn(battle, %{})

  defdelegate last_turn(battle), to: Core

  def can_pvp?(attacker, defender), do: Core.can_pvp?(%{attacker: attacker, defender: defender})

  defdelegate effect_descriptions(turn), to: Core

  defdelegate can_use_resource?(turn, resource), to: Core
end
