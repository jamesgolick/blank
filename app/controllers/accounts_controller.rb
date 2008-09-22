class AccountsController < ResourceController::Singleton
  before_filter :login_from_password_reset_code, :login_required
  
  actions       :edit, :update
  model_name    :person
  object_name   :person
  
  protected
    def object
      @object ||= current_person
    end
    
    def login_from_password_reset_code
      p = Person.find_by_valid_password_reset_code(params[:password_reset_code])
      
      unless p.nil?
        p.expire_password_reset_code
        self.current_person = p
        flash[:notice]      = "You have been logged in. Please reset your password."
      end
    end
end
