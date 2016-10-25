module HousesHelper
  def operation_name operation
    return 'Seller' if operation.eql? 'S'
    return 'Rent' if operation.eql? 'R'
  end
end
