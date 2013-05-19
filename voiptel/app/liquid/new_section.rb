class NewSectionLiquid < Liquid::Block
  def initialize(tag_name, section, tokens)
     super
     @section = section.strip
  end

  def render(context)
    red_cloth = RedCloth.new(super.to_s)
    red_cloth.no_span_caps = true
    if @section.blank?
      "<tr><td style='font-size: 12px; padding: 17px 36px 15px 22px;'>#{red_cloth.to_html}</td></tr>"
    else
      "<tr>
        <td style='padding: 10px 0px 0px 0px;' class='art_sep'><img src=
        'http://openfo.com/images/email/art_sep_abs.gif' border='0' height=
        '1' alt='' width='697' /></td>
      </tr>
        <tr>
        <td style='font-size: 12px; padding: 17px 36px 15px 22px;'>
          <table cellspacing='0' border='0' cellpadding='0' width='100%'>
            <tr>
              <td width='4'><img src=
              'http://openfo.com/images/email/art_head.gif' border='0'
              height='34' alt='' width='3' /></td>

              <td>
                <h4 style='font-weight: normal; font-size: 18px;
            		margin: 0px 0px 15px 0px; font-family: Georgia;
            		padding: 0px 0px 0px 5px; color: #000;'>#{@section}:</h4>
              </td>
            </tr>
          </table>

          <table cellspacing='0' border='0' cellpadding='0' width='100%'>
            <tr>
              <td width='460'>
              #{red_cloth.to_html}
              </td>
            </tr>
          </table>
        </td>
      </tr>".strip      
    end
  end    
end

Liquid::Template.register_tag('new_section', NewSectionLiquid)