# Rails Models

<sup>Covering Rails Models, migrations, validations and associations.</sup>

```
$ bin/rails generate migration create_property
      invoke  active_record
      create    db/migrate/20150129143717_create_property.rb
```

EXPLAIN: Available generators (rails generate)

```ruby
class CreateProperty < ActiveRecord::Migration
  def change
    create_table :properties do |t|
    end
  end
end
```

EXPLAIN: Migration

```ruby
class CreateProperty < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string  :name
      t.string  :property_type
      t.integer :price
      t.integer :size
      t.text    :description
      t.string  :postal_code
      t.string  :street
      t.integer :bedrooms
      t.string  :photo_1
      t.string  :photo_2
      t.string  :photo_3

      t.timestamps null: false
    end
  end
end
```

EXPLAIN: Database, tables, migration API

```
$ bin/rake db:migrate
== 20150129143717 CreateProperty: migrating ===================================
-- create_table(:properties)
   -> 0.0225s
== 20150129143717 CreateProperty: migrated (0.0226s) ==========================
```

EXPLAIN: Rake Tasks

```
$ touch app/models/property.rb
```

EXPLAIN: ActiveRecord::Base Basics

```
$ rails console
Loading development environment (Rails 4.2.0)
```

EXPLAIN: environments, development, test, production.

```
> Property
=> Property (call 'Property.connection' to establish a connection)

> Property.connection
=> #<ActiveRecord::ConnectionAdapters::PostgreSQLAdapter:0x007f9af2102f40>

> Property
=> Property(id: integer, name: string, property_type: string, price: integer, size: integer, description: text, postal_code: string, street: string, bedrooms: integer, photo_1: string, photo_2: string, photo_3: string, created_at: datetime, updated_at: datetime)
```

TIP: $ rails console --sandbox

```
> property = Property.new(name: "312 Ang Mo Kio Avenue 3")
=> #<Property id: nil, name: "312 Ang Mo Kio Avenue 3", property_type: nil, price: nil, size: nil, description: nil, postal_code: nil, street: nil, bedrooms: nil, photo_1: nil, photo_2: nil, photo_3: nil, created_at: nil, updated_at: nil>

> property.save
   (0.2ms)  BEGIN
  SQL (0.4ms)  INSERT INTO "properties" ("name", "created_at", "updated_at") VALUES ($1, $2, $3) RETURNING "id"  [["name", "312 Ang Mo Kio Avenue 3"], ["created_at", "2015-01-29 04:32:57.545435"], ["updated_at", "2015-01-29 04:32:57.545435"]]
   (1.0ms)  COMMIT
=> true
```

```
> property
=> #<Property id: 1, name: "312 Ang Mo Kio Avenue 3", property_type: nil, price: nil, size: nil, description: nil, postal_code: nil, street: nil, bedrooms: nil, photo_1: nil, photo_2: nil, photo_3: nil, created_at: "2015-01-29 04:32:57", updated_at: "2015-01-29 04:32:57">

> property.property_type = "Singapore HDB"
=> "Singapore HDB"

> property.save
   (0.1ms)  BEGIN
  SQL (0.2ms)  UPDATE "properties" SET "property_type" = $1, "updated_at" = $2 WHERE "properties"."id" = $3  [["property_type", "Singapore HDB"], ["updated_at", "2015-01-29 04:33:38.448652"], ["id", 1]]
   (6.0ms)  COMMIT
=> true
```

```
> property
=> #<Property id: 1, name: "312 Ang Mo Kio Avenue 3", property_type: "Singapore HDB", price: nil, size: nil, description: nil, postal_code: nil, street: nil, bedrooms: nil, photo_1: nil, photo_2: nil, photo_3: nil, created_at: "2015-01-29 04:32:57", updated_at: "2015-01-29 04:33:38">

> property.update(size: 98)
   (0.1ms)  BEGIN
  SQL (0.2ms)  UPDATE "properties" SET "size" = $1, "updated_at" = $2 WHERE "properties"."id" = $3  [["size", 98], ["updated_at", "2015-01-29 04:34:07.788373"], ["id", 1]]
   (0.4ms)  COMMIT
=> true
```

new + save = create:

```
> Property.create(name: "541 Ang Mo Kio Avenue 10")
   (0.1ms)  BEGIN
  SQL (0.2ms)  INSERT INTO "properties" ("name", "created_at", "updated_at") VALUES ($1, $2, $3) RETURNING "id"  [["name", "541 Ang Mo Kio Avenue 10"], ["created_at", "2015-01-29 04:34:29.692391"], ["updated_at", "2015-01-29 04:34:29.692391"]]
   (5.0ms)  COMMIT
=> #<Property id: 2, name: "541 Ang Mo Kio Avenue 10", property_type: nil, price: nil, size: nil, description: nil, postal_code: nil, street: nil, bedrooms: nil, photo_1: nil, photo_2: nil, photo_3: nil, created_at: "2015-01-29 04:34:29", updated_at: "2015-01-29 04:34:29">
```

Blk 205 Ang Mo Kio Avenue 1, (S)560205
Blk 206 Ang Mo Kio Avenue 1, (S)560206
...
Blk 210 Ang Mo Kio Avenue 1, (S)560210

```
> (205..211).each { |n| Property.create(name: "Blk #{n} Ang Mo Kio Avenue 1, (S)560#{n}") }

=> 205..211
```

Ooops. No 211.

```
> property_211 = Property.find_by(name: "Blk 211 Ang Mo Kio Avenue 1, (S)560211")
  Property Load (0.3ms)  SELECT  "properties".* FROM "properties" WHERE "properties"."name" = $1 LIMIT 1  [["name", "Blk 211 Ang Mo Kio Avenue 1, (S)560211"]]
=> #<Property id: 16, name: "Blk 211 Ang Mo Kio Avenue 1, (S)560211", property_type: nil, price: nil, size: nil, description: nil, postal_code: nil, street: nil, bedrooms: nil, photo_1: nil, photo_2: nil, photo_3: nil, created_at: "2015-01-29 04:35:39", updated_at: "2015-01-29 04:35:39">

> property_211.destroy
   (0.1ms)  BEGIN
  SQL (0.2ms)  DELETE FROM "properties" WHERE "properties"."id" = $1  [["id", 16]]
   (0.4ms)  COMMIT
=> #<Property id: 16, name: "Blk 211 Ang Mo Kio Avenue 1, (S)560211", property_type: nil, price: nil, size: nil, description: nil, postal_code: nil, street: nil, bedrooms: nil, photo_1: nil, photo_2: nil, photo_3: nil, created_at: "2015-01-29 04:35:39", updated_at: "2015-01-29 04:35:39">
```

EXPLAIN: ActiveRecord Basics
<sup>http://guides.rubyonrails.org/active_record_basics.html</sup>

```
> Property.all
> Property.first
> Property.last
> Property.count
> Property.where(name: "541 Ang Mo Kio Avenue 10")
> Property.order(created_at: :desc)
> Property.limit(2)
```

EXPLAIN: Basic ActiveRecord Query Interface
<sup>http://guides.rubyonrails.org/active_record_querying.html</sup>
