class DirtyHistoryRecord < ActiveRecord::Base
  belongs_to :creator,  :polymorphic => true
  belongs_to :object,   :polymorphic => true

  validates_presence_of :object_type, :object_id, :column_name, :column_type, :new_value

  scope :created_by,            lambda { |creator| where(["#{table_name}.creator_id = ? AND #{table_name}.creator_type = ?", creator.id, creator.class.name]) }
  scope :not_created_by,        lambda { |non_creator| where(["#{table_name}.creator_id <> ? OR #{table_name}.creator_type <> ?", non_creator.id, non_creator.class.name]) }
  scope :for_object_type,       lambda { |object_type| where(:object_type => object_type.to_s.classify) }
  scope :for_column,            lambda { |column| where(:column_name => column.to_s) }

  scope :changed_in_range,      lambda { |range| where("#{table_name}.value_changed_at >=? AND #{table_name}.value_changed_at <= ?", range.first, range.last) }
  scope :changed_at_gte,        lambda { |date|  where("#{table_name}.value_changed_at >=?", date) }
  scope :changed_at_lte,        lambda { |date|  where("#{table_name}.value_changed_at <=?", date) }

  scope :order_asc,  order("#{table_name}.value_changed_at ASC")
  scope :order_desc, order("#{table_name}.value_changed_at DESC")

  attr_accessible :object, :object_id, :object_type,
                  :column_name, :column_type, :old_value, :new_value,
                  :creator, :creator_id, :creator_type, :value_changed_at

  attr_accessor   :performing_manual_update

  before_save :set_value_changed_at

  [:new_value, :old_value].each do |attribute|
    define_method "#{attribute}" do
      val_to_col_type(attribute)
    end
    define_method "#{attribute}=" do |val|
      self[attribute] = val.nil? ? nil : val.to_s
      instance_variable_set "@#{attribute}", val
    end
  end

  private

  def val_to_col_type attribute
    val_as_string = self[attribute]
    return nil if val_as_string.nil?
    case self[:column_type].to_sym
    when :integer, :boolean
      val_as_string.to_i
    when :decimal, :float
      val_as_string.to_f
    when :datetime
      Time.parse val_as_string
    when :date
      Date.parse val_as_string
    else # :string, :text
      val_as_string
    end
  end

  def set_value_changed_at
    self[:value_changed_at] ||= self.created_at
  end

end
