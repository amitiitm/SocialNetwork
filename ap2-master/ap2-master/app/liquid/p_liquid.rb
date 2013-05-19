class PLiquid < Liquid::Block                                             
  def initialize(tag_name, markup, tokens)
     super 
     @rand = markup.to_i
  end

  def render(context)    
    "<tr><td class='cont_cell'>#{RedCloth.new(super.to_s).to_html}</td></tr>"
  end    
end

Liquid::Template.register_tag('p', PLiquid)