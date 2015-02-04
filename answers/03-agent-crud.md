# Answers to Agent CRUD Exercise

## Routing

-   [x] As a User, I want to create new agent on '/agents/new' page.

    **`config/routes.rb`:**

    ```ruby
    Rails.application.routes.draw do
      # The priority is based upon order of creation: first created -> highest priority.
      # See how all your routes lay out with "rake routes".

      # You can have the root of your site routed with "root"
      # root 'welcome#index'

      resources :properties
      resources :agents
    end
    ```

    ```bash
    $ touch app/controllers/agents_controller.rb
    ```

    ```bash
    $ mkdir app/views/agents
    $ touch app/views/agents/new.html.erb
    ```

    **`app/views/agents/new.html.erb`**

    ```html+erb
    <h1>New Agent</h1>

    <%= form_for :agent, url: agents_path do |f| %>
      <p>
        <%= f.label :name %><br>
        <%= f.text_field :name %>
      </p>

      <p>
        <%= f.label :company %><br>
        <%= f.text_field :company %>
      </p>

      <p>
        <%= f.label :mobile %><br>
        <%= f.text_area :mobile %>
      </p>

      <p>
        <%= f.submit %>
      </p>
    <% end %>
    ```

    ```ruby
    class AgentsController < ApplicationController
      def new
        @agent = Agent.new
      end

      def create
        @agent = Agent.new(params.require(:agent).permit(:name, :company, :mobile))

        if @agent.save
          redirect_to @agent
        else
          render :new
        end
      end
    end
    ```

-   [x] As a User, I want to see reasons when failed to create on '/agents/new' page.

    ```html+erb
    <h1>New Agent</h1>

    <%= form_for :agent, url: agents_path do |f| %>
      <% if @agent.errors.any? %>
        <div>
          <ul>
            <% @agent.errors.full_messages.each do |msg| %>
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
        <%= f.label :company %><br>
        <%= f.text_field :company %>
      </p>

      <p>
        <%= f.label :mobile %><br>
        <%= f.text_area :mobile %>
      </p>

      <p>
        <%= f.submit %>
      </p>
    <% end %>
    ```

-   [x] As a User, I want to see list of agents on '/agents' page.

    ```ruby
    class AgentsController < ApplicationController
      def index
        @agents = Agent.all
      end

      def new
        @agent = Agent.new
      end

      def create
        @agent = Agent.new(params.require(:agent).permit(:name, :company, :mobile))

        if @agent.save
          redirect_to @agent
        else
          render :new
        end
      end

      def show
        @agent = Agent.find(params[:id])
      end
    end
    ```

    ```bash
    $ touch app/views/agents/index.html.erb
    ```

    ```html+erb
    <h1>Listing agents</h1>

    <table>
      <tr>
        <th>Title</th>
        <th>Company</th>
        <th>Mobile</th>
      </tr>

      <% @agents.each do |agent| %>
        <tr>
          <td><%= agent.name %></td>
          <td><%= agent.company %></td>
          <td><%= agent.mobile %></td>
        </tr>
      <% end %>
    </table>
    ```

-   [x] As a User, I want a link to come back to '/agents' on the bottom of '/agents/new' page.

    ```html+erb
    <h1>New Agent</h1>

    <%= form_for :agent, url: agents_path do |f| %>
      <% if @agent.errors.any? %>
        <div>
          <ul>
            <% @agent.errors.full_messages.each do |msg| %>
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
        <%= f.label :company %><br>
        <%= f.text_field :company %>
      </p>

      <p>
        <%= f.label :mobile %><br>
        <%= f.text_area :mobile %>
      </p>

      <p>
        <%= f.submit %>
      </p>
    <% end %>

    <p><%= link_to 'Back', agents_path %></p>
    ```

-   [x] As a User, I want to view specific agent info on '/agent/:id' page.

    ```ruby
    class AgentsController < ApplicationController
      def new
        @agent = Agent.new
      end

      def create
        @agent = Agent.new(params.require(:agent).permit(:name, :company, :mobile))

        if @agent.save
          redirect_to @agent
        else
          render :new
        end
      end

      def show
        @agent = Agent.find(params[:id])
      end
    end
    ```

    ```html+erb
    <p>
      <strong>Name:</strong>
      <%= @agent.name %>
    </p>

    <p>
      <strong>Company:</strong>
      <%= @agent.company %>
    </p>

    <p>
      <strong>Mobile:</strong>
      <%= @agent.mobile %>
    </p>
    ```

-   [x] As a User, I want a link to come back to '/agents' on the bottom of '/agents/:id' page.

    ```html+erb
    <p>
      <strong>Name:</strong>
      <%= @agent.name %>
    </p>

    <p>
      <strong>Company:</strong>
      <%= @agent.company %>
    </p>

    <p>
      <strong>Mobile:</strong>
      <%= @agent.mobile %>
    </p>

    <p><%= link_to 'Back', agents_path %></p>
    ```

