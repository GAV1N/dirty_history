module DirtyHistory

  module Mixin

    CreatorError = Class.new(StandardError)
    ValueChangedCallbackError = Class.new(StandardError)

    def self.included base
      base.class_eval do
        extend ClassMethods
      end
    end

    module ClassMethods

      # call the dirty_history class method on models with fields that you want to track changes on.
      # example usage:
      # class User < ActiveRecord::Base
      #   has_dirty_history :email, :first_name, :last_name
      # end

      # pass an optional proc to assign a creator to the dirty_history object
      # example usage:
      # class User < ActiveRecord::Base
      #   has_dirty_history :email, :first_name, :last_name, :creator => proc { User.current_user }
      # end

      def has_dirty_history *args
        # Mix in the module, but ensure to do so just once.
        metaclass = (class << self; self; end)
        return if metaclass.included_modules.include?(DirtyHistory::Mixin::AssetInstanceMethods)

        has_many        :dirty_history_records, :as => :asset, :dependent => :destroy
        attr_accessor   :dirty_history_changes, :initialize_dirty_history
        cattr_accessor  :dirty_history_columns


        self.dirty_history_columns ||= []

        before_save     :set_dirty_history_changes
        after_save      :save_dirty_history

        options = args.extract_options!

        args.each do |arg|
          arg = arg.to_sym
          self.dirty_history_columns << arg unless self.dirty_history_columns.include?(arg)
        end

        if creator = options.delete(:creator)
          send :define_method, "creator_for_dirty_history" do
            begin
              creator.is_a?(Proc) ? creator.call : send(creator)
            rescue
              raise DirtyHistory::Mixin::CreatorError
            end
          end
        end

        if value_changed_callback = options.delete(:value_changed_callback)
          send :define_method, "dirty_history_record_value_changed_callback" do |dhr|
            # the `value_changed_callback` is a proc or method name which
            # receives the DirtyHistoryRecord instance as an argument
            begin
              value_changed_callback.is_a?(Proc) ? value_changed_callback.call(dhr) : send(value_changed_callback, dhr)
            rescue => ex
              raise DirtyHistory::Mixin::ValueChangedCallbackError, ex.message
            end
          end
        end

        include DirtyHistory::Mixin::AssetInstanceMethods

      end # has_dirty_history

      def creates_dirty_history
        # Mix in the module, but ensure to do so just once.
        metaclass = (class << self; self; end)
        return if metaclass.included_modules.include?(DirtyHistory::Mixin::CreatorInstanceMethods)

        has_many :dirty_history_records, :as => :creator

        include DirtyHistory::Mixin::CreatorInstanceMethods
      end # creates_dirty_history
    end # ClassMethods

    module AssetInstanceMethods

      def set_dirty_history_changes
        return true unless self.new_record? || self.changed?

        self.dirty_history_changes = self.class.dirty_history_columns.inject({}) do |changes_hash, column_name|
          change = self.changes[column_name.to_s]

          if change && (change[0].present? || change[1].present?)
            changes_hash[column_name] = change
          end

          changes_hash
        end

        self.initialize_dirty_history = self.new_record?
        return true
      end

      def save_dirty_history
        return true unless self.dirty_history_changes.present?

        self.dirty_history_changes.each do |column_name,vals|
          add_dirty_history_record column_name, vals[0], vals[1], :creator => self.creator_for_dirty_history
        end

        self.dirty_history_changes = nil

        return true
      end

      def add_dirty_history_record column_name, old_value, new_value, options={}
        creator = options[:creator] || self.creator_for_dirty_history

        dhr_attributes = {
          :asset        => self,
          :column_name  => column_name,
          :column_type  => self.class.columns_hash[column_name.to_s].type,
          :old_value    => old_value,
          :new_value    => new_value,
          :creator      => creator
        }

        dhr = DirtyHistoryRecord.new(dhr_attributes)

        # attributes for manual updates
        [:value_changed_at, :performing_manual_update].each do |attribute|
          dhr.send("#{attribute}=", options[attribute]) if options[attribute]
        end

        self.dirty_history_records << dhr
      end

      def history_for_column column, options={}
        options[:sort] = true if options[:sort].blank?

        records = dirty_history_records.for_column(column)
        records = records.send(*options[:scope]) if options[:scope]
        records = records.order_asc if options[:sort]

        options[:return_objects] ? records : records.map { |s| s.new_value }
      end

    end # AssetInstanceMethods

    module CreatorInstanceMethods

    end # CreatorInstanceMethods

  end # Mixin

end # DirtyHistory
