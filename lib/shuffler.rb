module Shuffler
  def Shuffler::shuffle_to_length(arr,length)
    shuffled_arr = []
    while (shuffled_arr.length + arr.length <= length)
      shuffled_arr += arr.shuffle
    end
    if (shuffled_arr.length < length)
      missing_length = length - shuffled_arr.length
      shuffled_arr += arr.shuffle[0...missing_length]
    end
    shuffled_arr
  end
end