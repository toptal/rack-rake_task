# frozen_string_literal: true

require 'shellwords'

# TODO: refactor this class
module Rack
  class RakeTask
    def initialize(app)
      @app = app
    end

    def call(env)
      if env['REQUEST_PATH'] == '/rake_task'
        params = Rack::Utils.parse_nested_query(env['QUERY_STRING'])
        pid = Process.spawn(
          "bundle exec ./bin/rake #{::Shellwords.escape(params['task'])}",
          unsetenv_others: true,
          %i[out err] => ['/tmp/rake_middleware', 'w']
        )
        _pid, status = Process.wait2(pid)
        http_code = status.exitstatus.zero? ? 200 : 500

        response_string = ::File.read('/tmp/rake_middleware')

        return [http_code, {}, [response_string]]
      end

      @app.call(env)
    end
  end
end
