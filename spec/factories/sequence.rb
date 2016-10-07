module Factory

  class << self

    def sequence
      yield(rand(1000))
    end
  end
end
