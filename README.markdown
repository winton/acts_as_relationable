acts_as_relationable
====================

Automatically creates habtm :through relationships across multiple models using using a single join table.

* Can be self referential
* Quickly define relationship-specific fields
* Create relationships between STI models


Install
-------
	
### From your application directory

	git submodule add git@github.com:winton/acts_as_relationable.git vendor/plugins/acts_as_relationable
	script/generate acts_as_relationable
	rake db:migrate


Model
-----

	class User < ActiveRecord::Base
	  acts_as_relationable :books
	end

	class Book < ActiveRecord::Base
	  acts_as_relationable :users
	end


Controller
----------

	b = Book.find :first
	u = User.find :first
	u.books << b
	u.books	# [ b ]
	b.users	# [ u ]

	
Self referential relationships
------------------------------

	class User < ActiveRecord::Base
	  acts_as_relationable :users
	end
	
	u = User.create
	self.child_users << u
	u.parent_users	# == self


Relationship-specific fields
----------------------------

Say you want users to be able to 'friend' and 'best friend' each other.
	
### Run the generator

	script/generate acts_as_relationable friend:boolean best_friend:boolean
	rake db:migrate

### Model
	
	class User < ActiveRecord::Base
	  acts_as_relationable :users, :fields => [ :friend, :best_friend ]
	
	  self.child_users.first.update_attribute :friend, true
	  self.child_users.first.friend?        # == true
	  self.child_users.first.best_friend?   # == false
	  self.child_users.friends              # [ self.child_users.first ]
	end


##### Copyright (c) 2008 Winton Welsh, released under the MIT license