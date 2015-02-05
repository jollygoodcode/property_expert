# Nested Associations

EXPLAIN: Nested Associations Basics

## Photo Model for Property and Agent

EXPLAIN: polymorphic association

```
$ bin/rails generate migration create_photos
      invoke  active_record
      create    db/migrate/20150205123350_create_photos.rb
```

```ruby
class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.attachment :file
      t.references :owner, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
```

<sup>http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/TableDefinition.html#method-i-references</sup>

```
$ bin/rake db:migrate
== 20150205123350 CreatePhotos: migrating =====================================
-- create_table(:photos)
   -> 0.0209s
== 20150205123350 CreatePhotos: migrated (0.0210s) ============================
```

**`app/controllers/properties_controller.rb`:**

Replace:

```ruby
params.require(:property).permit(:name, :price, :description, :property_type, :agent_id, :photo_1, :photo_2, :photo_3)
```

with

```ruby
params.require(:property).permit(:name, :price, :description, :property_type, photos_attributes: [:id, :file, :_destroy])
```

```
$ touch app/models/photo.rb
```

**`app/models/photo.rb`:**

```ruby
class Photo < ActiveRecord::Base
  belongs_to :owner, polymorphic: true

  has_attached_file :file,
                    styles: {
                      medium: '300x300>',
                       small: '100x100>'
                    },
                    preserve_files: true,
                    default_url: "/images/missing.png"

  validates_attachment_content_type :file, content_type: /\Aimage\/.*\z/
end
```

```
$ mkdir public/images/
$ curl -o public/images/missing.png https://s3-ap-southeast-1.amazonaws.com/jollygood-courses/images/missing.png
```

**`app/models/property.rb`:**

```ruby
class Property < ActiveRecord::Base
  ACCEPT_TYPES = ["Apartment", "Condominium", "Landed House", "HDB Apartment"]

  belongs_to :agent

  validates_presence_of :name
  validates_numericality_of :price
  validates_length_of :description, minimum: 140, too_short: 'please enter at least 140 characters', maximum: 1000
  validates_inclusion_of :property_type, in: ACCEPT_TYPES, message: "property type %{value} is not included in the: #{ACCEPT_TYPES.join(", ")}."

  has_many :photos, as: :owner, dependent: :destroy
  accepts_nested_attributes_for :photos, reject_if: :all_blank, allow_destroy: true
end
```

Install cocoon:

```ruby
gem 'cocoon'
```

```
$ bundle
```

**`app/assets/javascripts/application.js`:**

```js
...
//= require cocoon
//= require_tree .
```

<sup>https://github.com/nathanvda/cocoon#installation</sup>

**`app/views/properties/new.html.erb`:**

```html+erb
<div class="page-header">
  <h1>New Property</h1>
</div>

<%= form_for @property, html: { class: "form-horizontal" } do |f| %>
  ...

  <div class="row add-photo-link">
    <div class="col-sm-10 col-sm-offset-2">
      <%= link_to_add_association 'add photo', f, :photos %>
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

```html+erb
<div class="page-header">
  <h1>Edit Property</h1>
</div>

<%= form_for @property, url: property_path(@property), method: :patch, html: { class: "form-horizontal" } do |f| %>
  ...

  <div id="photos">
    <%= f.fields_for :photos do |photo| %>
      <%= render 'photo_fields', f: photo %>
    <% end %>
  </div>

  <div class="row add-photo-link">
    <div class="col-sm-10 col-sm-offset-2">
      <%= link_to_add_association 'add photo', f, :photos %>
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

```
$ touch app/views/properties/_photo_fields.html.erb
```

**`app/views/properties/_photo_fields.html.erb`:**

```html+erb
<div class="nested-fields">
  <div class="form-group">
    <div class="field">
      <%= f.label :file, class: "col-sm-2 control-label" %>
      <div class="col-sm-2">
        <div class="thumbnail">
          <%= image_tag f.object.file.url(:medium) %>
        </div>
      </div>
      <div class="col-sm-6">
        <%= f.file_field :file %>
      </div>
    </div>
    <div class="col-sm-2">
      <%= link_to_remove_association "remove photo", f %>
    </div>
  </div>
</div>
```

**`app/views/properties/show.html.erb`:**

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

<div class="row">
  <% @property.photos.each do |photo| %>
    <div class="col-sm-4">
      <div class="thumbnail">
        <%= image_tag photo.file.url(:medium) %>
      </div>
    </div>
  <% end %>
</div>

<p><%= link_to 'Back', properties_path %></p>
```

**`app/assets/stylesheets/application.scss`:**

```scss
.add-photo-link {
  margin-bottom: 30px;
}
```

Clean up columns:

```
$ bin/rails generate migration remove_columns_from_properties
```

```ruby
class RemoveColumnsFromProperties < ActiveRecord::Migration
  def up
    remove_attachment :photo_1
    remove_attachment :photo_2
    remove_attachment :photo_3
  end

  def down
    add_attachment :photo_1
    add_attachment :photo_2
    add_attachment :photo_3
  end
end
```

```
$ bin/rake db:migrate
== 20150205124505 RemoveColumnsFromProperties: migrating ======================
-- remove_attachment(:properties, :photo_1)
   -> 0.0013s
-- remove_attachment(:properties, :photo_2)
   -> 0.0008s
-- remove_attachment(:properties, :photo_3)
   -> 0.0008s
== 20150205124505 RemoveColumnsFromProperties: migrated (0.0030s) =============
```
