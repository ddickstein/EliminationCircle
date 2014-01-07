module GamesHelper
  def register_for_game(permalink)
    @game = Game.find_by(permalink: permalink)
    if @game.nil?
      return nil,:not_found
    elsif current_user.playing? @game
      return @game,:already_playing
    elsif @game.started?
      return @game,:already_started
    else
      gp = GameProfile.new
      gp.user = current_user
      gp.game = @game
      if gp.save
        return @game,:success
      else
        return @game,:failure
      end
    end
  end
  
  def get_game_parameters(args)
    parameter_names = ""
    parameter_name_hash = {}
    1.upto(args[:num_params].to_i) do |x|
      name = args["param#{x}-name"]
      unless name.blank?
        unless parameter_names.blank?
          parameter_names << ", "
        end
        parameter_names << name.capitalize
        parameter_name_hash[x] = name
      end
    end
  
    parameter_lists = {}
    parameter_name_hash.each_pair do |index,name|
      rows = args["param#{index}-list"].split(/[,;\n]/).map(&:strip)
      rows.keep_if {|row| row !~ /^\s*$/ } # Keep if not just whitespace
      parameter_lists[name] = rows.map(&:capitalize)
    end
    
    return parameter_names, parameter_lists
  end
end
