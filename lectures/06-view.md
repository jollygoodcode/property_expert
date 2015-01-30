# Rails View

EXPLAIN: View Basic, Action View

```
mkdir app/views/properties/
touch app/views/properties/new.html.erb
```

Visit <http://localhost:3000/properties/new> again.

It works but it is an empty Page, but if you look closely...

EXPLAIN: Browser Web Inspector.

```html
<html>
  <head>...</head>
  <body>
  </body>
</html>
```

Where does it come from?

Open `app/views/layouts/application.html.erb`:

```html+erb
<!DOCTYPE html>
<html>
<head>
  <title>PropertyExpert</title>
  <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true %>
  <%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
  <%= csrf_meta_tags %>
</head>
<body>

<%= yield %>

</body>
</html>
```

EXPLAIN: ERB, Action View Helpers, `yield`.

## New Property

Edit `app/views/properties/new.html.erb`:

```html+erb
<h1>New Property</h1>

<%= form_for :article, url: properties_path do |f| %>
  <p>
    <%= f.label :name %><br>
    <%= f.text_field :name %>
  </p>

  <p>
    <%= f.label :price %><br>
    <%= f.number_field :price %>
  </p>

  <p>
    <%= f.label :description %><br>
    <%= f.text_area :description %>
  </p>

  <p>
    <%= f.label :property_type %><br>
    <%= f.select :property_type, Property::ACCEPT_TYPES %>
  </p>
  <p>
    <%= f.submit %>
  </p>
<% end %>
```

EXPLAIN: Form Helpers.

<sup>http://guides.rubyonrails.org/form_helpers.html</sup>

Our first basic form, now click submit.

```
The action 'create' could not be found for PropertiesController
```

## Create Property

| HTTP Verb | Path             | Controller#Action | Used for                                        |
| --------- | ---------------- | ----------------- | ----------------------------------------------- |
| POST      | /properties      | properties#create | create a new property                           |

Add a `create` action with following:

```ruby
class PropertiesController < ApplicationController
  def new
  end

  def create
    render plain: params[:article].inspect
  end
end
```

EXPLAIN: params

```ruby
class PropertiesController < ApplicationController
  def new
  end

  def create
    @property = Property.new(params[:property])
    @property.save
    redirect_to @property
  end
end
```

```
ActiveModel::ForbiddenAttributesError
```

EXPLAIN: Strong Parameters

<sup>https://github.com/rails/strong_parameters</sup>

```ruby
class PropertiesController < ApplicationController
  def new
  end

  def create
    @property = Property.new(params.require(:property).permit(:name, :price, :description, :property_type))
    @property.save
    redirect_to @property
  end
end
```

Fill in all fields with respect to validations.

```
The action 'show' could not be found for PropertiesController
```

We successfully created property, but...

## Show a Property

| HTTP Verb | Path             | Controller#Action | Used for                                        |
| --------- | ---------------- | ----------------- | ----------------------------------------------- |
| GET       | /properties/:id  | properties#show   | display a specific property                     |

```ruby
class PropertiesController < ApplicationController
  def new
  end

  def create
    @property = Property.new(params.require(:property).permit(:name, :price, :description, :property_type))
    @property.save
    redirect_to @property
  end

  def show
  end
end
```

Visit <http://localhost:3000/properties/1> again.

```
Missing template properties/show
```

```bash
$ touch app/views/properties/show.html.erb
```

```ruby
class PropertiesController < ApplicationController
  def new
  end

  def create
    @property = Property.new(params.require(:property).permit(:name, :price, :description, :property_type))
    @property.save
    redirect_to @property
  end

  def show
    @property = Property.find(params[:id])
  end
end
```

Edit `app/views/properties/show.html.erb`:

```html+erb
<p>
  <strong>Name:</strong>
  <%= @property.name %>
</p>

<p>
  <strong>Price:</strong>
  <%= @property.price %>
</p>

<p>
  <strong>Description:</strong>
  <%= @property.description %>
</p>

<p>
  <strong>Type:</strong>
  <%= @property.property_type %>
</p>
```
