class ContactsController < ApplicationController
  def new
    @contact = ContactAdmin.new(params.fetch(:contact_admin) { Hash(nil) }.permit(:name, :email, :subject, :body))
  end

  def create
    @contact = ContactAdmin.new(params.fetch(:contact_admin) { Hash(nil) }.permit(:name, :email, :subject, :body))

    if @contact.valid?
      ContactMailer.contact_us(@contact).deliver_now
      redirect_to root_path, notice: "Thanks for contacting us! We'll get back to you soon."
    else
      flash.now[:error] = "Please fill in all fields."
      render :new
    end
  end
end
