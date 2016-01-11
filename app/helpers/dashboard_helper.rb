module DashboardHelper

  def gender_code gender
     if gender == "homme"
        return "1"
     else
        return "2"
     end 
  end

end
