Gem::Specification.new do |s|
  s.name    = 'acts_as_relationable'
  s.version = '1.0'
  s.date    = '2008-08-15'
  
  s.summary = "Quick and easy habtm :through relationships in Rails"
  s.description = "A Rails plugin that allows you to create habtm :through relationships across multiple models using using a single join table."
  
  s.author   = 'Winton Welsh'
  s.email    = 'mail@wintoni.us'
  s.homepage = 'http://github.com/winton/acts_as_relationable/wikis'
  
  s.has_rdoc = false
  s.add_dependency 'activerecord', ['>= 2.1.0']
  
  s.files = %w(generators/
    generators/acts_as_relationable/
    generators/acts_as_relationable/acts_as_relationable_generator.rb
    generators/acts_as_relationable/templates/
    generators/acts_as_relationable/templates/migrate/
    generators/acts_as_relationable/templates/migrate/add_fields_to_relationships.rb.erb
    generators/acts_as_relationable/templates/migrate/create_relationships.rb.erb
    generators/acts_as_relationable/templates/models/
    generators/acts_as_relationable/templates/models/relationship.rb
    init.rb
    lib/
    lib/acts_as_relationable.rb
    MIT-LICENSE
    README.markdown)
end
