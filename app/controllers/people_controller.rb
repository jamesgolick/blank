class PeopleController < ResourceController::Base
  actions :new, :create
 
  create do
    before     :logout_keeping_session!
    after      { self.current_person = @person }
    flash      "Thanks for signing up!"
    wants.html { redirect_back_or_default(root_url) }
  end

  def signup_with_open_id 
    authenticate_with_open_id do |result, identity_url|
      @person = Person.new(params[:person])
      @person.open_id_url = identity_url

      @person.open_id_url_authenticated = true if result.successful?
      @person.open_id_url_message       = result.message

      if @person.save
        self.current_person = @person
        redirect_back_or_default(root_url)
      else
        render :action => 'new'
      end
    end
  end
end
