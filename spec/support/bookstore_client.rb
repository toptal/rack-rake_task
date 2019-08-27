# frozen_string_literal: true

require 'faraday'

class BookstoreClient
  def initialize(url)
    @url = url
  end

  def data
    JSON.parse(Faraday.get("#{@url}/books").body)
  end

  def delete_book(id)
    Faraday.delete("#{@url}/books/#{id}")
  end
end
