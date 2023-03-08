defp customers_with_tsvector_rank(q) do
  from(f in Customer,
    select_merge: %{
      rank_value:
        fragment(
          "ts_rank(setweight(to_tsvector('simple', name), 'A'), plainto_tsquery('simple', ?)) AS rank_value",
          ^q
        )
    },
    where:
      fragment(
        "setweight(to_tsvector('simple', name), 'A') @@ plainto_tsquery('simple', ?)",
        ^q
      ),
    order_by: [
      desc: fragment("rank_value"),
      desc: f.id
    ]
  )
end
