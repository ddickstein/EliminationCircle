require 'spec_helper'

describe 'Routes' do
  it 'should redirect root to pages#home (GET)'
  
  it 'should have a sign in route (GET, POST)'
  
  it 'should have a sign up route (GET)'
  
  it 'should have a sign out route (DELETE)'
  
  describe User do
    it 'should not have an index route (GET)'
    
    it 'should not have a new route (GET)'
    
    it 'should have a create route (POST)'
    
    it 'should have a show route (GET)'
    
    it 'should have an edit route (GET)'
    
    it 'should have an update route (PUT)'
    
    it 'should not have a destroy route (DELETE)'
  end
  
  describe Game do
    it 'should not have an index route (GET)'
    
    it 'should have a new route (GET)'
    
    it 'should have a create route (POST)'
    
    it 'should have a show route (GET)'
    
    it 'should not have an edit route (GET)'
    
    it 'should not have an update route (PUT)'
    
    it 'should have a destroy route (DELETE)'
    
    it 'should have a register route (GET)'
    
    it 'should have a launch route (POST)'
    
    it 'should have a kill route (DELETE)'
    
    it 'should have a remove_player route (DELETE)'
  end
end