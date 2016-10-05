module Factory

  class << self

    def token
      [*'0'..'9', *'a'..'z', *'A'..'Z'].sample(40).join
    end
  end
end
