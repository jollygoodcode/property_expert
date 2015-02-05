# File Upload

## Upload 3 Photos for Property

```ruby
gem 'paperclip'
```

```
$ bundle
```

```
$ rails generate migration rearrange_photos_column_on_properties
      invoke  active_record
      create    db/migrate/20150205073906_rearrange_photos_column_on_properties.rb
```

Edit `db/migrate/20150205073906_rearrange_photos_column_on_properties.rb`:

```ruby
class RearrangePhotosColumnOnProperties < ActiveRecord::Migration
  def up
    remove_column :properties, :photo_1
    remove_column :properties, :photo_2
    remove_column :properties, :photo_3

    add_attachment :properties, :photo_1
    add_attachment :properties, :photo_2
    add_attachment :properties, :photo_3
  end

  def down
    remove_attachment :properties, :photo_1
    remove_attachment :properties, :photo_2
    remove_attachment :properties, :photo_3

    add_column :properties, :photo_1, :string
    add_column :properties, :photo_2, :string
    add_column :properties, :photo_3, :string
  end
end
```

```
$ bin/rake db:migrate
== 20150205073906 RearrangePhotosColumnOnProperties: migrating ================
-- remove_column(:properties, :photo_1)
   -> 0.0024s
-- remove_column(:properties, :photo_2)
   -> 0.0003s
-- remove_column(:properties, :photo_3)
   -> 0.0002s
-- add_attachment(:properties, :photo_1)
   -> 0.0015s
-- add_attachment(:properties, :photo_2)
   -> 0.0010s
-- add_attachment(:properties, :photo_3)
   -> 0.0010s
== 20150205073906 RearrangePhotosColumnOnProperties: migrated (0.0066s) =======
```

**`app/controllers/properties_controller`:**

Replace

```ruby
params.require(:property).permit(:name, :price, :description, :property_type, :agent_id)
```

with

```ruby
params.require(:property).permit(:name, :price, :description, :property_type, :agent_id, :photo_1, :photo_2, :photo_3)
```

**`app/models/property.rb`:**

```ruby
  ...

  validates_inclusion_of :property_type, in: ACCEPT_TYPES, message: "property type %{value} is not included in the: #{ACCEPT_TYPES.join(", ")}."

  has_attached_file :photo_1, styles: { medium: "300x300>", small: "100x100>" }
  validates_attachment_content_type :photo_1, content_type: /\Aimage\/.*\Z/

  has_attached_file :photo_2, styles: { medium: "300x300>", small: "100x100>" }
  validates_attachment_content_type :photo_1, content_type: /\Aimage\/.*\Z/

  has_attached_file :photo_3, styles: { medium: "300x300>", small: "100x100>" }
  validates_attachment_content_type :photo_1, content_type: /\Aimage\/.*\Z/
```

**`app/views/properties/new.html.erb`:**

```ruby
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
    <%= f.label :agent_id, class: "col-sm-2 control-label" %>
    <div class="col-sm-10">
      <%= f.collection_select :agent_id, Agent.all, :id, :name, {}, { class: "form-control" } %>
    </div>
  </div>

  <div class="form-group">
    <%= f.label :photo_1, class: "col-sm-2 control-label" %>

    <div class="col-sm-8">
      <%= f.file_field :photo_1, class: "form-control" %>
    </div>

    <div class="col-sm-2 text-left">
      <%= image_tag @property.photo_1.url(:small) %>
    </div>
  </div>

  <div class="form-group">
    <%= f.label :photo_2, class: "col-sm-2 control-label" %>

    <div class="col-sm-8">
      <%= f.file_field :photo_2, class: "form-control" %>
    </div>

    <div class="col-sm-2 text-left">
      <%= image_tag @property.photo_2.url(:small) %>
    </div>
  </div>

  <div class="form-group">
    <%= f.label :photo_3, class: "col-sm-2 control-label" %>

    <div class="col-sm-8">
      <%= f.file_field :photo_3, class: "form-control" %>
    </div>

    <div class="col-sm-2 text-left">
      <%= image_tag @property.photo_3.url(:small) %>
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

**`app/views/properties/edit.html.erb`:**

```ruby
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
    <%= f.label :agent_id, class: "col-sm-2 control-label" %>
    <div class="col-sm-10">
      <%= f.collection_select :agent_id, Agent.all, :id, :name, {}, { class: "form-control" } %>
    </div>
  </div>

  <div class="form-group">
    <%= f.label :photo_1, class: "col-sm-2 control-label" %>

    <div class="col-sm-8">
      <%= f.file_field :photo_1, class: "form-control" %>
    </div>

    <div class="col-sm-2 text-left">
      <%= image_tag @property.photo_1.url(:small) %>
    </div>
  </div>

  <div class="form-group">
    <%= f.label :photo_2, class: "col-sm-2 control-label" %>

    <div class="col-sm-8">
      <%= f.file_field :photo_2, class: "form-control" %>
    </div>

    <div class="col-sm-2 text-left">
      <%= image_tag @property.photo_2.url(:small) %>
    </div>
  </div>

  <div class="form-group">
    <%= f.label :photo_3, class: "col-sm-2 control-label" %>

    <div class="col-sm-8">
      <%= f.file_field :photo_3, class: "form-control" %>
    </div>

    <div class="col-sm-2 text-left">
      <%= image_tag @property.photo_3.url(:small) %>
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

```html+erb
...

<p>
  <strong>Type:</strong>
  <%= @property.property_type %>
</p>

<div class="row">
  <% if @property.photo_1.present? %>
    <div class="col-sm-4">
      <div class="thumbnail">
        <%= image_tag @property.photo_1.url(:medium) %>
      </div>
    </div>
  <% end %>

  <% if @property.photo_2.present? %>
    <div class="col-sm-4">
      <div class="thumbnail">
        <%= image_tag @property.photo_2.url(:medium) %>
      </div>
    </div>
  <% end %>

  <% if @property.photo_3.present? %>
    <div class="col-sm-4">
      <div class="thumbnail">
        <%= image_tag @property.photo_3.url(:medium) %>
      </div>
    </div>
  <% end %>
</div>

<p><%= link_to 'Back', properties_path %></p>
```
