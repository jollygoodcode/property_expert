# Rails View

EXPLAIN: View Basic, Action View

```
mkdir app/views/properties/
touch app/views/properties/new.html.erb
```

Visit <http://localhost:3000/properties/new> again.

It works but it is an empty Page, but if you look closely...

EXPLAIN: Browser Developer Tool.

<sup>https://developer.chrome.com/devtools</sup>

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

| HTTP Verb | Path             | Controller#Action | Used for                                        |
| --------- | ---------------- | ----------------- | ----------------------------------------------- |
| GET       | /properties/new  | properties#new    | return an HTML form for creating a new property |

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
    <%= f.label :agent_id %><br>
    <%= f.collection_select :agent_id, Agent.all, :id, :name %>
  </p>

  <p>
    <%= f.submit %>
  </p>
<% end %>
```

EXPLAIN: Form Helpers.

<sup>http://guides.rubyonrails.org/form_helpers.html</sup>

Our first basic form, now click 'Save Property'.

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

Back to new, click 'Save Property', Shall see:

```
{"name"=>"", "price"=>"", "description"=>"", "property_type"=>"Apartment"}
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

Back to new, click 'Save Property':

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
    @property = Property.new(params.require(:property).permit(:name, :price, :description, :property_type, :agent_id))
    @property.save
    redirect_to @property
  end
end
```

OK now all good to create a property.

But we don't have UI to create agent yet, let's create one manually:

```
$ rails console
> Agent.create(name: "Winston", company: "JollyGoodCode", mobile: "9999 8888")
=> #<Agent id: 1, name: "Winston", company: "JollyGoodCode", mobile: "9999 8888",　...>
> exit
```

So we can select an agent on our form.

Visit: <http://localhost:3000/properties/new>, fill in all fields with respect to [validations](/lectures/02-validation).

```
The action 'show' could not be found for PropertiesController
```

We successfully created a property, but...

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

## Listing Properties

| HTTP Verb | Path             | Controller#Action | Used for                                        |
| --------- | ---------------- | ----------------- | ----------------------------------------------- |
| GET       | /properties      | properties#index  | display a list of all properties                |

Visit <http://localhost:3000/properties>.

```
The action 'index' could not be found for PropertiesController
```

```ruby
class PropertiesController < ApplicationController
  def index
  end

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

```bash
$ touch app/views/properties/index.html.erb
```

```ruby
class PropertiesController < ApplicationController
  def index
    @properties = Property.all
  end

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

Edit `app/views/properties/index.html.erb`:

```html+erb
<h1>Listing properties</h1>

<table>
  <tr>
    <th>Title</th>
    <th>Price</th>
    <th>Description</th>
    <th>Type</th>
  </tr>

  <% @properties.each do |property| %>
    <tr>
      <td><%= property.name %></td>
      <td><%= property.price %></td>
      <td><%= property.description %></td>
      <td><%= property.property_type %></td>
    </tr>
  <% end %>
</table>
```

## Show Errors when failed to create

Edit `app/views/properties/new.html.erb`:

```
<%= form_for :property, url: properties_path do |f| %>
  <% if @property.errors.any? %>
    <div>
      <ul>
        <% @property.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <p>
    <%= f.label :name %><br>
    <%= f.text_field :name %>
  </p>

  ...

<% end %>
```

Edit `app/controllers/properties_controller`:

```ruby
class PropertiesController < ApplicationController
  ...

  def new
    @property = Property.new
  end

  ...
end
```

Visit <http://localhost:3000/properties/new>, click submit:

```
Name can't be blank
Price is not a number
Description please enter at least 140 characters
```

EXPLAIN: field_with_errors div

## Edit Property

| HTTP Verb | Path                 | Controller#Action | Used for                                        |
| --------- | -------------------- | ----------------- | ----------------------------------------------- |
| GET       | /properties/:id/edit | properties#edit   | return an HTML form for editing a property      |

Visit <http://localhost:3000/properties/1/edit>

```
The action 'edit' could not be found for PropertiesController
```

```ruby
class PropertiesController < ApplicationController
  ...

  def show
    @property = Property.find(params[:id])
  end

  def edit
    @property = Property.find(params[:id])
  end
end
```

```
$ touch app/views/properties/edit.html.erb
```

Edit `app/views/properties/edit.html.erb`

```html+erb
<h1>Edit Property</h1>

