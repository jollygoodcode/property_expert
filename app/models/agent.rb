class Agent < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :company
  validates_presence_of :mobile

  validates_format_of :mobile, with: /[7-8][1-9][1-9]{2}[\s]+[1-9]{4}|[9][0-8][1-9]{2}\s[1-9]{4}/
end
