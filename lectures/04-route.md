# Rails Routing

EXPLAIN: Routing Basics

## `config/routes.rb`

Strip all comments except:

```ruby
Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
end
```

EXPLAIN: Priority, root route.


## Add regular route

Edit `config/routes.rb` with following:

```ruby
Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  get "/properties" => "properties#index"
end
```

EXPLAIN: HTTP Verb, Route & Controller Action

Visit: http://localhost:3000/rails/info/routes:

```
properties_path GET /properties(.:format) properties#index
```

EXPLAIN: Routing Helper, `(.:format)`, Controller Action.

## Resource Routing

```ruby
Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  resources :properties
end
```

```
$ bin/rake routes
       Prefix Verb   URI Pattern                    Controller#Action
   properties GET    /properties(.:format)          properties#index
              POST   /properties(.:format)          properties#create
 new_property GET    /properties/new(.:format)      properties#new
edit_property GET    /properties/:id/edit(.:format) properties#edit
     property GET    /properties/:id(.:format)      properties#show
              PATCH  /properties/:id(.:format)      properties#update
              PUT    /properties/:id(.:format)      properties#update
              DELETE /properties/:id(.:format)      properties#destroy
```

EXPLAIN: REST, resource.

| HTTP Verb | Path             | Controller#Action | Used for                                     |
| --------- | ---------------- | ----------------- | -------------------------------------------- |
| GET       | /properties          | properties#index      | display a list of all properties                 |
| GET       | /properties/new      | properties#new        | return an HTML form for creating a new property |
| POST      | /properties          | properties#create     | create a new property                           |
| GET       | /properties/:id      | properties#show       | display a specific property                     |
| GET       | /properties/:id/edit | properties#edit       | return an HTML form for editing a property      |
| PATCH/PUT | /properties/:id      | properties#update     | update a specific property                      |
| DELETE    | /properties/:id      | properties#destroy    | delete a specific property                      |

EXPLAIN: Each route and its practical meaning.

## Path and URL Helpers

- `properties_path` returns `/properties`
- `new_property_path` returns `/properties/new`
- `edit_property_path(:id)` returns `/properties/:id/edit` (for instance, `edit_property_path(10)` returns `/properties/10/edit`)
- `property_path(:id)` returns `/properties/:id` (for instance, `property_path(10)` returns `/properties/10`)
