ActionController::Routing::Routes.draw do |map|
  map.resources :product_taxes

  map.resources :sip_domains

  map.resources :rate_plans

  map.resources :ivrs, :collection => {:tree => :get}

  map.resources :forwardings

  map.resources :voice_testimonials

  map.resource :etisal_live_console, :controller => "etisal_live_console"
  
  map.resources :etisal_apps

  map.resources :notifications, :collection => {:view => :get}
  
  map.resources :general_templates
  map.root :controller => :accounts
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  
  map.signup '/signup', :controller => 'admin_users', :action => 'new'
  map.hello ':name', :controller => "hello", :action => "show", :requirements => {:name => /Hello.*/}
  
  map.resources :providers
  map.resources :server_settings
  map.resources :admin_users, :collection => {:settings => :get, :df => :get}
  map.resources :carriers, :collection => {:archive => :put} do |carrier|
    carrier.resources :endpoints, :controller => "carriers/endpoints"
    carrier.resources :trunks, :controller => "carriers/trunks" do |trunk|
      trunk.resources :rate_sheets, :controller => "carriers/trunks/rate_sheets", :collection => {:upload => :post, :process => :get } do |rs|
        rs.resource :process_sheet, :controller => "carriers/trunks/rate_sheets/process_sheet"
        rs.resources :rate_sheet_files, :controller => "carriers/trunks/rate_sheets/rate_sheet_files"
      end
    end
    carrier.resources :rate_sheets, :controller => "carriers/rate_sheets"
  end
  map.resources :memo_types, :collection => {:select_category => :get}
  map.resources :store_cdrs
  map.resources :memos, :collection => {:all => :get, :batch_assign => :post, :batch_create => :post, :reassign => :get, :contactable_numbers => :get}
  map.resources :assign_memos, :collection => {:leads => :get, :accounts => :get, :cards => :get}
  
  map.resources :zones, :collection => {:batch_view => :get, :delete_all => :post, :save_all => :post} do |zones|
    zones.resources :routes, :controller => "zones/routes"
  end
  
  map.resource :db_status, :controller => "db_status"
  
  map.resources :pbx_cdrs, :collection => {:inbound =>:get, :outbound =>:get, :recording => :get,:voicemail => :get}
  
  map.resources :creditcards_by_customer
  map.resources :failed_creditcards
  map.resources :advanced_credits
  map.resources :missing_lans
  
  map.resources :memo_updates
  map.resources :servers
  map.resource :session
  map.resources :cdrs, :collection => {:etisal_logs => :get}
  map.resources :testimonials, :collection => {:load => :get}
  map.resources :credits
  map.resources :orders, :collection => {:log => :get, :void => :get, :do_void => :get, :get_transactions => :get}
  map.resources :uploads
  map.resources :files
  map.resources :jobs, :collection => {:has_job => :get}
  map.resources :dids, :collection => {:edit_all => :get,:update_all =>:post,:delete_all => :any}
  map.resources :follow_ups
  map.resources :referrals, :collection => {:unmatched => :get, :matched => :get}

  map.resources :v2_countries, :collection => {:special_country => :get}
  map.resources :campaigns
  
  map.resource :rate_engine do |re|
    re.resources :prefix_groups, :controller => "rate_engine/prefix_groups"
  end
  
  map.resources :leads, :collection => {:upload => :get, :uploader => :post, :all => :get}, :has_many => [:memos, :notifications, :pbx_cdrs]
  
  map.resources :rate_groups
  map.resources :notification_templates, :collection => {:preview => :get, :create_preview => :post, :send_preview => :post} do |nt|
    nt.resource :batch_send, :controller => "notification_templates/batch_send"
    nt.resource :batch_send, :controller => "notification_templates/send"
  end
  map.resources :notification_types
  map.resources :cards, :collection => {:convert => :get}, :has_many => [:memos, :notifications, :pbx_cdrs]
  map.resources :distributors
  map.resources :distributions do |d|
    d.resources :cards, :controller => "distributions/cards", :collection => {:used => :get}
  end
  
  map.resources :card_cdrs, :collection => {:etisal_logs => :get}
  
  map.resources :sip_locations
  
  map.resources :accounts, :has_many => [:memos, :notifications, :pbx_cdrs, :forwardings], :collection => {:overvuew => :get, :closed => :get, :none_paying => :get, :recharge => :get, :charge => :post, :search => :post,:search_result=>:get} do |account|
    account.resources :credits, :controller => "accounts/credits"
    account.resources :phone_books, :controller => "accounts/phone_books"
    account.resources :billing, :controller => "accounts/billing", :collection => {:charge_view => :any, :update_autorecharge=>:any, :auto_recharge =>:get, :charge => :post, :credit_cards => :get, :transactions => :get, :credits => :get}
    account.resources :credit_cards, :controller => "accounts/credit_cards", :collection => {:charge => :post,:update_position=>:get}
    account.resources :overview, :controller => "accounts/overview"
    account.resources :users, :controller => "accounts/users" do |user|
      user.resources :phones, :controller => "accounts/users/phones"
    end
    account.resources :endpoints, :controller => "accounts/endpoints"
    account.resources :referrals, :controller => "accounts/referrals"
    account.resources :follow_ups, :controller => "accounts/follow_ups"
    account.resource :reports, :controller => "accounts/reports"
    account.resources :promotions, :controller => "accounts/account_promotions"
    account.resources :subscriptions, :controller => "accounts/subscriptions"
    account.resources :tmp_credit_card_infos, :controller => "accounts/tmp_credit_card_info", :collection => {:authorize => :post}
    account.resources :sip_accounts, :controller => "accounts/sip_accounts"
    account.resources :order_transactions, :controller => "accounts/order_transactions"
  end
  
  map.resource :reports, :collection => {:daily => :get, :data => :get, :data2 => :get, :data3 => :get} do |reports|
    reports.resource :daily, :controller => "reports/daily", :collection => {:daily_graph => :get}
    reports.resource :monthly, :controller => "reports/monthly", :collection => {:monthly_graph => :get}
    reports.resource :sales, :controller => "reports/sales", :collection => {:monthly_graph => :get}
  end
  
  map.resources :faqs
  map.resources :general_templates
  
  map.resources :promotions
  
  map.resources :cards_inventories
  
  map.resource :financial, :collection => {:stats => :get}, :controller => 'financial'

  map.connect ':controller/:action.:format'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
