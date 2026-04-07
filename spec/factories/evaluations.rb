FactoryBot.define do
  factory :evaluation do
    association :experiment
    benchmark_value { 42.0 }
    llm_value { 41.5 }
    absolute_error { 0.5 }
    passed { true }
    error_class { nil }
    notes { "Within acceptable tolerance" }
  end
end
