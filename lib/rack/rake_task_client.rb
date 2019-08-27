# frozen_string_literal: true

require 'faraday'

module Rack
  class RakeTaskClient
    def initialize(url)
      @url = url
    end

    def task(task)
      JSON.parse(Faraday.get("#{@url}/rake_task?task=#{task}").body)
    end
  end
end
