# frozen_string_literal: true

require "json"
require "net/http"
require "uri"

module Llm
  class PerturbationEnergyKs
    API_ENDPOINT = URI("https://api.anthropic.com/v1/messages")

    def run(problem, provider: "claude", model_version: "claude-sonnet-4-20250514", prompt_strategy: "zero_shot")
      start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      response_text = request_completion(build_prompt(problem), model_version)
      elapsed_ms = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time) * 1000).round

      parsed_values = parse_perturbation_values(response_text)

      Experiment.create!(
        problem: problem,
        llm_provider: provider,
        model_version: model_version,
        prompt_strategy: prompt_strategy,
        raw_response: response_text,
        parsed_answer: parsed_values.to_json,
        elapsed_ms: elapsed_ms
      )
    end

    private

    def build_prompt(problem)
      <<~PROMPT
        You are solving a first order perturbation theory task.

        Problem:
        #{problem.problem_statement}

        Use:
        E1 = <psi_n|H'|psi_n>
        H' = epsilon * x
        E1 = (epsilon * L) / 2 for a 1D box.

        Constants:
        L = 1.0 m
        epsilon = 0.1 J/m
        n = 1

        Return strictly valid JSON with this shape:
        {
          "perturbation_values": [e1],
          "absolute_error": number
        }

        Do not include markdown fences or explanatory text.
      PROMPT
    end

    def request_completion(prompt, model_version)
      api_key = ENV.fetch("ANTHROPIC_API_KEY")

      http = Net::HTTP.new(API_ENDPOINT.host, API_ENDPOINT.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(API_ENDPOINT)
      request["content-type"] = "application/json"
      request["x-api-key"] = api_key
      request["anthropic-version"] = "2023-06-01"
      request.body = {
        model: model_version,
        max_tokens: 1024,
        messages: [
          {
            role: "user",
            content: prompt
          }
        ]
      }.to_json

      response = http.request(request)
      raise "Anthropic API error #{response.code}: #{response.body}" unless response.is_a?(Net::HTTPSuccess)

      payload = JSON.parse(response.body)
      blocks = payload.fetch("content", [])
      blocks.select { |b| b["type"] == "text" }.map { |b| b["text"] }.join("\n")
    end

    def parse_perturbation_values(response_text)
      json_blob = response_text[/\{.*\}/m]

      if json_blob
        parsed = JSON.parse(json_blob)
        values = Array(parsed["perturbation_values"]).map(&:to_f)
        return values.first(1) if values.size >= 1
      end

      numeric_values = response_text.scan(/[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?/).map(&:to_f)
      numeric_values.first(1)
    rescue JSON::ParserError
      numeric_values = response_text.scan(/[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?/).map(&:to_f)
      numeric_values.first(1)
    end
  end
end
