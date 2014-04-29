# Extend OpenStruct to add #stringify_values.
class OpenStruct

  # -> OpenStruct
  # Returns a new OpenStruct where symbol values are converted
  # into strings.
  #
  def stringify_values
    OpenStruct.new(marshal_dump.stringify)
  end
end
