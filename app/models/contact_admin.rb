class ContactAdmin
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :name, :email, :subject, :body

  validates_presence_of :name, :email, :subject, :body
end
