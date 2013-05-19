if RAILS_ENV == "production"
  HoptoadNotifier.configure do |config| 
    config.api_key = 'c5ddde841c228c14f5f74c2f08530dea'
  end
end