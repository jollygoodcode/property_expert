class Agent < ActiveRecord::Base
  has_many :properties

  validates_presence_of :name
  validates_presence_of :company
  validates_presence_of :mobile

  validates_format_of :mobile, with: /[7-8][1-9][1-9]{2}[\s]+[1-9]{4}|[9][0-8][1-9]{2}\s[1-9]{4}/

  has_attached_file :photo, styles: { medium: "300x300>", small: "100x100>" }
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
end
