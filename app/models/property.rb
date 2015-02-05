class Property < ActiveRecord::Base
  ACCEPT_TYPES = ["Apartment", "Condominium", "Landed House", "HDB Apartment"]

  belongs_to :agent

  validates_presence_of :name
  validates_numericality_of :price
  validates_length_of :description, minimum: 140, too_short: 'please enter at least 140 characters', maximum: 1000
  validates_inclusion_of :property_type, in: ACCEPT_TYPES, message: "property type %{value} is not included in the: #{ACCEPT_TYPES.join(", ")}."

  has_many :photos, as: :owner, dependent: :destroy
  accepts_nested_attributes_for :photos, reject_if: :all_blank, allow_destroy: true
end
