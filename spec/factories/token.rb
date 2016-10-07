module Factory

  class << self

    def token
      SecureRandom.hex(20)
    end
  end
end
