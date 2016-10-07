require 'logger'

class G2Logger < Logger

  def initialize(*args)
    super
    @formatter = G2LogFormatter.new
  end

  class G2LogFormatter < ::Logger::Formatter
    def session_info
      {session_id: 42, account_id: 84, user_id: 168}
    end
  end
end
