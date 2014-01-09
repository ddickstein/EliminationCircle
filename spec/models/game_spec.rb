require 'spec_helper'

describe Game do
  
  before(:each) do
    @player_sheet = "First Player\nSecond Player\nThird Player"
    @parameters = "Param1, Param2"
    @param1_values = ['val1a','val1b','val1c']
    @param2_values = ['val2a','val2b','val2c']
    @parameter_lists = {
      :param1 => @param1_values,
      :param2 => @param2_values
    }
    @game = Game.new(name: 'Sample Game', user_id: 1, preregistered: false)
  end
  
  it 'should not save without a name' do
    @game = Game.new(user_id: 1, preregistered: false)
    expect(@game).not_to be_valid
  end
  
  it 'should not save without a user id' do
    @game = Game.new(name: 'Sample Game', preregistered: false)
    expect(@game).not_to be_valid
  end
  
  it 'should not save without a player sheet if preregistered' do
    @game.preregistered = true
    expect(@game).not_to be_valid
    @game.player_sheet = @player_sheet
    expect(@game).to be_valid
  end
  
  it 'should save without a player sheet if not preregistered' do
    @game.preregistered = false
    expect(@game).to be_valid
  end
  
  it 'should not save with an invalid player sheet' do
    @game.player_sheet = "First\nBad\nPlayer\nSheet"
    expect(@game).not_to be_valid
    @game.player_sheet = "Second Bad\nPlayer Sheet 0123456789"
    expect(@game).not_to be_valid
  end
  
  it 'should generate permalink upon creation' do
    @game.save
    expect(@game.permalink).to be_present
  end
  
  it 'should create players upon game preregistration' do
    @game.preregistered = true
    @game.player_sheet = @player_sheet
    @game.save
    expect(@game.players.count).to eq(3)
  end
  
  it 'should not be able to be initialized twice' do
    @game.preregistered = true
    @game.player_sheet = @player_sheet
    expect(@game).to be_valid
    expect(@game).not_to be_started
    expect(@game).not_to be_initialized
    @game.start
    expect(@game).to be_started
    expect(@game.)to be_initialized
    
  end
  
  it ''
  
  it 'should create a game circle upon game initialization' do
    @game.preregistered = true
    @game.player_sheet = @player_sheet
    @game.save
    expect(@game.players.first.target).to_not be_nil
    expect(@game.players.first.target.target.target).to be(@game.players.first)
  end
  
  it 'should initialize players with params if params supplied' do
    @game.preregistered = true
    @game.player_sheet = @player_sheet
    @game.parameters = @parameters
    @game.parameter_lists = @parameter_lists
    @game.save
    combos = @parameter_lists[:param1].product(@parameter_lists[:param2])
    @game.players.each do |player|
      expect(combos).to include(player.details)
    end
    param_sets = @game.players.map(&:details).split(', ').transpose
    expect(param_sets[0]).to match_array(@param1_values)
    expect(param_sets[1]).to match_array(@param2_values)
  end
  
  it 'should not initialize if game is already progressing and is updated'

end
