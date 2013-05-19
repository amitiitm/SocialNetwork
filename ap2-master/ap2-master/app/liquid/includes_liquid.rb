class IncludesLiquid < Liquid::Tag                                             
  def initialize(tag_name, name, tokens)
    @name = name
    super
  end

  def render(context)
    template = GeneralTemplate.find(:first, :conditions => {:uid => @name}).template
    l = Liquid::Template.parse(template)
    l.render
  end    
end

Liquid::Template.register_tag('includes', IncludesLiquid)