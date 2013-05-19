module RedCloth::Formatters::HTML
  
  COLORS = {
    'blue'    => "#0055B5",
    'red'     => "#FF0202",
    'orange'  => "#EE7600"
  }
  
  def span(opts)
    cls = opts[:class] || 'orange'
    "<span style='color: #{COLORS[cls]};'>#{opts[:text]}</span>\n"
  end
  
  def p(opts)
    "<p style='font-size: 12px; line-height: 20px; padding: 0px 0px 7px;font-family: Arial, Helvetica, sans-serif; color: #333333;'>#{opts[:text]}</p>\n"
  end  
end
