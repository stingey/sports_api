class Player < ApplicationRecord
  scope :baseball, -> { where(sport: 'baseball') }
  scope :football, -> { where(sport: 'football') }
  scope :basketball, -> { where(sport: 'basketball') }

  def self.calculate_average_position_age_difference
    calculate_average_position_age_difference_for_sport('baseball')
    calculate_average_position_age_difference_for_sport('football')
    calculate_average_position_age_difference_for_sport('basketball')
  end

  def self.calculate_average_position_age_difference_for_sport(sport)
    positions_for_sport(sport).each do |position|
      average = average_age_for_position_and_sport(position, sport)
      Player.where(sport: sport).where(position: position).where.not(age: nil).each do |player|
        player.update(average_position_age_diff: (average - player.age).abs)
      end
    end
  end

  def self.average_age_for_position_and_sport(position, sport)
    age_array = Player.where(sport: sport).where(position: position).pluck(:age).reject(&:blank?)
    return if age_array.blank?

    age_array.sum / age_array.size
  end

  def self.positions_for_sport(sport)
    Player.where(sport: sport).pluck(:position).uniq.reject(&:blank?).reject { |position| position == 'null' }
  end
end
