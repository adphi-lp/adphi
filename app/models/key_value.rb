class KeyValue < ActiveRecord::Base
  serialize :value

  def self.get(key, default = nil)
    KeyValue.find_by(key: key).try(:value) || default
  end

  def self.set(key, value)
    entry = KeyValue.find_or_create_by(key: key)
    entry.value = value
    entry.save!
  end
end
