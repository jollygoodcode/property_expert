# Flash & Helper

## Flash

<sup>http://api.rubyonrails.org/classes/ActionDispatch/Flash/FlashHash.html</sup>

EXPLAIN: Flash Basic

## Display Flash in View

```html+erb
<div class="container">
  <div class="row">
    <% flash.each do |type, message| %>
      <%= content_tag(:div, message, class: "alert alert-#{type}") %>
    <% end %>

    <%= yield %>
  </div>
</div>
```

**`app/assets/stylesheets/application.scss`:**

```scss
.alert {
  margin-top: 20px;
}

.alert.alert-notice {
  color: #3c763d;
  background-color: #dff0d8;
  border-color: #d6e9c6;
}

.alert.alert-error {
  color: #a94442;
  background-color: #f2dede;
  border-color: #ebccd1;
}
```

<sup>http://getbootstrap.com/components/#alerts</sup>

**`app/controllers/properties_controller.rb`:**

```ruby
class PropertiesController < ApplicationController
  def index
    @properties = Property.all
  end

  def new
    @property = Property.new
  end

  def create
    @property = Property.new(params.require(:property).permit(:name, :price, :description, :property_type, :agent_id))

    if @property.save
      redirect_to @property, notice: "Property created successfully."
    else
      flash.now[:error] = "Could not save property."
      render :new
    end
  end

  def show
    @property = Property.find(params[:id])
  end

  def edit
    @property = Property.find(params[:id])
  end

  def update
    @property = Property.find(params[:id])

    if @property.update(params.require(:property).permit(:name, :price, :description, :property_type, :agent_id))
      redirect_to @property, notice: "Property updated successfully."
    else
      flash.now[:error] = "Could not save property."
      render :edit
    end
  end

  def destroy
    @property = Property.find(params[:id])
    @property.destroy

    redirect_to properties_path, notice: "Property deleted successfully."
  end
end
```

## Helper

EXPLAIN: Helper Basics

### Extract to Helper

```ruby
<div class="container">
  <div class="row">
    <%= flash_messages %>

    <%= yield %>
  </div>
</div>
```

**`app/helpers/application_helper.rb`:**

```ruby
module ApplicationHelper
  def flash_messages
    flash.map do |type, message|
      next if message.blank?

      content_tag(:div, message, class: "alert alert-#{type}")
    end.join("\n").html_safe
  end
end
```
