# frozen_string_literal: true

class UserQuery
  def self.all_except(user)
    User.where.not(id: user.id)
  end
end
