require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Reading Events' do
  header 'Content-Type', 'application/json'
  header 'Accept', 'application/json'

  get '/reading_events' do
    example 'Get latest week events in JSON format' do
      do_request

      json_response = JSON.parse(response_body)

      expect(json_response.class).to eq Array
      expect(json_response.size).to(
        eq(ReadingEvent.where('created_at >= ?', Time.now - 7.days).size)
      )
    end
  end
end
