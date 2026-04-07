FactoryBot.define do
  factory :experiment do
    association :problem
    llm_provider { "OpenAI" }
    model_version { "gpt-5" }
    prompt_strategy { "few-shot" }
    raw_response { "Candidate answer text" }
    parsed_answer { "Structured candidate answer" }
    elapsed_ms { 1250 }
  end
end
