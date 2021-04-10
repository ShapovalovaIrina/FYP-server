defmodule FypWeb.ControllerUtils do
  @moduledoc "Just simple response texts"

  @bad_status %{"status" => "Bad request"}
  @successful_status %{"status" => "Successfully"}
  @not_found_status %{"status" => "Not found"}
  @no_related_entities %{"status" => "No related entities"}

  def bad_status() do
    @bad_status
  end

  def successful_status() do
    @successful_status
  end

  def not_found_status() do
    @not_found_status
  end

  def no_related_entities() do
    @no_related_entities
  end
end
