# Answer: Agent File Upload

## User Stories

```
As a user, I want to upload a photo when creating new agent.
```

```
$ rails generate migration add_photo_column_to_agents
      invoke  active_record
      create    db/migrate/20150205075526_add_photo_column_to_agents.rb
```

Edit `db/migrate/20150205075526_add_photo_column_to_agents.rb`:

```ruby
class AddPhotoColumnToAgents < ActiveRecord::Migration
  def up
    remove_column :agents, :photo
    add_attachment :agents, :photo
  end

  def down
    remove_attachment :agents, :photo
    add_column :agents, :photo, :string
  end
end
```

```
== 20150205075526 AddPhotoColumnToAgents: migrating ===========================
-- remove_column(:agents, :photo)
   -> 0.0007s
-- add_attachment(:agents, :photo)
   -> 0.0015s
== 20150205075526 AddPhotoColumnToAgents: migrated (0.0022s) ==================
```

**`app/controllers/agents_controller`:**

Replace

```ruby
params.require(:agent).permit(:name, :company, :mobile)
```

with

```ruby
params.require(:agent).permit(:name, :company, :mobile, :photo)
```

**`app/models/agent.rb`:**

```ruby
  has_attached_file :photo, styles: { medium: "300x300>", small: "100x100>" }
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
```

**`app/views/agents/new.html.erb`:**

```html+erb
<div class="page-header">
  <h1>New Agent</h1>
</div>

<%= form_for :agent, url: agents_path, html: { class: "form-horizontal" } do |f| %>
  <% if @agent.errors.any? %>
    <div>
      <ul>
        <% @agent.errors.full_messages.each do |msg| %>
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
      <%= image_tag @agent.photo.url(:small) if @agent.photo.present? %>
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

```
As a user, I want to see agent's photo on agent show page.
```

**`app/views/agents/show.html.erb`:**

```html+erb
<div class="row">
  <% if @agent.photo.present? %>
    <div class="col-sm-4">
      <div class="thumbnail">
        <%= image_tag @agent.photo.url(:medium) %>
      </div>
    </div>
  <% end %>
</div>
```

```
As a user, I want to upload a photo when editing an agent.
```

**`app/views/agents/edit.html.erb`:**

```html+erb
<div class="page-header">
  <h1>Edit Agent</h1>
</div>

<%= form_for :agent, url: agent_path(@agent), method: :patch, html: { class: "form-horizontal" } do |f| %>
  <% if @agent.errors.any? %>
    <div>
      <ul>
        <% @agent.errors.full_messages.each do |msg| %>
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
      <%= image_tag @agent.photo.url(:small) if @agent.photo.present? %>
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
