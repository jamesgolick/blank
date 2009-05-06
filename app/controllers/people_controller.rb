class PeopleController < ResourceController::Base
  actions :new, :create
 
  create do
    before     :logout_keeping_session!
    after      { self.current_person = @person }
    flash      "Thanks for signing up!"
    wants.html { redirect_back_or_default(root_url) }
  end
end
