# frozen_string_literal: true

class SymbolKeysSerializer
  def self.dump(object)
    object.to_json
  end

  def self.load(string_json)
    hash = JSON.parse(string_json) if string_json.instance_of?(String)
    ActiveSupport::HashWithIndifferentAccess.new(hash)
  end
end
