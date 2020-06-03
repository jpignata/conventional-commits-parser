class Footer
  def initialize
    @attributes = {}
    @keys = {}
  end

  def []=(key, value)
    attributes[key] = value
    keys[key.downcase] = key
  end

  def [](key)
    if has_key?(key)
      attributes[keys[key.downcase]]
    end
  end

  def size
    keys.size
  end

  def empty?
    keys.empty?
  end

  def has_key?(key)
    keys.key?(key.downcase)
  end

  private

  attr_accessor :attributes, :keys
end
