# Extend the Hash class to add #stringify.
class Hash

  # -> Hash
  # Returns a new hash with all of the symbols inside
  # converted into strings recursively.
  #
  def stringify
    inject({}) do |acc, (key, value)|
      acc[key.to_s] =
        case value
        when Symbol
          value.to_s
        when Hash
          value.stringify
        else
          value
        end
      acc
    end
  end
end
