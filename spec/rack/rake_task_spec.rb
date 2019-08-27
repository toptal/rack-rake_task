# frozen_string_literal: true

require_relative '../../lib/rack/rake_task'
require_relative '../../lib/rack/rake_task_client'
require_relative '../support/bookstore_client'

RSpec.describe Rack::RakeTask do
  let(:rake_client) { Rack::RakeTaskClient.new('http://localhost:3000') }

  describe 'reset the db' do
    let(:app_client) { BookstoreClient.new('http://localhost:3000') }

    before { rake_client.task('db:reset') }

    specify do
      expect(app_client.data.count).to eq(2)
      app_client.delete_book(1)
      expect(app_client.data.count).to eq(1)
      rake_client.task('db:reset')
      expect(app_client.data.count).to eq(2)
    end
  end

  describe 'parameterized task' do
    specify do
      response = rake_client.task('time:zones[PL]')
      expect(response['output']).to include('Warsaw')
      expect(response['exit_code']).to be_zero
    end
  end

  describe 'non-existing task' do
    specify do
      response = rake_client.task('no:such:task')
      expect(response['output']).to be_empty
      expect(response['error']).to include("Don't know how to build task")
      expect(response['exit_code']).not_to be_zero
    end
  end

  describe 'empty task' do
    specify do
      response = rake_client.task('')
      expect(response['output']).to be_empty
      expect(response['error']).to include("Don't know how to build task")
      expect(response['exit_code']).not_to be_zero
    end
  end
end