-   [x] As a User, I want a link 'Show' to view an agent on '/agents' page.

    ```html+erb
    <h1>Listing agents</h1>

    <table>
      <tr>
        <th>Title</th>
        <th>Company</th>
        <th>Mobile</th>
        <th>Actions</th>
      </tr>

      <% @agents.each do |agent| %>
        <tr>
          <td><%= agent.name %></td>
          <td><%= agent.company %></td>
          <td><%= agent.mobile %></td>
          <td><%= link_to "Show", agent_path(agent) %></td>
        </tr>
      <% end %>
    </table>
    ```

-  [x] As a User, I want to edit agent info on '/agents/:id/edit' page.

    ```ruby
    class AgentsController < ApplicationController
      def index
        @agents = Agent.all
      end

      def new
        @agent = Agent.new
      end

      def create
        @agent = Agent.new(params.require(:agent).permit(:name, :company, :mobile))

        if @agent.save
          redirect_to @agent
        else
          render :new
        end
      end

      def show
        @agent = Agent.find(params[:id])
      end

      def edit
        @agent = Agent.find(params[:id])
      end

      def update
        @agent = Agent.find(params[:id])

        if @agent.update(params.require(:agent).permit(:name, :company, :mobile))
          redirect_to @agent
        else
          render :edit
        end
      end
    end
    ```

    ```bash
    $ touch app/views/agents/edit.html.erb
    ```

    **`app/views/agents/edit.html.erb`:**

    ```html+erb
    <h1>Edit Agent</h1>

    <%= form_for :agent, url: agents_path do |f| %>
      <% if @agent.errors.any? %>
        <div>
          <ul>
            <% @agent.errors.full_messages.each do |msg| %>
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
        <%= f.label :company %><br>
        <%= f.text_field :company %>
      </p>

      <p>
        <%= f.label :mobile %><br>
        <%= f.text_area :mobile %>
      </p>

      <p>
        <%= f.submit %>
      </p>
    <% end %>
    ```

-   [x] As a User, I want a link to come back to '/agents' on the bottom of '/agents/:id/edit' page.

    ```html+erb
    <h1>Edit Agent</h1>

    <%= form_for :agent, url: agents_path do |f| %>
      <p>
        <%= f.label :name %><br>
        <%= f.text_field :name %>
      </p>

      <p>
        <%= f.label :company %><br>
        <%= f.text_field :company %>
      </p>

      <p>
        <%= f.label :mobile %><br>
        <%= f.text_area :mobile %>
      </p>

      <p>
        <%= f.submit %>
      </p>
    <% end %>

    <p><%= link_to 'Back', agents_path %></p>
    ```

-   [x] As a User, I want to see reasons when failed to update on '/agents/:id/edit' page.

    ```html+erb
    <h1>Edit Agent</h1>

    <%= form_for :agent, url: agents_path do |f| %>
      <% if @agent.errors.any? %>
        <div>
          <ul>
            <% @agent.errors.full_messages.each do |msg| %>
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
        <%= f.label :company %><br>
        <%= f.text_field :company %>
      </p>

      <p>
        <%= f.label :mobile %><br>
        <%= f.text_area :mobile %>
      </p>

      <p>
        <%= f.submit %>
      </p>
    <% end %>

    <p><%= link_to 'Back', agents_path %></p>
    ```

-   [x] As a User, I want a link 'Edit' to edit an agent on '/agents' page.

    ```html+erb
    <h1>Listing agents</h1>

    <table>
      <tr>
        <th>Title</th>
        <th>Company</th>
        <th>Mobile</th>
        <th colspan="2">Actions</th>
      </tr>

      <% @agents.each do |agent| %>
        <tr>
          <td><%= agent.name %></td>
          <td><%= agent.company %></td>
          <td><%= agent.mobile %></td>
          <td><%= link_to "Show", agent_path(agent) %></td>
          <td><%= link_to "Edit", edit_agent_path(agent) %></td>
        </tr>
      <% end %>
    </table>
    ```

-   [x] As a User, I want to delete an agent on '/agents' page.
-   [x] As a User, I want a link 'Destroy' to delete an agent on '/agents' page.

    ```ruby
    class AgentsController < ApplicationController
      def index
        @agents = Agent.all
      end

      def new
        @agent = Agent.new
      end

      def create
        @agent = Agent.new(params.require(:agent).permit(:name, :company, :mobile))

        if @agent.save
          redirect_to @agent
        else
          render :new
        end
      end

      def show
        @agent = Agent.find(params[:id])
      end

      def edit
        @agent = Agent.find(params[:id])
      end

      def update
        @agent = Agent.find(params[:id])

        if @agent.update(params.require(:agent).permit(:name, :company, :mobile))
          redirect_to @agent
        else
          render :edit
        end
      end

      def destroy
        @agent = Agent.find(params[:id])
        @agent.destroy

        redirect_to agents_path
      end
    end
    ```

    ```html+erb
    <h1>Listing agents</h1>

    <table>
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
          <td><%= link_to "Show", agent_path(agent) %></td>
          <td><%= link_to "Edit", edit_agent_path(agent) %></td>
          <td><%= link_to "Destroy", agent_path(agent), method: :delete, data: { confirm: "Are you sure?" } %></td>
        </tr>
      <% end %>
    </table>
    ```
