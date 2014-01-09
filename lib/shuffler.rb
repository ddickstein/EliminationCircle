module Shuffler
  #
  #  This function takes an array of elements and spawns a new array of a given
  #  length consisting only of shuffled elements from arr.  If length is
  #  greater than arr's length, arr is shuffled multiple times until the new
  #  array can be fully filled with its shuffled contents.
  #
  def Shuffler::shuffle_to_length(arr,length)
    shuffled_arr = []
    while (shuffled_arr.length + arr.length <= length)
      shuffled_arr += arr.shuffle
    end
    if (shuffled_arr.length < length)
      missing_length = length - shuffled_arr.length
      shuffled_arr += arr.sample(missing_length)
    end
    shuffled_arr
  end
end