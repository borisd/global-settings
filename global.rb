require 'singleton'

class Settings
  include Singleton

  attr_reader :data

  def initialize
    @data = structify(YAML::load(ERB.new(File.read("#{::Rails.root.to_s}/config/settings.yml")).result)[::Rails.env])
  end

  def structify(hash)
    OpenStruct.new(
      hash.reduce({}) do |r, i|
        r[i[0]] = i[1].is_a?(Hash) ? structify(i[1]) : i[1]
        r
      end
    )
  end
end

# TODO: implement ENV support

GLOBAL ||= Settings.instance.data