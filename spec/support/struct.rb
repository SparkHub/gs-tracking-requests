class Struct
  def self.new_singleton(name, *fields)
    if Struct::const_defined?(name)
      Struct.const_get(name)
    else
      Struct.new(name, *fields)
    end
  end
end
