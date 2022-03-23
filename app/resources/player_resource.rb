class PlayerResource < JSONAPI::Resource
  attributes :name_brief, :first_name, :last_name, :position, :age, :average_position_age_diff
end
