module MobileConcern
  extend ActiveSupport::Concern
  
  PHONE_REGEX = /\A(?:1\s*-?\s*)?(?<area>\([2-9]\d\d\)|[2-9]\d\d)\s*-?\s*
                (?<num1>\d\d\d)\s*-?\s*(?<num2>\d\d\d\d)\z/x
  
  included do
    validates :mobile, :format => { :with => PHONE_REGEX }
    before_save :reformat_mobile_number
  end
  
  private
    def reformat_mobile_number
      area, num1, num2 = PHONE_REGEX.match(self.mobile).to_a[1..3]
      if area =~ /\([2-9]\d\d\)/
        self.mobile = "1 #{area} #{num1} - #{num2}"
      else
        self.mobile = "1 (#{area}) #{num1} - #{num2}"
      end
    end
  
end