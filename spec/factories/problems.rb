FactoryBot.define do
  factory :problem do
    name { "Max-Cut" }
    domain { "optimization" }
    tier { 1 }
    problem_statement { "Find a partition of graph vertices maximizing edge cuts." }
    input_parameters { "Adjacency matrix" }
    expected_output_description { "Partition and objective value" }
    source_reference { "https://example.com/max-cut" }
  end
end
