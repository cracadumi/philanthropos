class CodeValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value.size == 0 && Country[value] == nil
      record.errors[attribute] << (options[:message] || "Mauvais format de code de pays")
    end
  end

end  