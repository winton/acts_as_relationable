module ActiveRecord
  module Acts #:nodoc:
    module Relationable #:nodoc:

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_relationable
          acts_as_activatable
          
          after_create :create_child_relationships, :nullify_relationships
          
          has_many :parent_relationships, :class_name => 'Relationship', :foreign_key => 'child_id',
                                          :conditions => [ 'relationships.child_type = ?',  self.to_s ]
          
          has_many :child_relationships, :class_name => 'Relationship', :foreign_key => 'parent_id',
                                         :conditions => [ 'relationships.parent_type = ?', self.to_s ]
          
          include ActiveRecord::Acts::Relationable::InstanceMethods
          extend  ActiveRecord::Acts::Relationable::SingletonMethods
        end
      end

      module SingletonMethods
      end

      module InstanceMethods
        def relationships
          return read_attribute(:relationships) if read_attribute(:relationships)
          
          ids_by_model = {}
          self.child_relationships.each do |child|
            ids_by_model[child.child_type] << child.child_id
            ids_by_model[child.child_type].sort { |a, b| a[0] <=> b[0] }
          end
          ids_by_model
        end
        
        def relationships=(ids_by_model)
          write_attribute :relationships, ids_by_model
        end
        
        def create_child_relationships
          return unless relationships = read_attribute(:relationships)
          
          relationships.each do |child_type, ids|
            ids.each do |child_id|
              r = Relationship.create(
                :parent       => self,
                :child_type   => child_type,
                :child_id     => child_id,
                :user_id      => self.user_id
              )
            end
          end
          
          self.child_relationships.reload
        end
        
        def nullify_relationships
          write_attribute :relationships, nil
        end
        
        def removed_relationships(old=nil, current=nil)
          unless old && current
            return read_attribute(:removed_relationships) || {}
          end
          
          removed = {}
          
          old.each do |key, value|
            unless current[key]
              removed[key] = old[key]
            else
              removed[key] = old[key] - current[key]
            end
          end
          
          write_attribute :removed_relationships, removed
        end
        
      end
    end
  end
end