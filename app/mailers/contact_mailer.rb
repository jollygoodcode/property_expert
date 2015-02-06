class ContactMailer < ActionMailer::Base
  default from: 'hello@example.com'

  # def welcome_agent(agent)
  #   @agent = agent
  #   mail(to: @agent.email, subject: 'Welcome to Property Expert')
  # end

  def contact_us(contact)
    @contact = contact

    mail(
      to: "admin@example.com",
      from: @contact.email,
      subject: @contact.subject
    )
  end

  # def interested_in(property_id)
  #   @property = Property.find(property_id)
  #   @agent = @property.agent

  #   mail(
  #     to: @agent.email,
  #     subject: "Someone interested in your property!"
  #   )
  # end
end
