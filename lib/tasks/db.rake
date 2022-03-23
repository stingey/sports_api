namespace :db do
  task seed: :environment do
    sports = %w[baseball football basketball]
    sports.each do |sport|
      player_data(sport).each do |player|
        next if player['firstname'].blank?

        Player.create(
          name_brief: name_brief(sport, player),
          first_name: player['firstname'],
          last_name: player['lastname'],
          position: player['position'],
          age: player['age'],
          sport: sport
        )
      end
    end
    Player.calculate_average_position_age_difference
  end

  def player_data(sport)
    file = open("https://api.cbssports.com/fantasy/players/list?version=3.0&SPORT=#{sport}&response_format=JSON")
    json = file.read
    parsed_json = JSON.parse(json)
    parsed_json['body']['players']
  end

  def name_brief(sport, player)
    return baseball_name_brief(player) if sport == 'baseball'
    return football_name_brief(player) if sport == 'football'

    basketball_name_brief(player)
  end

  def baseball_name_brief(player)
    "#{player['firstname'].first}. #{player['lastname'].first}."
  end

  def football_name_brief(player)
    "#{player['firstname'].first}. #{player['lastname']}"
  end

  def basketball_name_brief(player)
    "#{player['firstname']} #{player['lastname'].first}."
  end
end
