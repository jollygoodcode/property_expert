# Active Record Associations

EXPLAIN: Association Basics

## List of Associations

- belongs_to
- has_one
- has_many
- has_many :through
- has_one :through
- has_and_belongs_to_many
- polymorphic associations
- self joins

EXPLAIN: Association API

```ruby
class Property < ActiveRecord::Base
  ACCEPT_TYPES = ["Apartment", "Condominium", "Landed House", "HDB Apartment"]

  belongs_to :agent

  validates_presence_of :name
  validates_numericality_of :price
  validates_length_of :description, minimum: 140, too_short: 'please enter at least 140 characters', maximum: 1000
  validates_inclusion_of :property_type, in: ACCEPT_TYPES, message: "property type %{value} is not included in the: #{ACCEPT_TYPES.join(", ")}."
end

```

```ruby
class Agent < ActiveRecord::Base
  has_many :properties

  validates_presence_of :name
  validates_presence_of :company
  validates_presence_of :mobile

  validates_format_of :mobile, with: /[7-8][1-9][1-9]{2}[\s]+[1-9]{4}|[9][0-8][1-9]{2}\s[1-9]{4}/
end
```

## Foreign Key

EXPLAIN: Foreign key.

TIP: Add foreign key to `belongs_to` model.

3 ways:

```
t.integer :agent_id
```

```
t.belongs_to :agent
t.references :agent
```

### Index

EXPLAIN: Why index?

```
t.integer :agent_id
add_index :agents, :agent_id
```

```
t.belongs_to :agent, index: true
t.references :agent, index: true
```

## In Action

```
$ bin/rails generate migration add_agent_id_to_proterties
      invoke  active_record
      create    db/migrate/20150129145019_add_agent_id_to_proterties.rb
```

```ruby
class AddAgentIdToProperties < ActiveRecord::Migration
  def change
    change_table(:properties) do |t|
      t.integer :agent_id
      add_index :properties, :agent_id
    end
  end
end
```

or

```ruby
class AddAgentIdToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :agent_id, :integer
    add_index :properties, :agent_id
  end
end
```

Same as

```ruby
class AddAgentIdToProperties < ActiveRecord::Migration
  def change
    change_table(:properties) do |t|
      # t.belongs_to :agent, index: true
      t.references :agent, index: true
    end
  end
end
```

or

```ruby
class AddAgentIdToProperties < ActiveRecord::Migration
  def change
    # add_belongs_to :properties, :agent_id, index: true
    add_reference :properties, :agent_id, index: true
  end
end
```

Most common, edit `db/migrate/20150129145019_add_agent_id_to_properties.rb` with following:

```ruby
class AddAgentIdToProperties < ActiveRecord::Migration
  def change
    change_table(:properties) do |t|
      t.references :agent, index: true
    end
  end
end
```

```
$ bin/rake db:migrate
== 20150129145019 AddAgentIdToProperties: migrating ============================
-- change_table(:properties)
   -> 0.0037s
== 20150129145019 AddAgentIdToProperties: migrated (0.0038s) ===================

$ bin/rails console
> Property
=> Property(..., agent_id: integer)
```

## Rails 4.2.0+

```
add_foreign_key
remove_foreign_key
```

## Rollback

EXPLAIN: When to Rollback? How?

```
class AddPropertyIdToAgent < ActiveRecord::Migration
  def change
    ...
  end
end
```

Under the hood

```
class AddPropertyIdToAgent < ActiveRecord::Migration
  def up
    ...
  end

  def down
    ...
  end
end
```
