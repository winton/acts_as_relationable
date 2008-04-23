class ActsAsRelationableGenerator < Rails::Generator::Base 
  def manifest
    args.collect! { |arg| arg.split ':' }
    record do |m|
      if args.empty?
        m.file "models/relationship.rb", "app/models/relationship.rb"
        m.migration_template 'migrate/create_relationships.rb.erb', 'db/migrate', :migration_file_name => 'create_relationships'
      else
        m.migration_template 'migrate/add_fields_to_relationships.rb.erb', 'db/migrate', :migration_file_name => 'add_' + args.collect { |a| a[0] }.join('_and_') + '_to_relationships'
      end
    end 
  end
end