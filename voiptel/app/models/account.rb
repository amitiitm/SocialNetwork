class Account < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  
  #simple comment
  has_many :users, :dependent => :destroy
  has_many :phones
  has_many :phone_books
  has_many :account_dids
  has_many :assigned_dids
  has_many :cdrs
  has_many :transaction_references
  has_many :order_transactions
  has_many :orders
  has_many :referrals, :foreign_key => "referrer_account_id"
  has_many :credits
  has_many :follow_ups
  has_many :memos, :as => :memoable
  has_many :acc_dids, :class_name => "AccDid"
  has_many :dids, :through => :acc_dids
  has_many :vm_boxes
  has_many :recordings
  has_many :enpoints
  has_many :account_endpoints
  has_many :endpoints, :through => :account_endpoints
  has_many :cached_deposits, :class_name => "CachedDeposits"
  has_many :cached_account_cdrs
  has_many :cached_account_country_cdrs
  has_many :promotions, :class_name => "AccountPromotion"  
  has_many :notifications, :as => :emailable
  has_many :voice_testimonials, :as => :customer  
  has_many :forwardings
  has_many :forwarding_dids, :through => :forwardings, :class_name => "did"
  has_many :tmp_credit_card_infos  
  has_many :sip_accounts
  
  belongs_to :signed_up_by, :polymorphic => true
  
  

  accepts_nested_attributes_for :users
  
  named_scope :active, :conditions => {:status => 1}
  
  validates_uniqueness_of :short_name, :message => "Account Identifier can't be duplicate", :allow_nil => true
  validate  :presence_of_short_name

  attr_accessor :additional_minutes, :send_welcome_email, :final_dids_hash, :note, :admin_user_id, :watch_balance_update
  
#  before_update :check_for_credit
#  before_save   :check_account_identifier
  before_save   :check_account_type
  before_save   :check_auto_recharge
  before_save   :check_short_name
  before_create :set_default_account_settings
  after_create  :set_account_promotions
  
  ## liquid stuff
  liquid_methods :number, :registration_date
    
  STATUS = [
    ['Active', 1],
    ['Inactive', 2],
    ['Close Account', 3],
    ['Fraud', 4],
  ]
  
  TYPES = [
    ["Personal", 1],
    ["Business", 2]
  ]
  
  SEARCH_TYPES = [
    #['Account Number', 1],
    ['Phone Number', 2],
    ['Account Number', 1]
  ]
  
  def user
    account_holder
  end
  
  def registration_date
    self.created_at
  end
  
  def info
    name
  end
  
	def is_fraud?(n)
		a = Account.find(n, :select => "status")
		logger.info { "--------------- STATUS: #{a.status}" }
		a.status == 4
	end
	
	def to_s
    "account"
  end
  
  def referred_by
    r = Referral.find(:first, :conditions => {:referred_account_id => self.id})
    if r
      if r.referrer_account_id
        Account.find(r.referrer_account_id)
      end
    else
      nil
    end
  end

  def account_holder
    User.find(self.account_holder_id)
  end
  
  def send_welcome_email
    for user in users
      user.send_welcome_email
      sleep(1)
    end
  end
  
  def send_update_email
    for user in users
      user.send_update_email
      sleep(1)
    end
  end
  
  def has_credit_card?
    !self.transaction_references.blank?
  end
  
  def set_default_account_settings
    self.announce_call_limit = true
  end
  
  def charge(amount)
    return false if amount.blank?
    amount = amount.to_i
    # tax stuff
    product_tax = ProductTax.find(:first, :conditions => {:product_code => "access_connect", :enabled => true})
    tax = 0
    if product_tax
      tax = product_tax.total_tax * amount
    end
    
    self.transaction_references.find(:all, :order => "updated_at desc").each do |tr|  
      order = Order.new
      order.account_id = self.id
      order.user_id = account_holder_id
      order.amount = amount
      order.purchase_by_reference(tr, tax, OrderTransaction::IVR )
      order.save
      if order.order_transaction.success
        self.status = 1
        self.balance += amount
        self.deposits += amount
        self.last_deposit_amount = amount
        self.last_deposit_date = Time.now.utc
        save
        return true
      end
    end
    return false
  end
  
  def name
    name = "ERR"
    if self.account_type == 1
      if self.account_holder_id
        name = User.find(self.account_holder_id).name
      end
    else
      name = self.business_name
    end
  end
  
  def assign_dids
      phones.each do |phone|
          PhoneDidHandler.process_new_phone phone
      end
