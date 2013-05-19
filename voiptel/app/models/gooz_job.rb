module GoozJob
  @queue = :notification
  
  def self.perform template
    puts template.class
  end
end