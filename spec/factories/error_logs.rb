FactoryBot.define do
  factory :error_log do
    association :evaluation
    error_code { "E_PARSE" }
    error_detail { "Unable to parse numeric output from response." }
    llm_provider { "OpenAI" }
    model_version { "gpt-5" }
  end
end
