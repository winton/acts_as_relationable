acts_as_relationable
====================

Automatically creates habtm :through relationships across multiple models using using a single join table.


Features
--------

* Can be self referential
* Quickly define relationship-specific fields
* Create relationships between STI models


Install
-------

	gem install winton-acts_as_relationable

### Add to `environment.rb`

	config.gem 'winton-acts_as_relationable', :lib => 'acts_as_relationable', :source => 'http://gems.github.com'

### From your application directory

	script/generate acts_as_relationable
	rake db:migrate


Usage
-----

[Check out the wiki](http://github.com/winton/acts_as_relationable/wikis) for usage examples.


##### Copyright &copy; 2008 [Winton Welsh](mailto:mail@wintoni.us)