# [Bootstrap](http://getbootstrap.com)

EXPLAIN: Twitter Bootstrap Basics

## Install Bootstrap

```ruby
  ...
  # Use postgresql as the database for Active Record
  gem 'pg'
  # Use Twitter Bootstrap for HTML/CSS/JS foundation.
  gem 'bootstrap-sass'
  # Use SCSS for stylesheets
  gem 'sass-rails', '~> 5.0'
  # Use Uglifier as compressor for JavaScript assets
  ...
```

EXPLAIN: Gemfile

```
$ mv app/assets/stylesheets/application.css app/assets/stylesheets/application.scss
```

EXPLAIN: SCSS Basics

**`app/assets/stylesheets/application.scss`:**

```scss
// "bootstrap-sprockets" must be imported before "bootstrap" and "bootstrap/variables"
@import "bootstrap-sprockets";
@import "bootstrap";
```

EXPLAIN: Stylesheet Manifest file.

**`app/assets/javascripts/application.js`:**

```js
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .
```

EXPLAIN: JavaScript Manifest file.

**`app/views/layouts/application.html.erb`:**

```html+erb
<div class="container">
  <div class="row">
    <%= yield %>
  </div>
</div>
```

**`app/views/properties/index.html.erb`:**

```html+erb
<div class="page-header">
  <h1>Listing properties</h1>
</div>

<table class="table">
  <tr>
    <th>Title</th>
    <th>Text</th>
    <th>description</th>
    <th>Type</th>
    <th colspan="3">Actions</th>
  </tr>

  <% @properties.each do |property| %>
    <tr>
      <td><%= property.name %></td>
      <td><%= property.price %></td>
      <td><%= property.description %></td>
      <td><%= property.property_type %></td>
      <td><%= link_to "Show", property_path(property), class: 'btn btn-primary' %></td>
      <td><%= link_to "Edit", edit_property_path(property), class: 'btn btn-success' %></td>
      <td><%= link_to "Destroy", property_path(property), method: :delete, class: 'btn btn-danger', data: { confirm: "Are you sure?" } %></td>
    </tr>
  <% end %>
</table>
```

**`app/views/properties/new.html.erb`:**

```html+erb
<div class="page-header">
  <h1>New Property</h1>
</div>

<%= form_for :property, url: properties_path, html: { class: "form-horizontal" } do |f| %>
  <% if @property.errors.any? %>
    <div>
      <ul>
        <% @property.errors.full_messages.each do |msg| %>
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
    <%= f.label :price, class: "col-sm-2 control-label" %>
    <div class="col-sm-10">
      <%= f.number_field :price, class: "form-control" %>
    </div>
  </div>

  <div class="form-group">
    <%= f.label :description, class: "col-sm-2 control-label" %>
    <div class="col-sm-10">
      <%= f.text_area :description, class: "form-control", rows: 5 %>
      <span id="helpBlock" class="help-block">At least 140 characters.</span>
    </div>
  </div>

  <div class="form-group">
    <%= f.label :property_type, class: "col-sm-2 control-label" %>
    <div class="col-sm-10">
      <%= f.select :property_type, Property::ACCEPT_TYPES, {}, { class: "form-control" } %>
    </div>
  </div>

  <div class="form-group">
    <div class="col-sm-10 col-sm-offset-2">
      <%= f.submit class: "btn btn-default" %>
      or
      <%= link_to 'Back', properties_path %>
    </div>
  </div>
<% end %>
```

**`app/views/properties/show.html.erb`:**

Same.

**`app/views/properties/edit.html.erb`:**

```html+erb
<div class="page-header">
  <h1>Edit Property</h1>
</div>

<%= form_for :property, url: property_path(@property), method: :patch, html: { class: "form-horizontal" } do |f| %>
  <% if @property.errors.any? %>
    <div>
      <ul>
        <% @property.errors.full_messages.each do |msg| %>
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
    <%= f.label :price, class: "col-sm-2 control-label" %>
    <div class="col-sm-10">
      <%= f.number_field :price, class: "form-control" %>
    </div>
  </div>

  <div class="form-group">
    <%= f.label :description, class: "col-sm-2 control-label" %>
    <div class="col-sm-10">
      <%= f.text_area :description, class: "form-control", rows: 5 %>
      <span id="helpBlock" class="help-block">At least 140 characters.</span>
    </div>
  </div>

  <div class="form-group">
    <%= f.label :property_type, class: "col-sm-2 control-label" %>
    <div class="col-sm-10">
      <%= f.select :property_type, Property::ACCEPT_TYPES, {}, { class: "form-control" } %>
    </div>
  </div>

  <div class="form-group">
    <div class="col-sm-10 col-sm-offset-2">
      <%= f.submit class: "btn btn-default" %>
      or
      <%= link_to 'Back', properties_path %>
    </div>
  </div>
<% end %>
```
