# frozen_string_literal: true

class SocialNetwork < EnumerateIt::Base
  associate_values :google, :github, :twitter
end
