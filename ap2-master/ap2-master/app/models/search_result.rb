class SearchResult
  attr_accessor :text, :id, :results
  
  def initialize
    self.results = []
  end
  
  def to_json
    self.results.to_json
  end
  
end