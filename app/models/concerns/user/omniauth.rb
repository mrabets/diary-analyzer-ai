# frozen_string_literal: true

module User::Omniauth
  extend ActiveSupport::Concern

  class_methods do
    def from_omniauth(auth)
      OmniauthUser.find_or_create(auth)
    end
  end
end
