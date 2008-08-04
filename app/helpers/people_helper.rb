module PeopleHelper
  
  #
  # Use this to wrap view elements that the user can't access.
  # !! Note: this is an *interface*, not *security* feature !!
  # You need to do all access control at the controller level.
  #
  # Example:
  # <%= if_authorized?(:index,   User)  do link_to('List all users', users_path) end %> |
  # <%= if_authorized?(:edit,    @user) do link_to('Edit this user', edit_user_path) end %> |
  # <%= if_authorized?(:destroy, @user) do link_to 'Destroy', @user, :confirm => 'Are you sure?', :method => :delete end %> 
  #
  #
  def if_authorized?(action, resource, &block)
    if authorized?(action, resource)
      yield action, resource
    end
  end

  #
  # Link to user's page ('people/1')
  #
  # By default, their login is used as link text and link title (tooltip)
  #
  # Takes options
  # * :content_text => 'Content text in place of person.login', escaped with
  #   the standard h() function.
  # * :content_method => :person_instance_method_to_call_for_content_text
  # * :title_method => :person_instance_method_to_call_for_title_attribute
  # * as well as link_to()'s standard options
  #
  # Examples:
  #   link_to_person @person
  #   # => <a href="/people/3" title="barmy">barmy</a>
  #
  #   # if you've added a .name attribute:
  #  content_tag :span, :class => :vcard do
  #    (link_to_person person, :class => 'fn n', :title_method => :login, :content_method => :name) +
  #          ': ' + (content_tag :span, person.email, :class => 'email')
  #   end
  #   # => <span class="vcard"><a href="/people/3" title="barmy" class="fn n">Cyril Fotheringay-Phipps</a>: <span class="email">barmy@blandings.com</span></span>
  #
  #   link_to_person @person, :content_text => 'Your user page'
  #   # => <a href="/people/3" title="barmy" class="nickname">Your user page</a>
  #
  def link_to_person(person, options={})
    raise "Invalid person" unless person
    options.reverse_merge! :content_method => :login, :title_method => :login, :class => :nickname
    content_text      = options.delete(:content_text)
    content_text    ||= person.send(options.delete(:content_method))
    options[:title] ||= person.send(options.delete(:title_method))
    link_to h(content_text), person_path(person), options
  end

  #
  # Link to login page using remote ip address as link content
  #
  # The :title (and thus, tooltip) is set to the IP address 
  #
  # Examples:
  #   link_to_login_with_IP
  #   # => <a href="/login" title="169.69.69.69">169.69.69.69</a>
  #
  #   link_to_login_with_IP :content_text => 'not signed in'
  #   # => <a href="/login" title="169.69.69.69">not signed in</a>
  #
  def link_to_login_with_IP content_text=nil, options={}
    ip_addr           = request.remote_ip
    content_text    ||= ip_addr
    options.reverse_merge! :title => ip_addr
    if tag = options.delete(:tag)
      content_tag tag, h(content_text), options
    else
      link_to h(content_text), login_path, options
    end
  end

  #
  # Link to the current user's page (using link_to_person) or to the login page
  # (using link_to_login_with_IP).
  #
  def link_to_current_person(options={})
    if current_person
      link_to_person current_person, options
    else
      content_text = options.delete(:content_text) || 'not signed in'
      # kill ignored options from link_to_person
      [:content_method, :title_method].each{|opt| options.delete(opt)} 
      link_to_login_with_IP content_text, options
    end
  end

end
