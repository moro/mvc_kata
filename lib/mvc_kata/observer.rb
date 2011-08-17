module MvcKata
  module Observer
    def update(method, *values)
      return false unless respond_to?(method)
      send(method, *values)
    end
  end
end
