class ContactInfo < ActiveRecord::Base
  geocoded_by :get_user_current_address

  validates :adresse, presence: true
  validates :npa_localite, presence: true
  validates :tel_home, presence: true
  validates :pays, :code => true
  # phony_normalize :tel_home, :default_country_code => 'FR'
  # validates :tel_home, :phony_plausible => true
  # phony_normalize :tel_natel, :default_country_code => 'FR'
  # validates :tel_home, :phony_plausible => true

  after_validation :geocode
  after_update :geocode

  def get_user_current_address
    "#{self.current_postcode} #{self.current_town} #{self.current_country}"
  end

  def current_city_and_cp
    "#{self.current_postcode} #{self.current_town}"
  end

  def self.translate_pays_to_french
    pays_array = Array.new()
    Country.all.collect do |p|
      c = ISO3166::Country.find_country_by_name(p[0])
      pays_array << { code: p[1], name: c.translations['fr'] }
    end
    pays_array[7][:name] = 'Antilles néerlandaises'
    pays_array
  end

  def self.translate_countries_to_french
    pays_array = Array.new()
    Country.all.collect do |p|
      c = ISO3166::Country.find_country_by_name(p[0])
      pays_array << { name: p[0], french_name: c.translations['fr'] }
    end
    pays_array[7][:french_name] = 'Antilles néerlandaises'
    pays_array
  end
end
