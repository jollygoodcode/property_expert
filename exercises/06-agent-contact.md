# Exercise: Agent Contact

Add a button besides property to inform that someone is interested in particular property.

## User Stories

```
As a user, I want to see a info button 'Interest' on the left of each Property title.
```

```
As a user, I want to send mail to agent when click 'Interest' button.
```

```
As a user, I want to see a successful message after the mail has been sent successfully.
```

### Hints

```
resources :properties do
  post "interested", on: :member
end
```

search for "member route"
<sup>http://guides.rubyonrails.org/routing.html</sup>

**`app/controllers/property_controllers.rb`:**

```
  ...

  def interested
    ContactMailer.interested_in(params[:id]).deliver_now
    # redirect with successful message
  end
```

**`app/mailers/contact_mailer.rb`:**

```
class ContactMailer < ActionMailer::Base
  default from: 'hello@example.com'

  def interest_in(property_id)
    # Write your code to send mail to property's agent
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
      Hello <Agent Name>, someone is interested in your property: <Property name>.
    </p>
  </body>
</html>
```
