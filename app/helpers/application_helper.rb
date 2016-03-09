module ApplicationHelper
    
    #prints users full name
    def full_name
         current_user.first_name.capitalize + " " + current_user.last_name.capitalize 
    end

end
