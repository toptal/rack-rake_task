# frozen_string_literal: true

require_relative '../../lib/rack/rake_task'
require_relative '../support/bookstore_client'

RSpec.describe Rack::RakeTask do
  let(:client) { BookstoreClient.new('http://localhost:3000') }

  describe 'reset the db' do
    before { client.rake_db_reset }

    specify do
      expect(client.data.count).to eq(2)
      client.delete_book(1)
      expect(client.data.count).to eq(1)
      client.rake_db_reset
      expect(client.data.count).to eq(2)
    end
  end
end
