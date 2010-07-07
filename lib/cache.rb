module ActiveRecord
  class Base
    def cache_key
      "#{self.class.to_s.tableize}[#{id}]"
    end
  end
end

class Cache

  class << self

    def read(key, &block)
      if (value = self[key]).nil? and block_given?
        value = block.call
        self[key] = value
      end
      return value
    end

    def [](key)
      Rails.cache.read(key)
    end

    def []=(key, value)
      Rails.cache.write(key, value)
    end

    def clear(key)
      Rails.cache.delete(key)
    end

  end

end