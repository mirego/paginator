defmodule Paginator.Ecto.Query.AscNullsLast do
  @behaviour Paginator.Ecto.Query.DynamicFilterBuilder

  import Ecto.Query
  import Paginator.Ecto.Query.Helpers

  @impl Paginator.Ecto.Query.DynamicFilterBuilder
  def build_dynamic_filter(%{direction: :after, value: nil, next_filters: true}) do
    raise("unstable sort order: nullable columns can't be used as the last term")
  end

  def build_dynamic_filter(args = %{direction: :after, value: nil}) do
    dynamic(
      [{query, args.entity_position}],
      is_nil(^field_or_expr(args)) and ^args.next_filters
    )
  end

  def build_dynamic_filter(args = %{direction: :after, next_filters: true}) do
    dynamic(
      [{query, args.entity_position}],
      ^field_or_expr(args) > ^args.value or is_nil(^field_or_expr(args))
    )
  end

  def build_dynamic_filter(args = %{direction: :after}) do
    dynamic(
      [{query, args.entity_position}],
      (^field_or_expr(args) == ^args.value and ^args.next_filters) or
        ^field_or_expr(args) > ^args.value or
        is_nil(^field_or_expr(args))
    )
  end

  def build_dynamic_filter(%{direction: :before, value: nil, next_filters: true}) do
    raise("unstable sort order: nullable columns can't be used as the last term")
  end

  def build_dynamic_filter(args = %{direction: :before, value: nil}) do
    dynamic(
      [{query, args.entity_position}],
      (is_nil(^field_or_expr(args)) and ^args.next_filters) or
        not is_nil(^field_or_expr(args))
    )
  end

  def build_dynamic_filter(args = %{direction: :before, next_filters: true}) do
    dynamic([{query, args.entity_position}], ^field_or_expr(args) < ^args.value)
  end

  def build_dynamic_filter(args = %{direction: :before}) do
    dynamic(
      [{query, args.entity_position}],
      (^field_or_expr(args) == ^args.value and ^args.next_filters) or
        ^field_or_expr(args) < ^args.value
    )
  end
end
