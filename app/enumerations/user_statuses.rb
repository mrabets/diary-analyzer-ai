# frozen_string_literal: true

class UserStatuses < EnumerateIt::Base
  associate_values(offline: 1, online: 2)
end
