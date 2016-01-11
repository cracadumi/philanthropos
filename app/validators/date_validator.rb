class DateValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    d, m, y = value.split '/'
    valid_format = Date.valid_date? y.to_i, m.to_i, d.to_i 
    unless !(value =~ /[0-3]{1}[0-9]{1}\/[0-1]{1}[0-9]{1}\/[1-2]{1}[0-9]{3}/).nil? && valid_format 
      record.errors[attribute] << (options[:message] || "wrong date format")
    end
  end

end  