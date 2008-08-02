acts_as_relationable
====================

	Automatically creates habtm :through relationships across multiple models using using a single join table.


What's so great about this?
---------------------------

* Can be self referential
* All relationships use a single join table
* Easily define relationship-specific fields
* STI compatible


Install
-------
	
### From RAILS_ROOT

	git submodule add git@github.com:winton/acts_as_relationable.git vendor/plugins/acts_as_relationable
	script/generate acts_as_relationable
	rake db:migrate


Controller
----------

	b = Book.find :first
	u = User.find :first
	u.books << b
	u.books	# [ b ]
	b.users	# [ u ]


Model
-----

	class User < ActiveRecord::Base
		acts_as_relationable :books
	end
	
	class Book < ActiveRecord::Base
		acts_as_relationable :users
	end
	
### Self referential relationships

	class User < ActiveRecord::Base
		acts_as_relationable :users
	end
	
	u = User.create
	self.child_users << u
	u.parent_users	# == self


Relationship-specific fields
----------------------------

What if some users are 'favorite' and 'extra favorite'?
	
### Run the generator

	script/generate acts_as_relationable favorite:boolean extra_favorite:boolean
	rake db:migrate

### Model
	
class User < ActiveRecord::Base
	acts_as_relationable :users, :fields => [ :favorite, :extra_favorite ]
	
	self.child_users.first.update_attribute :extra_favorite, true
	self.child_users.first.favorite?				# == false
	self.child_users.first.extra_favorite?	# == true
	self.child_users.favorites(false)			 # [ self.child_users.first ]
end