module UsersHelper
  def strip_mobile(mobile)
    area = mobile[3..5]
    num1 = mobile[8..10]
    num2 = mobile[14..17]
    "1#{area}#{num1}#{num2}"
  end
end
