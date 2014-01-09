require 'spec_helper'

describe Shuffler do
  describe 'shuffle_to_length' do
    before(:each) do
      @arr = (1..10).to_a
    end
    
    it 'should use standard shuffle when given an array of the same length' do
      shuffled_arr = Shuffler.shuffle_to_length(@arr,10)
      expect(shuffled_arr).to match_array(@arr)
    end
  
    it 'should have no element reuse when shuffling to list of smaller size' do
      6.times do # After 6 times this test has 99.9% accuracy.
        shuffled_arr = Shuffler.shuffle_to_length(@arr,5)
        expect(shuffled_arr).to match_array(shuffled_arr.uniq)
      end
    end
  
    it 'should minimize element reuse when shuffling to list of larger size' do
      shuffled_arr = Shuffler.shuffle_to_length(@arr,25)
      max_frequency = (1..10).map {|x| shuffled_arr.count(x)}.max
      expect(max_frequency).to eq(3)
    end

  end
end