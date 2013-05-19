class Chart
  attr_accessor :type, :title, :values, :bg_colour, :y_min, :y_max, :y_steps, :x_min, :x_max, :labels, :x_colour
    
  def initialize(type, max, step)
    self.type = type.to_s
    self.bg_colour = "#FFFFFF"
    self.x_colour = "#428C3E"
    self.y_min = 0
    self.y_max = max
    self.y_steps = step
  end
  
  def to_json
    elements = [ {:type => self.type, :values => self.values} ]
    title = {:text => self.title}
    y_axis = {:min => self.y_min, :max => self.y_max, :steps => self.y_steps}
    x_axis = {:colour => self.x_colour, :labels => {:labels => self.labels}}
    
    json = {
      :elements => elements,
      :title => title,
      :bg_colour => self.bg_colour,
      :x_axis => x_axis,
      :y_axis => y_axis
    }
    json.to_json    
  end
end
