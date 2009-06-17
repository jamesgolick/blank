module AssertForm
  # assert_form posts_url, :put do
  #   assert_text_field :post, :title
  #   assert_text_area  :post, :body
  #   assert_submit
  # end
  def assert_form(url, http_method = :post)
    http_method, hidden_http_method = form_http_method(http_method)
    assert_select "form[action=?][method=#{http_method}]", url do
      if hidden_http_method
        assert_select "input[type=hidden][name=_method][value=#{hidden_http_method}]"
      end
      if block_given?
        yield
      end
    end
  end

  def form_http_method(http_method)
    http_method = http_method.to_s
    if http_method == "post" || http_method == "get"
      return http_method, nil
    else
      return "post", http_method
    end
  end

  def assert_submit
    assert_select "input[type=submit]"
  end

  # TODO: default to test the label, provide :label => false option
  def assert_text_field(*args)
    options = args.extract_options!
    assert_select "input[type=text][name=?]", extract_name(args)
  end

  # TODO: default to test the label, provide :label => false option
  def assert_text_area(*args)
    options = args.extract_options!
    assert_select "textarea[name=?]", extract_name(args)
  end

  # TODO: default to test the label, provide :label => false option
  def assert_password_field(*args)
    options = args.extract_options!
    assert_select "input[type=password][name=?]", extract_name(args)
  end

  # TODO: default to test the label, provide :label => false option
  def assert_radio_button(*args)
    options = args.extract_options!
    assert_select "input[type=radio][name=?]", extract_name(args)
  end

  def assert_label(*args)
    options = args.extract_options!
    assert_select "label[for=?]", extract_id(args)
  end

  protected
  def extract_name(args)
    case args.length
    when 1
      args.first
    when 2
      "%s[%s]" % args
    else
      raise ArgumentError, "Expected 1 or 2 arguments, found #{args.inspect}.  Pass (:model, :attributes) or (:name)"
    end
  end

  def extract_id(args)
    case args.length
    when 1
      args.first
    when 2
      "%s_%s" % args
    else
      raise ArgumentError, "Expected 1 or 2 arguments, found #{args.inspect}.  Pass (:model, :attributes) or (:name)"
    end
  end
end

Test::Unit::TestCase.send :include, AssertForm
