# Answer: Agent Contact

## User Stories

```
As a user, I want to see a info button 'Interest' on the left of each Property title.
```

```
resources :properties do
  post "interested", on: :member
end
```

```html+erb
<td><%= link_to "Interest", interested_property_path(property), class: 'btn btn-info', method: :post %></td>
```

```
As a user, I want to send mail to agent when click 'Interest' button.
```

```ruby
class PropertiesController < ApplicationController

  ...

  def interested
    ContactMailer.interested_in(params[:id]).deliver_now
  end
end
```

**`app/mailers/contact_mailer.rb`:**

```
class ContactMailer < ActionMailer::Base
  default from: 'hello@example.com'

  def interested_in(property_id)
    @property = Property.find(property_id)
    @agent = @property.agent

    mail(
      to: @agent.email,
      subject: "Someone interested in your property!"
    )
  end
end
```

**`app/views/contact_mailer/interested_in.html.erb`:**

```
<!DOCTYPE html>
<html>
  <head>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type' />
  </head>
  <body>
    <p>
      Hello <%= @agent.name %>, someone is interested in your property: <%= @property.name %>.
    </p>
  </body>
</html>
```

```
As a user, I want to see a successful message after the mail has been sent successfully.
```

```ruby
class PropertiesController < ApplicationController

  ...

  def interested
    ContactMailer.interested_in(params[:id]).deliver_now
    redirect_to root_path, notice: "Thanks for your feedback!"
  end
end
```
