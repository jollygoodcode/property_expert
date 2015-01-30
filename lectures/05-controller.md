# Rails Controller and Actions

EXPLAIN: Controller Basics

## `ApplicationController`

```ruby
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
```

EXPLAIN: `ApplicationController`, CSRF.

<sup>http://guides.rubyonrails.org/action_controller_overview.html#request-forgery-protection</sup>

## Add Properties Controller

```
$ touch app/controllers/properties_controller.rb
```

Add:

```ruby
class PropertiesController < ApplicationController
end
```

EXPLAIN: Ruby Methods and Rails Controller Actions

## Create a New Property

| HTTP Verb | Path             | Controller#Action | Used for                                        |
| --------- | ---------------- | ----------------- | ----------------------------------------------- |
| GET       | /properties/new  | properties#new    | return an HTML form for creating a new property |

Visit: <http://localhost:3000/properties/new>.

```
The action 'new' could not be found for PropertiesController
```

Edit: `app/controllers/properties_controller.rb`

```ruby
class PropertiesController < ApplicationController
  def new
  end
end
```

Visit: <http://localhost:3000/properties/new>.

```
Missing template properties/new...
```

We need to add Views!
