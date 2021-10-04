# frozen_string_literal: true

class BaseForm
  include ActiveModel::Model

  def promote_errors(error_message, options: {})
    error_message.to_a.each do |attribute, message|
      errors.add(options.fetch(:attribute, attribute), message)
    end
  end
end
