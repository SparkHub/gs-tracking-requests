module Factory

  class << self

    def sequence
      yield((0..1000).to_a.sample)
    end
  end
end
