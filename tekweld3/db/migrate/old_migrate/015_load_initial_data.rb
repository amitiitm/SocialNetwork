require 'active_record/fixtures'
class LoadInitialData < ActiveRecord::Migration
  def self.up
#    directory = File.join(File.dirname(__FILE__),"../../test/fixtures")
##    Fixtures.create_fixtures(directory, "companies")
#    Fixtures.create_fixtures(directory, "moodules")
#    Fixtures.create_fixtures(directory, "documents")
#    Fixtures.create_fixtures(directory, "menus")
##    Fixtures.create_fixtures(directory, "email_configs")
#    Fixtures.create_fixtures(directory, "roles")
#    Fixtures.create_fixtures(directory, "role_permissions")
#    Fixtures.create_fixtures(directory, "sequences")             
#    Fixtures.create_fixtures(directory, "types")     
##    Fixtures.create_fixtures(directory, "users")
##    Fixtures.create_fixtures(directory, "user_permissions")
  end

  def self.down
=begin    
    EmailConfig.delete_all
    Menu.delete_all
    Document.delete_all
    MetalParameter.delete_all
    Moodule.delete_all
    RolePermission.delete_all
    Role.delete_all
    Sequence.delete_all
    Shipping.delete_all
    StoneLot.delete_all
    StoneParameter.delete_all
    StyleCasting.delete_all
    StyleCategory.delete_all
    StyleColorstone.delete_all
    StyleDiamond.delete_all
    StyleFinding.delete_all
    StyleSpec.delete_all
    StyleUnitconversion.delete_all
    Item.delete_all
    Style.delete_all
    Term.delete_all
    UserPermission.delete_all
    User.delete_all
    VendorCategory.delete_all
    Vendor.delete_all
    CustomerCategory.delete_all
    AccountPeriod.delete_all
    AccountYear.delete_all
    Casting.delete_all
    Type.delete_all    
    CompanyStore.delete_all
    Company.delete_all
=end    
  end
end
