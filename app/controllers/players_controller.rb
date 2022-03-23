class PlayersController < JSONAPI::ResourceController
  skip_before_action :verify_authenticity_token

  def index
    @players = Player.all
    @players = @players.where(sport: params[:sport]) if params[:sport].present?
    @players = @players.where('last_name like ?', "#{params[:first_letter_last_name]}%") if params[:first_letter_last_name].present?
    @players = @players.where(age: params[:age]) if params[:age].present? && params[:age_range].blank?
    if params[:age_range].present?
      age_range = params[:age_range].split('-')
      @players = @players.where('age BETWEEN ? AND ?', age_range.min, age_range.max )
    end
    @players = @players.where('lower(position) = ?', params[:position].downcase) if params[:position].present?

    render json: @players.to_json
  end

  def show
    @player = Player.find(params[:id])

    render json: @player.to_json
  end
end
