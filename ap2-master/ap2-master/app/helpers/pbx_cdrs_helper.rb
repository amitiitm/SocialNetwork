module PbxCdrsHelper

  def voicemail(cdr)
    if cdr.duration > 0 and !cdr.voicemail.blank?
      duration(cdr.duration)  + link_to(image_tag("/images/advance_search/blue_play.png"), voicemail_pbx_cdrs_path(:id =>cdr.id),:class => "ajax pbx", :update => "player")
    else
      ""
    end
  end

  def recording(cdr)
      if cdr.duration > 0 and !cdr.recording.blank?
        duration(cdr.duration) + link_to(image_tag("/images/advance_search/play.png"), recording_pbx_cdrs_path(:id =>cdr.id),:class => "ajax pbx", :update => "player")
      else
        ""
      end
    end

  def listen(cdr)
    if cdr.duration > 0
      " " + link_to(image_tag("/images/advance_search/play.png"), "http://pbx.voipontel.com/.recs/#{cdr.uid}.mp3", :class => "ignore-me listen pbx")
    else
      ""
    end
  end

  def contactable_link(contactable)
    if contactable.class == User
          path = "account_path"
          id = contactable.account_id
        else
          path = "#{contactable.class.to_s.downcase}_path"
          id = contactable.id
        end
    return path,id
  end


  def link_to_contactable(contactable)
    path,id = contactable_link(contactable)
    link_to(contactable.info, send(path, id), :class => "openable")
  end

  def display_disposition(pbx_cdr, type)
    disp =   (pbx_cdr.disposition.to_s.downcase == 'voicemail_in' && pbx_cdr.duration <=5) ? 'Missed call' : 'VM'
    custom_disposition =
        {
            "inbound" => {'answer_in' => 'Answer',
                          'voicemail_in' => disp

            },
            "outbound" => {'answer' => 'Answer',
                           'cancel' => "No Answer",
                           'congestion' => 'Busy'
            }
        }
    custom_disposition[type][pbx_cdr.disposition.to_s.downcase] rescue ""
  end

  def pbx_phone(content, options = {},contactable=nil)
    options[:admin_user_id] = session[:user].id
    options[:cid] = "19493257005"
    options[:ext] = session[:user].ext
    args = options.to_param.gsub("&", "|")

    number = content

    id = (contactable.blank? ? '#'  : contactable.account_id)  rescue '#'
    link_to(number, '#', :id=>id, :class => "callable1 ignore-me", :args => args)
  end


end
