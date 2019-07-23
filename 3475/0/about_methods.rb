require File.expand_path(File.dirname(__FILE__) + '/neo')

# This method smells of :reek:UtilityFunction
# This method smells of :reek:TooManyMethods

def my_global_method(first_param, second_param)
  first_param + second_param
end

# This method smells of :reek:TooManyMethods
class AboutMethods < Neo::Koan
  def test_calling_global_methods
    assert_equal 5, my_global_method(2, 3)
  end

  def test_calling_global_methods_without_parentheses
    result = my_global_method 2, 3
    assert_equal 5, result
  end

  # (NOTE: We are Using eval below because the example code is
  # considered to be syntactically invalid).
  # rubocop:disable EvalWithLocation
  def test_sometimes_missing_parentheses_are_ambiguous
    eval "assert_equal \"my_global_method 2, 3\", 'my_global_method 2, 3'" # ENABLE CHECK
    #
    # Ruby doesn't know if you mean:
    #
    #   assert_equal(5, my_global_method(2), 3)
    # or
    #   assert_equal(5, my_global_method(2, 3))
    #
    # Rewrite the eval string to continue.
    #
  end
  # rubocop:enable EvalWithLocation

  # NOTE: wrong number of arguments is not a SYNTAX error, but a
  # runtime error.
  # This method smells of :reek:TooManyStatements
  def test_calling_global_methods_with_wrong_number_of_arguments
    exception = assert_raise(ArgumentError) do
      my_global_method
    end
    assert_match(/wrong number of arguments/, exception.message)

    exception = assert_raise(ArgumentError) do
      my_global_method(1, 2, 3)
    end
    assert_match(/wrong number of arguments/, exception.message)
  end

  # ------------------------------------------------------------------

  def method_with_defaults(first_param, second_param = :default_value)
    [first_param, second_param]
  end

  def test_calling_with_default_values
    assert_equal [1, :default_value], method_with_defaults(1)
    assert_equal [1, 2], method_with_defaults(1, 2)
  end

  # ------------------------------------------------------------------

  def method_with_var_args(*args)
    args
  end

  def test_calling_with_variable_arguments
    assert_equal Array, method_with_var_args.class
    assert_equal [], method_with_var_args
    assert_equal [:one], method_with_var_args(:one)
    assert_equal %i[one two], method_with_var_args(:one, :two)
  end

  # ------------------------------------------------------------------

  def method_with_explicit_return
    :return_value
  end

  def test_method_with_explicit_return
    assert_equal :return_value, method_with_explicit_return
  end

  # ------------------------------------------------------------------

  # rubocop:disable Void
  def method_without_explicit_return
    :a_non_return_value
    :return_value
  end
  # rubocop:enable Void

  def test_method_without_explicit_return
    assert_equal :return_value, method_without_explicit_return
  end

  # ------------------------------------------------------------------

  # This method smells of :reek:UtilityFunction
  def my_method_in_the_same_class(first_param, second_param)
    first_param * second_param
  end

  def test_calling_methods_in_same_class
    assert_equal 12, my_method_in_the_same_class(3, 4)
  end

  def test_calling_methods_in_same_class_with_explicit_receiver
    assert_equal 12, my_method_in_the_same_class(3, 4)
  end

  # ------------------------------------------------------------------

  private

  def my_private_method
    'a secret'
  end

  def test_calling_private_methods_without_receiver
    assert_equal 'a secret', my_private_method
  end

  def test_calling_private_methods_with_an_explicit_receiver
    exception = assert_raise(NoMethodError) do
      self.my_private_method # rubocop:disable Style/RedundantSelf
    end

    assert_match /#{Regexp.quote(exception.message)}/, # rubocop:disable Lint/AmbiguousRegexpLiteral
                 exception.message
  end

  # ------------------------------------------------------------------

  class Dog
    def name
      'Fido'
    end

    private

    def tail
      'tail'
    end
  end

  def test_calling_methods_in_other_objects_require_explicit_receiver
    rover = Dog.new
    assert_equal 'Fido', rover.name
  end

  def test_calling_private_methods_in_other_objects
    rover = Dog.new
    assert_raise(NoMethodError) do
      rover.tail
    end
  end
end