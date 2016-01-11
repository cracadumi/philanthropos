class NameValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless (value =~ /\A[^0-9`!@#\$%\^&*+_=]+\z/).nil?
      record.errors[attribute] << (options[:message] || "Format invalide de nom")
    end
  end

end  