<%= form_for :property, url: property_path(@property), method: :patch do |f| %>
  <% if @property.errors.any? %>
    <div>
      <ul>
        <% @property.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

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
    <%= f.label :agent_id %><br>
    <%= f.collection_select :agent_id, Agent.all, :id, :name %>
  </p>

  <p>
    <%= f.submit %>
  </p>
<% end %>
```

EXPLAIN: `<%= form_for :property, url: property_path(@property), method: :patch do |f| %>`


Click 'Save Property'

```
The action 'update' could not be found for PropertiesController
```

## Update Property

| HTTP Verb | Path                 | Controller#Action | Used for                                        |
| --------- | -------------------- | ----------------- | ----------------------------------------------- |
| PATCH/PUT | /properties/:id      | properties#update | update a specific property                      |

```ruby
class PropertiesController < ApplicationController
  ...

  def edit
    @property = Property.find(params[:id])
  end

  def update
    @property = Property.find(params[:id])

    if @property.update(params.require(:property).permit(:name, :price, :description, :property_type))
      redirect_to @property
    else
      render :edit
    end
  end
end
```

## Linking altogether

Add Show, Edit links.

Edit `app/views/properties/index.html.erb`:

```html+erb
<h1>Listing properties</h1>

<table>
  <tr>
    ...
    <th colspan="2">Actions</th>
  </tr>

  <% @properties.each do |property| %>
    <tr>
      ...
      <td><%= property.property_type %></td>
      <td><%= link_to 'Show', property_path(property) %></td>
      <td><%= link_to 'Edit', edit_property_path(property) %></td>
    </tr>
  <% end %>
</table>
```

Run out of space, let's “truncate” description on properties:

```html+erb
<h1>Listing properties</h1>

<table>
  ...

  <% @properties.each do |property| %>
    <tr>
      ...
      <td><%= truncate property.description %></td>
      <td><%= property.property_type %></td>
      <td><%= link_to 'Show', property_path(property) %></td>
      <td><%= link_to 'Edit', edit_property_path(property) %></td>
    </tr>
  <% end %>
</table>
```

Add 'Back' links:

```html+erb
<p><%= link_to 'Back', properties_path %></p>
```

to bottom of `app/views/properties/new.html.erb`, `app/views/properties/show.html.erb`, and `app/views/properties/edit.html.erb`:

**`app/views/properties/new.html.erb`:**

```
<h1>New Property</h1>

<%= form_for :property, url: properties_path do |f| %>
  ...
<% end %>

<p><%= link_to 'Back', properties_path %></p>
```

**app/views/properties/show.html.erb**

```html+erb
<p>
  <strong>Name:</strong>
  <%= @property.name %>
</p>

...

<p>
  <strong>Type:</strong>
  <%= @property.property_type %>
</p>

<p><%= link_to 'Back', properties_path %></p>
```

**`app/views/properties/edit.html.erb`:**

```html+erb
<h1>Edit Property</h1>

<%= form_for :property, url: property_path(@property), method: :patch do |f| %>
  ...
<% end %>

<p><%= link_to 'Back', properties_path %></p>
```

## Delete a Property

| HTTP Verb | Path             | Controller#Action  | Used for                                     |
| --------- | ---------------- | -----------------  | -------------------------------------------- |
| DELETE    | /properties/:id  | properties#destroy | delete a specific property                   |

Edit `app/views/properties/index.html.erb`:

```html+erb
<h1>Listing properties</h1>

<table>
  <tr>
    ...
    <th colspan="3">Actions</th>
  </tr>

  <% @properties.each do |property| %>
    <tr>
      ...
      <td><%= link_to "Show", property_path(property) %></td>
      <td><%= link_to "Edit", edit_property_path(property) %></td>
      <td><%= link_to "Destroy", property_path(property), method: :delete, data: { confirm: "Are you sure?" } %></td>
    </tr>
  <% end %>
</table>
```

EXPLAIN: Why DELETE instead of GET or POST, jquery-ujs.

<sup>https://github.com/rails/jquery-ujs/blob/master/src/rails.js</sup>

```
The action 'destroy' could not be found for PropertiesController
```

Edit `app/controllers/properties_controller.rb`:

```ruby
class PropertiesController < ApplicationController
  ...

  def destroy
    @property = Property.find(params[:id])
    @property.destroy

    redirect_to properties_path
  end
end
```

Congrats! You just learned CRUD!
