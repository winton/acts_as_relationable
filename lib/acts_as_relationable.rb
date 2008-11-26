module AppTower
  module ActsAsRelationable
    
    MODELS = Dir[RAILS_ROOT + "/app/models/*.rb"].collect { |f| File.basename f, '.rb' }
    
    def self.included(base)
      base.extend ActMethods
    end
    
    module ActMethods
      def acts_as_relationable(*types)
        if types.empty? # Relationship model
          belongs_to :parent, :polymorphic => true
          belongs_to :child,  :polymorphic => true

          MODELS.each do |m|
            belongs_to "parent_#{m}".intern, :foreign_key => 'parent_id', :class_name => m.camelize
            belongs_to "child_#{m}".intern,  :foreign_key => 'child_id',  :class_name => m.camelize
          end
        else
          options = types.extract_options!
          sql     = options[:conditions]
          table   = options[:table]
          fields  = options[:fields] || []
          fields  = [ fields ] unless fields.respond_to?(:flatten)

          has_many :parent_relationships, :class_name => 'Relationship', :as => :child
          has_many :child_relationships,  :class_name => 'Relationship', :as => :parent

          types.each do |type|
            type   = type.to_s
            table  = table || type
            select = "#{table}.*, relationships.id AS relationship_id#{fields.empty? ? '' : ', '}" + fields.collect { |f| "relationships.#{f}" }.join(', ')

            has_many 'parent_' + type,
              :select => select,  :conditions => sql,           :through     => :parent_relationships,
              :source => :parent, :class_name => type.classify, :source_type => table.classify do
                fields.each do |field|
                  define_method field.to_s.pluralize do |*args|
                    value = args[0] || 1
                    find :all, :conditions => [ "relationships.#{field} = ?", value ]
                  end
                end
              end

            has_many 'child_' + type,
              :select => select,  :conditions => sql,           :through     => :child_relationships,
              :source => :child,  :class_name => type.classify, :source_type => table.classify do
                fields.each do |field|
                  define_method field.to_s.pluralize do |*args|
                    value = args[0] || 1
                    find :all, :conditions => [ "relationships.#{field} = ?", value ]
                  end
                end
              end

            self.class_eval do
              # Records reader
              define_method type do |*args|
                if (read_attribute(:type) || self.class.to_s) < (args.empty? ? type.classify : args[0].to_s)
                  eval "self.child_#{type}"
                else
                  eval "self.parent_#{type}"
                end
              end
            end
            
            fields.each do |field|
              # Relationship field writer
              self.class_eval do
                define_method field.to_s + '=' do |value|
                  modified = read_attribute(:modified_relationship_fields) || []
                  modified << field
                  write_attribute :modified_relationship_fields, modified.uniq
                  write_attribute field, value
                end
              end
            end
          end
          unless included_modules.include? InstanceMethods
            extend ClassMethods
            include InstanceMethods
            before_save :save_relationship_fields
          end
        end
      end
    end
    
    module ClassMethods
    end
    
    module InstanceMethods
      # Before save
      def save_relationship_fields
        return unless read_attribute(:relationship_id) && read_attribute(:modified_relationship_fields)
        r = Relationship.find self.relationship_id
        read_attribute(:modified_relationship_fields).each do |field|
          r[field] = self[field]
        end
        r.save
        write_attribute :modified_relationship_fields, nil
      end
    end
  end
end