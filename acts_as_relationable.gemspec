Gem::Specification.new do |s|
  s.name    = 'acts_as_relationable'
  s.version = '1.0'
  s.date    = '2008-08-15'
  
  s.summary = "Quick and easy habtm :through relationships in Rails"
  s.description = "A Rails plugin that allows you to create habtm :through relationships across multiple models using using a single join table."
  
  s.authors  = ['Winton Welsh']
  s.email    = 'mail@wintoni.us'
  s.homepage = 'http://github.com/winton/acts_as_relationable/wikis'
  
  s.has_rdoc = true
  s.rdoc_options = ['--main', 'README.rdoc']
  s.rdoc_options << '--inline-source' << '--charset=UTF-8'
  s.extra_rdoc_files = ['README.rdoc', 'MIT-LICENSE']
  s.add_dependency 'activerecord', ['>= 2.1.0']
  
  s.files = %w(generators/acts_as_relationable/* generators/acts_as_relationable/templates/migrate/* generators/acts_as_relationable/templates/models/* init.rb lib/* MIT-LICENSE README.rdoc)
end
