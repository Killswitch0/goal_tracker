module Searchable
  extend ActiveSupport::Concern

  class_methods do
    def search(search, user, table)
      return unless search

      where("lower(name) LIKE ? AND #{table}.user_id = ?", "%#{search.downcase}%", user.id)
    end
  end
end