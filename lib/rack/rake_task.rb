# frozen_string_literal: true

require 'shellwords'
require 'securerandom'
require 'json'

module Rack
  class RakeTask
    def initialize(app)
      @app = app
    end

    def call(env)
      if env['REQUEST_PATH'] == '/rake_task'
        task = Rack::Utils.parse_nested_query(env['QUERY_STRING'])['task']
        response = execute_task(task)
        http_code = response['exit_code'].zero? ? 200 : 400

        return [http_code, { 'Content-Type' => 'application/json' }, [response.to_json]]
      end

      @app.call(env)
    end

    private

    def execute_task(task)
      log_prefix = SecureRandom.hex
      output_log = "/tmp/rake_middleware_#{log_prefix}_out"
      error_log = "/tmp/rake_middleware_#{log_prefix}_err"

      pid = Process.spawn(
        "bundle exec ./bin/rake #{::Shellwords.escape(task)}",
        unsetenv_others: true,
        out: [output_log, 'w'],
        err: [error_log, 'w']
      )
      _pid, status = Process.wait2(pid)

      output = ::File.read(output_log)
      error = ::File.read(error_log)

      {
        'output' => output,
        'error' => error,
        'exit_code' => status.exitstatus
      }
    end
  end
end
