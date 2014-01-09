require 'spec_helper'
require 'database_cleaner'

describe User do
  before(:each) do
    DatabaseCleaner.start
    @saved_user = User.create!(name: 'sample user', email: 'user1@sample.com',
                         password: 'foobar', password_confirmation: 'foobar',
                         mobile: '2125551234')
    @valid_user = User.new(name: 'sample user', email: 'user2@sample.com',
                           password: 'foobar', password_confirmation: 'foobar',
                           mobile: '2125551235')
  end
  
  after(:each) do
    DatabaseCleaner.clean
  end
  
  context 'before saving' do
    it 'should nicely reformat mobile number' do
      expect(@saved_user.mobile).to match /^1 \(\d\d\d\) \d\d\d - \d\d\d\d$/
    end
  
    it 'should nicely reformat name' do 
      expect(@saved_user.full_name).to eq('Sample User')
    end
  end
  
  context 'should not save' do
    it 'with a bad mobile format'
  end
  
  it 'should have full_name method which combines first and last names'
  
  context 'when playing a game' do
    it 'should be considered playing? if game creator'
  
    it 'should be considered playing? if has a matching GameProfile'
  
    it 'should not be considered playing? if not the creator and does not ' +
       'have a matching GameProfile'
  end
  
  context 'upon destruction' do
    it 'should destroy all games it created'
    
    it 'should not destroy any of its GameProfiles'
  end
  
end
