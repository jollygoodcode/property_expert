class Property < ActiveRecord::Base
  ACCEPT_TYPES = ["Apartment", "Condominium", "Landed House", "HDB Apartment"]

  belongs_to :agent

  validates_presence_of :name
  validates_numericality_of :price
  validates_length_of :description, minimum: 140, too_short: 'please enter at least 140 characters', maximum: 1000
  validates_inclusion_of :property_type, in: ACCEPT_TYPES, message: "property type %{value} is not included in the: #{ACCEPT_TYPES.join(", ")}."

  has_attached_file :photo_1, styles: { medium: "300x300>", small: "100x100>" }
  validates_attachment_content_type :photo_1, content_type: /\Aimage\/.*\Z/

  has_attached_file :photo_2, styles: { medium: "300x300>", small: "100x100>" }
  validates_attachment_content_type :photo_1, content_type: /\Aimage\/.*\Z/

  has_attached_file :photo_3, styles: { medium: "300x300>", small: "100x100>" }
  validates_attachment_content_type :photo_1, content_type: /\Aimage\/.*\Z/
end