#    # first assign dids in Home && Work phones
#    dids_hash = Hash.new
#    phones_hash = Hash.new
#    home_and_work_phones = phones.find(:all, :conditions => ["phone_type = ? or phone_type = ?", Phone::HOME, Phone::WORK])
#    for phone in home_and_work_phones      
#      unless phone.assigned_did
#        puts "#{phone.number} does not have assigned_did"      
#        unless phones_hash["#{phone.id}"]
#          phones_hash["#{phone.id}"] = phone
#        end
#        ## check to see if there are dids associated with this account with same area_code
#        account_dids = AccountDid.find_by_account_and_area_code(phone.account, phone.area_code)
#        if account_dids.size > 0
#          max = 0
#          best_choice = nil
#          for account_did in account_dids
#            if (account_did.assigned_dids.size > max) && (account_did.did.can_be_used_with?(phone))
#              max = account_did.assigned_dids.size
#              best_choice = account_did.did
#            end
#          end
#          if best_choice            
#            phone.assign_did(best_choice)
#            break
#          end
#        end
#        dids = Did.available_dids(AreaCode.find(:first, :conditions => {:area_code => phone.area_code}))        
#        ##        
#        for did in dids
#          puts "Trying #{did.number} with #{phone.number}"
#          if did.can_be_used_with?(phone)
#            puts "Found match: #{did.number}"
#            unless dids_hash["#{did.id}"]
#              dids_hash["#{did.id}"] = {:did => did, :phones => []}
#            end          
#            dids_hash["#{did.id}"][:phones] << {:phone => phone, :distance => did.can_be_used_with?(phone)}          
#          else
#            puts "Cannot use #{did.number} with #{phone.number}"
#          end
#        end
#      else
#        #puts "Phone #{phone.complete_phone_number} is already assiged to #{phone.assigned_did.did.number}"  
#      end      
#    end
#    self.final_dids_hash = Hash.new
#    # Deleting jingoolans
#    dids_hash.each_key do |key|
#      #puts "deleting #{dids_hash[key]}"
#      dids_hash.delete(key) if dids_hash[key][:phones].size == 0
#    end
#    
#    if home_and_work_phones.size > 0
#      while((dids_hash = did_groups(dids_hash)).size > 0)
#        #little magic ;-)
#      end
#      # DID Assignment
#      if final_dids_hash.size > 0
#        final_dids_hash.each_key do |key|
#	  if final_dids_hash[key] and final_dids_hash[key][:did]
#          	did = final_dids_hash[key][:did]
#          	final_dids_hash[key][:phones].each do |phone|
#          	  phone[:phone].assign_did(did)
#          	  # deleting the phone from the list dude ;-)
#          	  phones_hash.delete(phone[:phone].id.to_s)
#          	end
#	  end
#        end
#      end
#    end
#    # Assign the rest of the phones
#    puts "-------------- First methods did not work ;-)"
#    phones_hash.each_key do |key|
#      puts "Trying: #{phones_hash[key].number}"
#      assign_nearest_did_to(phones_hash[key])
#    end
#    # Assiging mobiles
#    #now it's time to assign phone to mobiles
#    puts "------------------------------- Assiging mobiles:"
#    assign_did_to_mobiles
#    nil
  end
  
  def holder
    User.find(self.account_holder_id)
  end
  
  def referral_accounts
    aids = []
    self.referrals.each do |r|
      aids << r.referred_account_id
    end
    Account.find(aids)
  end
  
  def self.find_without_memo(memo_type = nil)
    find_memo_also = (memo_type) ? (" and m.memo_type_id = '#{memo_type}'") : ""
    join = "LEFT OUTER JOIN memos m ON #{table_name}.id = m.memoable_id and m.memoable_type = '#{self.to_s}'#{find_memo_also}"
    find(:all, :select => "#{table_name}.*", :joins => join, :conditions => "m.id IS NULL")
  end
  
  def self.find_auto_recharge(memo_type = nil)
    find_memo_also = (memo_type) ? (" and m.memo_type_id = '#{memo_type}'") : ""
    join = "LEFT OUTER JOIN memos m ON #{table_name}.id = m.memoable_id and m.memoable_type = '#{self.to_s}'#{find_memo_also}"
    find(:all, :select => "#{table_name}.*", :joins => join, :conditions => "m.id IS NULL")
  end
  
  def increment_cached_deposits(amount, date = Time.now)
    CachedDeposits.increment(:account => self, :amount => amount, :date => date)
  end
  
  def set_account_promotions
    Promotion.find(:all, :conditions => {:promotion_type => 1}).each do |p|
      attrs = p.attributes
      attrs.delete("promotion_type")
      ap = AccountPromotion.new(attrs)
      ap.created_at = self.created_at
      ap.updated_at = self.created_at
      self.promotions << ap
    end
  end
  
  def select_options_for_contactable
    self.users.map {|u| [u.full_name, u.id]}
  end
  
  def select_options_for_contactable_number(contactable_id)
    if contactable_id
      phones = self.users.find(contactable_id).phones
    else
      phones = self.account_holder.phones
    end
    phones.map { |p| ["#{number_to_phone(p.number, :area_code => true)} (#{p.type_name_short})", p.id] }
  end
  
  def args_for_call_link(contactable_id, memo, admin_user)
    args = {}
    args['contactable_type'] = "User"
    unless contactable_id
      contactable_id = self.account_holder.id
    end
    args['contactable_id'] = contactable_id
    args['ext'] = admin_user.ext
    args['admin_user_id'] = admin_user.id
    args['cid'] = "19493257005"
    args['memo_id'] = memo.id
    args.to_param.gsub("&", "|")
  end
  
  private
  
  def assign_did_to_mobiles
    mobile_phones = phones.find(:all, :conditions => ["phone_type = ?", Phone::MOBILE])
    if mobile_phones.size > 0
      for mobile in mobile_phones
        unless mobile.assigned_did
          puts "Phone #{mobile.number} does not have assigned_did"      
          account_dids = AccountDid.find_by_account_and_area_code(mobile.account, mobile.area_code)
          if account_dids.size > 0
            max = 0
            best_choice = nil
            for account_did in account_dids
              if account_did.assigned_dids.size > max and account_did.did.active
                max = account_did.assigned_dids.size
                best_choice = account_did.did
              end
            end
            if best_choice
              mobile.assign_did(best_choice)
            else
              assign_nearest_did_to(mobile)
            end
          else
            assign_nearest_did_to(mobile)
          end
        else
          puts "Mobile #{mobile.complete_phone_number} is already assiged to #{mobile.assigned_did.did.number}"
        end
      end
    end
  end
  
  def did_groups(hash)
    # find the largest jingoolans    
    max = 0
    k = ""
    hash.each_key do |key|
      if max < hash[key][:phones].size
        max = hash[key][:phones].size
        k = key
      end 
    end
    self.final_dids_hash[k] = hash[k]
    delete_dups(hash, k)
  end

  def delete_dups(hash, k)
    keep = hash[k]
    hash.delete(k)
    hash.each_key do |key|
      phones = hash[key][:phones]
      phones.delete_if do |phone|
        return_value = false
        for kept_phone in keep[:phones]
          return_value = true if kept_phone[:phone].id == phone[:phone].id
        end
        return_value
      end
      if phones.size <= 1
        puts "deleting #{key}"
        hash.delete(key)      
      end    
    end
    hash
  end
  
  # def assign_nearest_did_to(phone)    
  #   puts "------------------------------"
  #   locations = sorted_did_locations_for(phone)
  #   puts "Locations size: #{locations.size}"
  #   locations.each do |location|
  #     puts "#{location.distance_to(phone.lat_long)} npa = #{location.npa}"      
  #     puts "Phone RC: #{phone.area_code_info.ratecenter} location: #{location.area_code_info.ratecenter}"
  #     if phone.area_code_info.ratecenter != location.area_code_info.ratecenter
  #       puts "why the hell it says this?"
  #       if (location.distance_to(phone.lat_long) > 11.9) && (phone.phone_type != Phone::MOBILE)
  #         puts "i'm not doing anything! #{location.distance_to(phone.lat_long)}"
  #         return
  #       end
  #     end
  #     dids = Did.find(:all, :conditions => {:did_rate_center_location_id => location.id, :active => true})
  #     puts "dids.size =  #{dids.size} for #{location.distance_to(phone.lat_long)}"
  #     for did in dids
  #       puts "DID CHOICE: #{did.number}"        
  #       phone.assign_did(did)
  #       # DID has been assigned, time to return ;-)
  #       return
  #     end
  #   end
  # end
  
  def assign_nearest_did_to(phone)
    # first try to match by rate center
    unless phone.area_code_info
        puts "No Area code found"
      return
    end
    did = Did.find(:first, :joins => :area_code_info, :conditions =>
    {
      :active => true,
      :did_type => Did::CALLING_CARD,
      :area_code => phone.area_code,
      :area_code_infos => {:ratecenter => phone.area_code_info.ratecenter}
    })
    
    if did
      phone.assign_did(did)
      return
    else
      # now go based on distance
      did = nearest_did(phone)      
      if did
        puts "Found did"
        phone.assign_did(did)
      else
        puts "Could not find did dudes"
      end      
    end   
  end
    
  def nearest_did(phone)
    dids = Did.find(:all, :conditions => {:active => true, :did_type => Did::CALLING_CARD, :area_code => phone.area_code})
    puts "Dids size: #{dids.size}"
    min_distance = nil
    selected_did = nil
    dids.each do |did|
      next unless did.area_code_info
      unless min_distance
        puts "DID: #{did.number}"
        min_distance = did.area_code_info.distance_to(phone.area_code_info)
        selected_did = did        
      else        
        if did.area_code_info
          distance = did.area_code_info.distance_to(phone.area_code_info)
        else
          distance = 10000
        end
        if distance < min_distance
          min_distance = distance
          selected_did = did
        end
      end
      puts "Min distance: #{min_distance}"
    end
    
    if selected_did
      puts "Selected did: #{selected_did.number}"
      #if min_distance < 11.9 or phone.phone_type == Phone::MOBILE
      if min_distance < 9 or phone.phone_type == Phone::MOBILE
        return selected_did
      end
    end

    return nil
  end
  
  def add_minutes
    self.minutes += self.additional_minutes.to_i
  end
  
  def check_account_type
    if self.account_type == 1
      self.business_name = ""      
    end
  end
  
  def check_auto_recharge
    unless self.auto_recharge
      self.threshold = 0
      self.recharge_amount = 0
    end
  end
  
  def check_short_name
    if self.account_type != 2
      if not self.short_name.blank?
        self.short_name = nil
      end
    end
  end
  
  def presence_of_short_name
    if self.account_type == 2
      if self.short_name.blank?
        self.errors.add(:short_name, "Account Identifier can't be blank, WTF!!!")
      end
    else
      logger.info { "--------------- SETING SHORT NAME TO NULL" }
      self.short_name = nil
    end
  end 
  
  DEPOSIT_AMOUNTS = [
    ["10",10 ],
    ["15",15 ],
    ["20",20 ],
    ["25",25 ],
    ["30",30 ],
    ["35",35 ],
    ["40",40 ],
    ["45",45 ],
    ["50",50 ],
    ["55",55 ],
    ["60",60 ],
    ["65",65 ],
    ["70",70 ],
    ["75",75 ],
    ["80",80 ],
    ["85",85 ],
    ["90",90 ],
    ["95",95 ],
    ["100",100 ]
  ]   
end
