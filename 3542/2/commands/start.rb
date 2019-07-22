require './validations/validations'

module Start
  include Validations
  include Validations::Registration

  def start!(*)
    if registered?
      respond_with :message, text: 'You are already registered.'
    else
      save_context :number_set
      respond_with :message, text: 'Hello! Give me your personal number.'
    end
  end

  def number_set(number)
    if Student.new(number, self).valid_number?
      chat_session[session_key] ||= {}
      chat_session[session_key]['number'] ||= number
      respond_with :message, text: 'Success! Registration completed.'
    else
      save_context :number_set
      respond_with :message, text: 'Wrong number. Try again.'
    end
  end
end
