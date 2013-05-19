class Sales::SalesOrderTransactionActivity < ActiveRecord::Base
  include UserStamp
  belongs_to :sales_order, :class_name => 'Sales::SalesOrder'
  before_save do
    self.user_id = self.updated_by
  end
end
