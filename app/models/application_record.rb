class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # Will automatically load schemas for each model
  # However the schema naming consistency should be kept
  validate :validate_attributes_with_schema

  private

  def validate_attributes_with_schema
    schema = load_validation_schema
    return unless schema

    result = schema.new.call(attributes.symbolize_keys)
    result.errors.each do |error|
      errors.add(error.path.first, error.text)
    end
  end

  def load_validation_schema
    schema_name = "#{self.class.name}ValidationSchema"
    return unless Object.const_defined?(schema_name)

    Object.const_get(schema_name)
  end
end
