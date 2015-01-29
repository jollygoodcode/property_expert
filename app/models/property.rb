class Property < ActiveRecord::Base
  ACCEPT_TYPES = ["Apartment", "Condominium", "Landed House", "HDB Apartment"]

  validates_presence_of :name
  validates_numericality_of :price
  validates_length_of :description, minimum: 140, too_short: 'please enter at least 140 characters', maximum: 1000
  validates_inclusion_of :property_type, in: ACCEPT_TYPES, message: "property type %{value} is not included in the: #{ACCEPT_TYPES.join(", ")}."
end
