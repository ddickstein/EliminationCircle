require 'spec_helper'

describe User do
  before(:each) do
    @user = User.create!(name: 'sample user', email: 'user1@sample.com',
                         password: 'foobar', password_confirmation: 'foobar',
                         mobile: '2125551234')
  end
  
  it 'should nicely reformat mobile number' do
    expect(@user.mobile).to match /^1 \(\d\d\d\) \d\d\d - \d\d\d\d$/
  end
  
  it 'should nicely reformat name' do 
    expect(@user.full_name).to eq('Sample User')
  end
end
