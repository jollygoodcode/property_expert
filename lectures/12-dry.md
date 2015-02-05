# Don't Repeat Yourself

<sup>http://en.wikipedia.org/wiki/Don%27t_repeat_yourself</sup>

## Controller: Filters

EXPLAIN: Filters

### `PropertiesController` DRY

Extract

```ruby
params.require(:property).permit(:name, :price, :description, :property_type, photos_attributes: [:id, :file, :_destroy])
```

into `model_params` method:

```ruby
def model_params
  params.require(:property).permit(:name, :price, :description, :property_type, photos_attributes: [:id, :file, :_destroy])
end
```

Extract

```ruby
@property = Property.find(params[:id])
```

into `find_property` method:

```ruby
def find_property
  @property = Property.find(params[:id])
end
```

```diff
diff --git a/app/controllers/properties_controller.rb b/app/controllers/properties_controller.rb
index 98b85d8..f3162b0 100644
--- a/app/controllers/properties_controller.rb
+++ b/app/controllers/properties_controller.rb
@@ -1,4 +1,6 @@
 class PropertiesController < ApplicationController
+  before_action :find_property, only: [:show, :edit, :update, :destroy]
+
   def index
     @properties = Property.all
   end
@@ -8,7 +10,7 @@ class PropertiesController < ApplicationController
   end

   def create
-    @property = Property.new(params.require(:property).permit(:name, :price, :description, :property_type, photos_attributes: [:id, :file, :_destroy]))
+    @property = Property.new(model_params)

     if @property.save
       redirect_to @property, notice: "Property created successfully."
@@ -19,17 +21,13 @@ class PropertiesController < ApplicationController
   end

   def show
-    @property = Property.find(params[:id])
   end

   def edit
-    @property = Property.find(params[:id])
   end

   def update
-    @property = Property.find(params[:id])
-
-    if @property.update(params.require(:property).permit(:name, :price, :description, :property_type, photos_attributes: [:id, :file, :_destroy]))
+    if @property.update(model_params)
       redirect_to @property, notice: "Property updated successfully."
     else
       flash.now[:error] = "Could not save property."
@@ -38,9 +36,7 @@ class PropertiesController < ApplicationController
   end

   def destroy
-    @property = Property.find(params[:id])
     @property.destroy
-
     redirect_to properties_path, notice: "Property deleted successfully."
   end

@@ -48,4 +44,14 @@ class PropertiesController < ApplicationController
     ContactMailer.interested_in(params[:id]).deliver_now
     redirect_to root_path, notice: "Thanks for your feedback!"
   end
+
+  private
+
+  def model_params
+    params.require(:property).permit(:name, :price, :description, :property_type, photos_attributes: [:id, :file, :_destroy])
+  end
+
+  def find_property
+    @property = Property.find(params[:id])
+  end
 end
```

EXPLAIN: diff

### `AgentsController` DRY

```ruby
class AgentsController < ApplicationController
  before_action :find_agent, only: [:show, :edit, :update, :destroy]

  def index
    @agents = Agent.all
  end

  def new
    @agent = Agent.new
  end

  def create
    @agent = Agent.new(model_params)

    if @agent.save
      redirect_to @agent, notice: "Agent created successfully."
    else
      flash.now[:error] = "Could not save agent."
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @agent.update(model_params)
      redirect_to @agent, notice: "Agent created successfully."
    else
      flash.now[:error] = "Could not save agent."
      render :edit
    end
  end

  def destroy
    @agent.destroy
    redirect_to agents_path, notice: "Agent deleted successfully."
  end

  private

    def model_params
      params.require(:agent).permit(:name, :company, :mobile, :photo)
    end

    def find_agent
      @agent = Agent.find(params[:id])
    end
end
```

## View

### Property View DRY

EXPLAIN: Partial.

Extract common code into Partial.

Extract common code inside `new.html.erb` and `edit.html.erb`, into `_form.html.erb`.

```
$ touch app/views/properties/_form.html.erb
```

**`app/views/properties/_form.html.erb`:**

```html+erb
<%= form_for property, html: { class: "form-horizontal" } do |f| %>
  <% if property.errors.any? %>
    <div>
      <ul>
        <% property.errors.full_messages.each do |msg| %>
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

**`app/views/properties/new.html.erb`:**

```html+erb
<div class="page-header">
  <h1>New Property</h1>
</div>

<%= render 'form', property: @property %>
```

**`app/views/properties/edit.html.erb`:**

```html+erb
<div class="page-header">
  <h1>Edit Property</h1>
</div>

<%= render 'form', property: @property %>
```

### Agent View DRY

Extract common code inside `new.html.erb` and `edit.html.erb`, into `_form.html.erb`.

```
$ touch app/views/agents/_form.html.erb
```

**`app/views/agents/_form.html.erb`:**

```html+erb
<%= form_for agent, html: { class: "form-horizontal" } do |f| %>
  <% if agent.errors.any? %>
    <div>
      <ul>
        <% agent.errors.full_messages.each do |msg| %>
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
    <%= f.label :company, class: "col-sm-2 control-label" %>
    <div class="col-sm-10">
      <%= f.text_field :company, class: "form-control" %>
    </div>
  </div>

  <div class="form-group">
    <%= f.label :mobile, class: "col-sm-2 control-label" %>
    <div class="col-sm-10">
      <%= f.text_field :mobile, class: "form-control" %>
    </div>
  </div>

  <div class="form-group">
    <%= f.label :photo, class: "col-sm-2 control-label" %>

    <div class="col-sm-8">
      <%= f.file_field :photo, class: "form-control" %>
    </div>

    <div class="col-sm-2 text-left">
      <%= image_tag agent.photo.url(:small) if agent.photo.present? %>
    </div>
  </div>

  <div class="form-group">
    <div class="col-sm-10 col-sm-offset-2">
      <%= f.submit class: "btn btn-default" %>
      or
      <%= link_to 'Back', agents_path %>
    </div>
  </div>
<% end %>
```

**`app/views/agents/new.html.erb`:**

```html+erb
<div class="page-header">
  <h1>New Agent</h1>
</div>

<%= render 'form', agent: @agent %>
```

**`app/views/agents/edit.html.erb`:**

```html+erb
<div class="page-header">
  <h1>Edit Agent</h1>
</div>

<%= render 'form', agent: @agent %>
```

## Mailer layout DRY

Extract common HTML into layout

```
$ touch app/views/layouts/mailer.html.erb
```

**`app/views/layouts/mailer.html.erb`:**

```html
<!DOCTYPE html>
<html>
  <head>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type' />
  </head>
  <body>
    <%= yield %>
  </body>
</html>
```

**`contact_us.html.erb`:**

```html+erb
<p>From <%= @contact.name %> <%= @contact.email %></p>
<p>Subject: <%= @contact.subject %></p>
<pre><%= @contact.body %></pre>
```

**`interested_in.html.erb`:**

```html+erb
<p>
  Hello <%= @agent.name %>, someone is interested in your property: <%= @property.name %>.
</p>
```

**`welcome_agent.html.erb`:**

```html+erb
<h1>Welcome to Property Expert, <%= @agent.name %></h1>
```
