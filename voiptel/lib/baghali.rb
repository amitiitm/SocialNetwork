class Baghali
  attr_accessor :country, :groups, :sk, :cc
  
  def initialize(country)
    self.country = Country.find(country)
    self.cc = self.country.country_code.to_s
    analyze
    nil
  end
  
  def sorted_prefix
    ik = self.groups.keys.map {|p| p.to_i}
    self.sk = ik.sort
    self.sk = self.sk.collect {|p| p.to_s}
  end
  
  def bazam
    sorted_prefix unless self.sk
    self.sk.each do |p|
      next if p == self.cc
      puts p    
      self.sk.each do |pj|
        next if p == self.cc        
      end
    end
  end
  
  def analyze
    pl = Rate.find(:all, :conditions => {:country_id => self.country.id}, :select => "DISTINCT prefix_length", :order => "prefix_length asc")

    g = Hash.new
    g[country.country_code.to_s] = []
    puts "Groups: "

    pl.each do |l|
      found = false
      for r in Rate.find(:all, :conditions => {:country_id => country.id, :prefix_length => l.prefix_length})
        found = false    
        g.keys.each do |k|
          if k == country.country_code.to_s
            if r.prefix == country.country_code.to_s
              g[k] << r
              found = true
            end      
          elsif (r.prefix.index(k) == 0)
            g[k] << r
            found = true
            break
          end
        end
        if not found
          g[r.prefix] = [r]
        end      
      end
    end
    self.groups = g
    nil
  end
end

