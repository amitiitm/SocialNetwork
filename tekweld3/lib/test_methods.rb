
module TestMethods
  def test_schema
   return ActiveRecord::Base.configurations[RAILS_ENV]['schema']
  end
end
