module Enumerable

  #source https://stackoverflow.com/questions/10712679/flatten-a-nested-json-object
  # flatten the Enumerable if it contains nested objects, keeping the nested keys as a concatenated path
  #
  # @return [String] the flatened Enumerable
  def flatten_with_path(parent_prefix = nil)

    res = {}
    self.each_with_index do |elem, i|
      if elem.is_a?(Array)
        k, v = elem
      else
        k, v = i, elem
      end

      key = parent_prefix ? "#{parent_prefix}.#{k}" : k # assign key name for result hash

      if v.is_a? Enumerable
        res.merge!(v.flatten_with_path(key)) # recursive call to flatten child elements
      else
        res[key] = v
      end
    end

    res
  end
end