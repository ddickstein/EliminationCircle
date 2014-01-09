require 'spec_helper'
require 'database_cleaner'

describe Game do
  
  before(:all) do
    DatabaseCleaner.start
    @player_sheet = "First Player\nSecond Player\nThird Player"
    @parameters = "Param1, Param2"
    @param1_values = ['val1a','val1b','val1c']
    @param2_values = ['val2a','val2b','val2c']
    @parameter_lists = {
      :param1 => @param1_values,
      :param2 => @param2_values
    }
    @preregistered = Game.create!(name: 'Preregistered', user_id: 1,
                                  preregistered: true,
                                  player_sheet: @player_sheet)
  end
  
  after(:all) do
    DatabaseCleaner.clean
  end
  
  before(:each) do
    @game = Game.new(name: 'Sample Game', user_id: 1, preregistered: false)
  end
  
  context 'should not save' do
    it 'without a name' do
      @game = Game.new(user_id: 1, preregistered: false)
      expect(@game).not_to be_valid
    end
  
    it 'should not save without a user id' do
      @game = Game.new(name: 'Sample Game', preregistered: false)
      expect(@game).not_to be_valid
    end
  
    it 'without a player sheet if preregistered' do
      @game.preregistered = true
      expect(@game).not_to be_valid
      @game.player_sheet = @player_sheet
      expect(@game).to be_valid
    end
    
    it 'with an invalid player sheet' do
      @game.player_sheet = "First\nBad\nPlayer\nSheet"
      expect(@game).not_to be_valid
      @game.player_sheet = "Second Bad\nPlayer Sheet 0123456789"
      expect(@game).not_to be_valid
    end
  end
  
  context 'should save' do
    it 'without a player sheet if not preregistered' do
      @game.preregistered = false
      expect(@game).to be_valid
    end
  end
  
  context 'upon creation' do
    it 'should generate permalink upon creation' do
      @game.save
      expect(@game.permalink).to be_present
    end
  end
  
  context 'upon preregistration' do
    before(:each) do
      @game = @preregistered.dup
      @game.player_sheet = @player_sheet
    end
    
    it 'should create players' do
      @game.save
      expect(@game.players.count).to be == 3
    end
  end
  
  context 'after started' do
    before(:each) do
      @game.save
      @player_sheet.split("\n").each do |name|
        first,last = name.split(' ')
        GameProfile.create!(game: @game, first_name: first, last_name: last)
      end
    end
    
    it 'should not be able to be started again' do
      @game.save
      expect(@game).not_to be_started
      expect(@game.start).to be true
      expect(@game).to be_started
      expect(@game.start).to be false
    end
  
    it 'should create a game circle' do
      @game.start
      expect(@game.players.first.target).to_not be_nil
      cycled_target = @game.players.first.target.target.target
      expect(cycled_target).to eq(@game.players.first)
    end
  
    it 'should initialize players with params if params supplied' do
      @game.parameters = @parameters
      @game.parameter_lists = @parameter_lists
      @game.start
      combos = @parameter_lists[:param1].product(@parameter_lists[:param2])
      combos.map!{|combo| combo.join(', ')}
      @game.players.each do |player|
        expect(combos).to include(player.details)
      end
      param_sets = @game.players.map{|p| p.details.split(', ')}.transpose
      expect(param_sets[0]).to match_array(@param1_values)
      expect(param_sets[1]).to match_array(@param2_values)
    end
  end
  
  context 'upon destruction' do
    before(:each) do
      @game.save
      @player_sheet.split("\n").each do |name|
        first,last = name.split(' ')
        GameProfile.create!(game: @game, first_name: first, last_name: last)
      end
    end
    
    it 'should remove all associated players' do
      initial_count = GameProfile.where(game_id: @game.id).count
      expect(initial_count).to be > 0
      @game.destroy
      aftermath_count = GameProfile.where(game_id: @game.id).count
      expect(aftermath_count).to be == 0
    end
  end

end
