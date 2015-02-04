# Mailer and Contact Website Admin

EXPLAIN: Action Mailer Basics

## Create a Simple Mailer

```
$ touch app/mailers/contact_mailer.rb
$ rm app/mailers/.keep
```

EXPLAIN: `.keep`.

Edit `app/mailers/contact_mailer.rb`:

```ruby
class ContactMailer < ActionMailer::Base
  default from: 'hello@example.com'

  def welcome_agent(agent)
    @agent = agent
    mail(to: @agent.email, subject: 'Welcome to Property Expert')
  end
end
```

```
$ mkdir app/views/contact_mailer/
$ touch app/views/contact_mailer/welcome_agent.html.erb
```

## Sending mail from console

```
$ rails console

> agent = Agent.create(name: "Paul Graham", email: "pg@example.com", company: "Y Combinator", mobile: "9876 5432")

> ContactMailer.welcome_agent(agent).deliver_now
  Rendered contact_mailer/welcome_agent.html.erb (0.0ms)

ContactMailer#welcome_agent: processed outbound mail in 10.4ms

Sent mail to pg@example.com (4.7ms)
Date: Wed, 04 Feb 2015 22:49:19 +0800
From: hello@example.com
To: pg@example.com
Message-ID: <54d2316f452d8_65a43fe0d4c601fc8653d@shinshous-MacBook-Pro.local.mail>
Subject: Welcome to Property Expert
Mime-Version: 1.0
Content-Type: text/html;
 charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html>
<html>
  <head>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type' />
  </head>
  <body>
    <h1>Welcome to Property Expert, Paul Graham</h1>
  </body>
</html>

=> #<Mail::Message:70234957190780, Multipart: false, Headers: <Date: Wed, 04 Feb 2015 22:49:19 +0800>, <From: hello@example.com>, <To: pg@example.com>, <Message-ID: <54d2316f452d8_65a43fe0d4c601fc8653d@shinshous-MacBook-Pro.local.mail>>, <Subject: Welcome to Property Expert>, <Mime-Version: 1.0>, <Content-Type: text/html>, <Content-Transfer-Encoding: 7bit>>
```

## Contact Admin: Model

```
$ touch app/models/contact_admin.rb
```

```ruby
class ContactAdmin
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :name, :email, :subject, :body

  validates_presence_of :name, :email, :subject, :body
end
```

## Contact Admin: View and Controller

Let's add a contact Route and root route:

```ruby
Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root "properties#index"

  resources :properties
  resources :agents

  get "/contact_us" => "contacts#new"
  post "/contact_us" => "contacts#create"
end
```

EXPLAIN: Root Route.

Link:

**`app/views/layouts/application.html.erb`:**

```html+erb
...
<div class="container">
  <nav>
    <%= link_to "Contact Us", contact_us_path %>
  </nav>

  <div class="row">
    <%= flash_messages %>

    <%= yield %>
  </div>
</div>
...
```

Click link:

```
uninitialized constant ContactsController
```

```
$ touch app/controllers/contacts_controller.rb
```

Refresh:

```
The action 'new' could not be found for ContactsController
```

**`app/controllers/contacts_controller.rb`:**

```ruby
class ContactsController < ApplicationController
  def new
  end
end
```

```
Missing template contacts/new
```

View:

```
$ mkdir app/views/contacts
$ touch app/views/contacts/new.html.erb
```

**`app/views/contacts/new.html.erb`:**

```html+erb
<div class="page-header">
  <h1>Contact Us</h1>
</div>

<%= form_for @contact, url: contact_us_path, html: { class: "form-horizontal" } do |f| %>
  <% if @contact.errors.any? %>
    <div>
      <ul>
        <% @contact.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div class="form-group">
    <%= f.label :name, class: "col-sm-2 control-label" %>
    <div class="col-sm-10">
      <%= f.text_field :name, class: "form-control" %>
    </div>
  </div>

  <div class="form-group">
    <%= f.label :email, class: "col-sm-2 control-label" %>
    <div class="col-sm-10">
      <%= f.text_field :email, class: "form-control" %>
    </div>
  </div>

  <div class="form-group">
    <%= f.label :subject, class: "col-sm-2 control-label" %>
    <div class="col-sm-10">
      <%= f.text_field :subject, class: "form-control" %>
    </div>
  </div>

  <div class="form-group">
    <%= f.label :body, class: "col-sm-2 control-label" %>
    <div class="col-sm-10">
      <%= f.text_area :body, class: "form-control", rows: "10" %>
    </div>
  </div>

  <div class="form-group">
    <div class="col-sm-10 col-sm-offset-2">
      <%= f.submit "Send", class: "btn btn-default" %>
      or
      <%= link_to "Back", root_path %>
    </div>
  </div>
<% end %>
```

```
First argument in form cannot contain nil or be empty
```

**`app/controllers/contacts_controller.rb`:**

```ruby
class ContactsController < ApplicationController
  def new
    @contact = ContactAdmin.new(params.fetch(:contact_admin) { Hash(nil) }.permit(:name, :email, :subject, :body))
  end
end
```

```
The action 'create' could not be found for ContactsController
```

**`app/controllers/contacts_controller.rb`:**

```ruby
class ContactsController < ApplicationController
  ...

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
```

Fill all in, click 'Send'.

```
undefined method `contact_us' for ContactMailer:Class
```

```ruby
class ContactMailer < ActionMailer::Base
  default from: 'hello@example.com'

  ...

  def contact_us(contact)
    @contact = contact

    mail(
      to: "admin@example.com",
      reply_to: @contact.email,
      subject: @contact.subject
    )
  end
end
```

```
$ touch app/views/contact_mailer/contact_us.html.erb
```

```html+erb
<!DOCTYPE html>
<html>
  <head>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type' />
  </head>
  <body>
    <p>From <%= @contact.name %> <%= @contact.email %></p>
    <p>Subject: <%= @contact.subject %></p>
    <pre><%= @contact.body %></pre>
  </body>
</html>
```

Fill all in and click 'Send'!

Congrats! You learned Action Mailer and Active Model, Success!
