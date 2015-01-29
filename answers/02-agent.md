# Answers to Agent Exercise

```
$ bin/rails generate migration create_agent
      invoke  active_record
      create    db/migrate/20150129144652_create_agent.rb
```

```ruby
class CreateAgent < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :name
      t.string :company
      t.string :mobile
      t.string :email
      t.string :photo

      t.timestamps null: false
    end
  end
end
```

```
$ bin/rake db:migrate
== 20150129144652 CreateAgent: migrating ======================================
-- create_table(:agents)
   -> 0.0043s
== 20150129144652 CreateAgent: migrated (0.0044s) =============================
```

```
$ touch app/models/agent.rb
```

Edit `app/models/agent.rb` with following:

```ruby
class Agent < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :company
  validates_presence_of :mobile

  validates_format_of :mobile, with: /[7-8][1-9][1-9]{2}[\s]+[1-9]{4}|[9][0-8][1-9]{2}\s[1-9]{4}/
end
```
