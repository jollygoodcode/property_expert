# Active Record Validations

EXPLAIN: Validation Basics

## Triggers

```
valid?
invalid?
create
create!
save
save!
update
update!
```

### validates_presence_of

```ruby
class Property < ActiveRecord::Base
  validates_presence_of :name
end
```

```
> rails c --sandbox
Loading development environment in sandbox (Rails 4.2.0)
Any modifications you make will be rolled back on exit
```

```
> property = Property.new
=> #<Property id: nil, name: nil, property_type: nil, price: nil, size: nil, description: nil, postal_code: nil, street: nil, bedrooms: nil, photo_1: nil, photo_2: nil, photo_3: nil, created_at: nil, updated_at: nil>

> property.errors
=> #<ActiveModel::Errors:0x007fb1228f22f0 @base=#<Property id: nil, name: nil, property_type: nil, price: nil, size: nil, description: nil, postal_code: nil, street: nil, bedrooms: nil, photo_1: nil, photo_2: nil, photo_3: nil, created_at: nil, updated_at: nil>, @messages={}>

> property.errors.messages
=> {}

> property.valid?
=> false

> property.errors
=> #<ActiveModel::Errors:0x007fb1228f22f0 @base=#<Property id: nil, name: nil, property_type: nil, price: nil, size: nil, description: nil, postal_code: nil, street: nil, bedrooms: nil, photo_1: nil, photo_2: nil, photo_3: nil, created_at: nil, updated_at: nil>, @messages={:name=>["can't be blank"]}>

> property.errors.messages
=> {:name=>["can't be blank"]}
```

TIP: errors.full_messages, errors.full_messages_for(:name)

### validates_numericality_of

```ruby
class Property < ActiveRecord::Base
  validates_numericality_of :price
end
```

```
> property = Property.new
=> #<Property id: nil, name: nil, property_type: nil, price: nil, size: nil, description: nil, postal_code: nil, street: nil, bedrooms: nil, photo_1: nil, photo_2: nil, photo_3: nil, created_at: nil, updated_at: nil>

> property.valid?
=> false

> property.errors.full_messages
=> ["Name can't be blank", "Price is not a number"]
```

### validates_length_of

```ruby
class Property < ActiveRecord::Base
  validates_length_of :description, minimum: 140, maximum: 1000
end
```

```
property = Property.new
=> #<Property id: nil, name: nil, property_type: nil, price: nil, size: nil, description: nil, postal_code: nil, street: nil, bedrooms: nil, photo_1: nil, photo_2: nil, photo_3: nil, created_at: nil, updated_at: nil>

> property.valid?
=> false

> property.errors.full_messages
=> ["Description is too short (minimum is 140 characters)"]
```

We want to change text for too short:

```ruby
class Property < ActiveRecord::Base
  validates_length_of :description, minimum: 140, too_short: 'please enter at least 140 characters', maximum: 1000
end
```

```
> property = Property.new
=> #<Property id: nil, name: nil, property_type: nil, price: nil, size: nil, description: nil, postal_code: nil, street: nil, bedrooms: nil, photo_1: nil, photo_2: nil, photo_3: nil, created_at: nil, updated_at: nil>

> property.valid?
=> false

> property.errors.full_messages
=> ["Description please enter at least 140 characters"]

> property.description = "a"*1001
=> "a...a" # string of repeating a of length 1001.

> property.valid?
=> false

> property.errors.full_messages
=> ["Description is too long (maximum is 1000 characters)"]
```

### validates_inclusion_of

```ruby
class Property < ActiveRecord::Base
  ACCEPT_TYPES = ["Apartment", "Condominium", "Landed House", "HDB Apartment"]

  validates_inclusion_of :property_type, in: ACCEPT_TYPES
end
```

```
> property = Property.new(property_type: "Penthouse")
=> #<Property id: nil, name: nil, property_type: "Penthouse", price: nil, size: nil, description: nil, postal_code: nil, street: nil, bedrooms: nil, photo_1: nil, photo_2: nil, photo_3: nil, created_at: nil, updated_at: nil>

> property.valid?
=> false

> property.errors.full_messages
=> ["Property type is not included in the list"]
```

Make it friendly:

```ruby
class Property < ActiveRecord::Base
  ACCEPT_TYPES = ["Apartment", "Condominium", "Landed House", "HDB Apartment"]

  validates_inclusion_of :property_type, in: ACCEPT_TYPES, message: "property type %{value} is not included in the: #{ACCEPT_TYPES.join(", ")}."
end
```

```
> property = Property.new(property_type: "Penthouse")
=> #<Property id: nil, name: nil, property_type: "Penthouse", price: nil, size: nil, description: nil, postal_code: nil, street: nil, bedrooms: nil, photo_1: nil, photo_2: nil, photo_3: nil, created_at: nil, updated_at: nil>

> property.valid?
=> false

=> ["Property type property type Penthouse is not included in the: Apartment, Condominium, Landed House, HDB Apartment."]
```


ALL we have by now:

```ruby
class Property < ActiveRecord::Base
  ACCEPT_TYPES = ["Apartment", "Condominium", "Landed House", "HDB Apartment"]

  validates_presence_of :name
  validates_numericality_of :price
  validates_length_of :description, minimum: 140, too_short: 'please enter at least 140 characters', maximum: 1000
  validates_inclusion_of :property_type, in: ACCEPT_TYPES, message: "property type %{value} is not included in the: #{ACCEPT_TYPES.join(", ")}."
end
```

```
> property = Property.new; property.valid?; property.errors.full_messages
=> ["Name can't be blank", "Price is not a number", "Description please enter at least 140 characters", "Property type property type  is not included in the: Apartment, Condominium, Landed House, HDB Apartment."]
```

## Skip Validations

<sup>http://guides.rubyonrails.org/active_record_validations.html#skipping-validations</sup>

- decrement!
- decrement_counter
- increment!
- increment_counter
- toggle!
- touch
- update_all
- update_attribute
- update_column
- update_columns
- update_counters
- save(validate: false)

## List of Validations

- validates_absence_of
- validates_presence_of
- validates_acceptance_of
- validates_associated
- validates_confirmation_of
- validates_each
- validates_format_of
- validates_inclusion_of
- validates_exclusion_of
- validates_length_of
- validates_numericality_of
- validates_uniqueness_of
- validates_with

http://guides.rubyonrails.org/active_record_validations.html
