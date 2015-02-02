# Answer: Agent Style

**`app/views/agents/index.html.erb`**

```html+erb
<div class="page-header">
  <h1>Listing agents</h1>
</div>


<table class="table">
  <tr>
    <th>Title</th>
    <th>Company</th>
    <th>Mobile</th>
    <th colspan="3">Actions</th>
  </tr>

  <% @agents.each do |agent| %>
    <tr>
      <td><%= agent.name %></td>
      <td><%= agent.company %></td>
      <td><%= agent.mobile %></td>
      <td><%= link_to "Show", agent_path(agent), class: 'btn btn-primary' %></td>
      <td><%= link_to "Edit", edit_agent_path(agent), class: 'btn btn-success' %></td>
      <td><%= link_to "Destroy", agent_path(agent), method: :delete, class: 'btn btn-danger', data: { confirm: "Are you sure?" } %></td>
    </tr>
  <% end %>
</table>
```


**`app/views/agents/new.html.erb`**

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
    <div class="col-sm-10 col-sm-offset-2">
      <%= f.submit class: "btn btn-default" %>
      or
      <%= link_to 'Back', agents_path %>
    </div>
  </div>
<% end %>
```


**`app/views/agents/show.html.erb`**

Same.


**`app/views/agents/edit.html.erb`**

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
    <div class="col-sm-10 col-sm-offset-2">
      <%= f.submit class: "btn btn-default" %>
      or
      <%= link_to 'Back', agents_path %>
    </div>
  </div>
<% end %>
```
