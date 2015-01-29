# Answer to More Columns to Property

```
$ bin/rails g migration add_more_columns_to_property
      invoke  active_record
      create    db/migrate/20150129144243_add_more_columns_to_property.rb
```

Edit `db/migrate/20150129144243_add_more_columns_to_property.rb` with following:

```ruby
class AddMoreColumnsToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :baths, :integer
    add_column :properties, :tenure, :integer
    add_column :properties, :developer, :string
    add_column :properties, :condition, :string
  end
end
```

Run:

```
$ bin/rake db:migrate
== 20150129144243 AddMoreColumnsToProperty: migrating =========================
-- add_column(:properties, :baths, :integer)
   -> 0.0019s
-- add_column(:properties, :tenure, :integer)
   -> 0.0004s
-- add_column(:properties, :developer, :string)
   -> 0.0004s
-- add_column(:properties, :condition, :string)
   -> 0.0002s
== 20150129144243 AddMoreColumnsToProperty: migrated (0.0031s) ================
```

EXPLAIN: `add_column`, `remove_column`, `t.integer`, `t.string` diffrence.
