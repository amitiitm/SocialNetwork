module UiHelper
  PAGER_LIMITS = [
      ["10 Results", 10],
      ["25 Results", 25],
      ["30 Results", 30],
      ["50 Results", 50],
      ["100 Results", 100]
  ]

  def time_in_word(obj, options={:title => true})
    return '--' if obj.blank?
    link = obj

    if !options[:title].blank?
      title = obj.strftime("%a %m-%d-%Y %H:%M")
      sort = obj.strftime("%Y-%m-%d %H:%M")
      link = raw("<span id='sort_time_format' style='display:none'>#{sort}</span>
                  <span style='cursor: pointer' title='#{title}'>
                    #{time_ago_in_words(obj, true)}</span>"
      )
    end
    link
  end

  def active_not_active(val)
    if val
      "Active"
    else
      "Not Active"
    end
  end

  def listen_to(url)
    "<a href='#{url}' title='Play &quot;coins&quot;' class='sm2_button'>Listen</a>"
  end

  def clear
    raw("<div class='clear'></div>")
  end

  def yes_no(val)
    (val) ? "Yes" : "No"
  end

  def player
    render :partial => "ui/player"
  end

  def available(val)
    (val) ? "Available" : "<span class='red'>Not Available</span>"
  end

  def boolean(val, t, f)
    (val) ? t : "<span class='red'>#{f}</span>"
  end

  def new_feature
    "<span class='new-feature'>New!</span>"
  end

  def icon(name)
    "<span class='ui-icon ui-icon-#{name}'></span>"
  end

  def image_icon(file)
    "<img src='/images/icons/#{file}' class='icon'></img>"
  end

  def icon_custom(name)
    "<span class='ui-icon #{name}'></span>"
  end

  def link_button(name, icon, options = {}, html_options = {})
    if html_options[:class]
      html_options[:class] = "#{html_options[:class]} btn ui-state-default ui-corner-all"
    else
      html_options[:class] = "btn ui-state-default ui-corner-all"
    end
    link_to icon(icon) + name, options, html_options
  end

  def side_menu(options, &block)
    menu_item = MenuItem.new
    yield menu_item
    concat render :partial => "ui/admintasia/side_menu", :locals => {:title => options[:title], :menu_items => menu_item, :id => options[:id]}
  end

  def allowed?
    session[:admin_user_id].to_i <= 2
  end

  def phone(content, options = {})
    options[:admin_user_id] = session[:user].id
    options[:cid] = "19493257005"
    options[:ext] = session[:user].ext
    args = options.to_param.gsub("&", "|")

    if content.class == Array
      number = content.shift
    else
      number = content
      content = []
    end

    text = []
    text << image_icon("telephone_go.png")
    text << number_to_phone(number, :area_code => true)
    text = (text + content).join(" ")
    link_to(text, "", :class => "callable ignore-me", :args => args)
  end

  def action_link(text, url, options = {:class => "ajax", :update => "container"})
    link_to(text, url, options)
  end


  def button(id, text, options = {})
    options[:class] ||= 'ajax'
    render :partial => "ui/button", :locals => {:id => id, :text => text, :tags => options_to_tags(options)}
  end

  def submit_button(text)
    raw "<button type='submit'>#{text}</button>"
  end

  def button_function(id, text, function, options = {})
    render :partial => "ui/button_function", :locals => {:id => id, :text => text, :function => function, :tags => options_to_tags(options)}
  end

  def convertable_fields(model)
    render :partial => "ui/convertable_fields", :locals => {:model => model}
  end

  def options_to_tags(options)
    tags = ""
    if options.class == Hash
      options.keys.each do |k|
        tags = "#{tags} #{k.to_s}='#{options[k]}'"
      end
    end
    tags.strip
  end

  def accordion_menu(options, &block)
    menu_item = MenuItem.new
    yield menu_item
    concat render :partial => "ui/admintasia/accordion_menu", :locals => {:options => options, :menu_items => menu_item}
  end


  def box(options, &block)
    concat render :partial => "ui/box/#{options[:type]}", :locals => {:options => options, :content => capture(&block)}
  end

  def modal_dialog(title, options = {}, &block)
    options[:title] = title
    unless options[:id]
      options[:id] = "#{title.downcase.gsub(" ", "_")}_dialog"
    end
    concat render :partial => "ui/box/modal_dialog", :locals => {:options => options, :content => capture(&block)}
  end

  def ap_date(date, msg = "N/A")
    return msg unless date
    date.strftime("%a %m/%d %H:%M")
  end

  def user_date(date, msg = "N/A")
    return msg unless date
    #format = session[:user].default_date_format
    #if format == "%a %m/%d %H:%M"
    #  if Time.now.year != date.year
    #    format = "%a %m/%d/%y %H:%M"
    #  else
    #    format = session[:user].default_date_format
    #  end
    #end
    format= "%a %m-%d-%y %H:%M"
    date.strftime(format)
  end

  def user_time(date)
    return "N/A" unless date
    format= "%a %y-%m-%d %H:%M:%S"
    date.strftime(format)
  end

  def table(options = {}, &block)
    options[:id] = "table-#{(Time.now.to_f * rand(1000).to_f).to_i.to_s}" unless options[:id]

    table = MyTable.new
    yield table
    concat render(:partial => "ui/table", :locals => {:table => table, :options => options})
  end

  def page_title(options)
    render :partial => "ui/page_title", :locals => {:title => options[:title], :desc => options[:desc], :options => options}
  end

  def accordion(options, &block)
    concat render :partial => "ui/box/accordion_item", :locals => {:options => options, :content => capture(&block)}
  end

  def link_to_remove_fields(name, f, options)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", options)
  end

  def link_to_add_fields(name, f, association, partial, options = {})
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(partial, :f => builder)
    end
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"), options)
  end

  # def label(l)
  #   "<label class='desc'>#{l}</label>"
  # end

  def upload(handler, queue_hnd, ext = "*.*")
    render :partial => "ui/upload", :locals => {:hnd => handler, :queue_hnd => queue_hnd, :ext => ext}
  end

  def error(title, id = "error")
    render :partial => "ui/error", :locals => {:title => title, :id => id}
  end

  def process_errors(errors, id, options = {})
    err_msg = ""
    #errors.full_messages.map {|e| err_msg = "#{err_msg}<li>#{e}</li>\n" }
    if errors.class == ActiveRecord::Errors
      errors.each { |atr, msg| err_msg = "#{err_msg}<li>#{msg}</li>\n" }
    elsif errors.class == Array
      errors.each do |model|
        model.each do |atr, msg|
          err_msg = "#{err_msg}<li>#{msg}</li>\n"
        end
      end
    elsif errors.class == String
      err_msg = "<li>errors</li>"
    end
    err_msg = escape_javascript(err_msg)
    "errors('#{err_msg}', '#{id}')"
    #"var errors = '#{err_msg}'"
  end

  def process_errors_for(model)
    err_msg = ""
    if model.class == Array
      errors = model
    else
      errors = model.errors
    end
    if errors.class == ActiveRecord::Errors
      errors.each { |atr, msg| err_msg = "#{err_msg}<li>#{msg}</li>\n" }
    elsif errors.class == Array
      errors.each do |model|
        model.each do |atr, msg|
          err_msg = "#{err_msg}<li>#{msg}</li>\n"
        end
      end
    elsif errors.class == String
      err_msg = "<li>errors</li>"
    end
    err_msg = escape_javascript(err_msg)
    "var errors = '#{err_msg}'"
  end

  def carrier_name(carrier)
    if carrier
      carrier.name
    else
      ""
    end
  end

  def loading(message, id = "", options = {})
    render :partial => "ui/loading", :locals => {:message => message, :id => id, :tags => options_to_tags(options)}
  end

  def process_response(page, errors, id, success)
    not_valid = errors
    if errors.class == Array
      if errors.size > 0
        not_valid = true
      end
    end
    if not_valid
      page << process_errors(errors, id)
    else
      page << success
    end
  end

  def action_links(*args)
    args.delete(nil)
    raw args.join(" | ")
  end

  def actions(*args)
    args.delete(nil)
    raw args.join(" | ")
  end

  def response_for(model_or_errors, page, success = :default, update = nil)
    if model_or_errors.class == Array
      errors = model_or_errors.size > 0
    else
      errors = (not model_or_errors.valid?)
    end
    if not errors
      if success == :default
        page << "default_reload('#{@path}', '#{update}');"
      else
        page << success
      end
    else
      page << process_errors_for(model_or_errors)
    end
  end


  def link_to_add_fields_custom(name, model, partial, locals)
    new_object = model.new
    association = new_object.class.to_s.tableize
    #fields = f.fields_for(new_object, :child_index => "new_#{association}") do |builder|
    #  render(partial, :f => builder)
    #end
    fields = render(:partial => partial, :locals => locals)
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end

  def pbx_pager(path, ajax = nil)
    render :partial => "ui/pbx_pager", :locals => {:path => path, :ajax => ajax}
  end

  def pager(path, ajax = nil)
    render :partial => "ui/pager", :locals => {:path => path, :ajax => ajax}
  end

  def account_pager(path, ajax = nil)
    render :partial => "ui/account_pager", :locals => {:path => path, :ajax => ajax}
  end

  def billing_pager(path, ajax = nil)
    render :partial => "ui/billing_pager", :locals => {:path => path, :ajax => ajax}
  end

  def credit_pager(path, ajax = nil)
    render :partial => "ui/credit_pager", :locals => {:path => path, :ajax => ajax}
  end

  def admin_user(u, msg = "N/A")
    if u
      u.name
    else
      msg
    end
  end

  def tree_ul(category)
    if category.children.size > 0
      ret = "<ul>"
      category.children.each { |subcat|
        if subcat.children.size > 0
          ret += "<li id='phtml_#{subcat.id}'>"
          ret += link_to h(subcat.name), "", :class => "ivrs"
          ret += tree_ul(subcat)
          ret += '</li>'
        else
          ret += "<li id='phtml_#{subcat.id}'>"
          ret += link_to h(subcat.name), "", :class => "ivrs"
          ret += '</li>'
        end
      }
      ret += '</ul>'
    end
  end

  private
  class MyTable
    def initialize
      @@head = ""
      @@body = ""
      @@row = ""
      @@counter = 0
    end

    def options_to_tags(options)
      tags = ""
      if options.class == Hash
        options.keys.each do |k|
          tags = "#{tags} #{k.to_s}='#{options[k]}'"
        end
      end
      tags.strip
    end


    def new_row(options = {}, selected=nil)
      if !selected.blank? && selected == options[:id]
        @@body = "#{@@body}\n<tr style='background-color:#FFFFCF' #{options_to_tags(options)}>#{@@row}</tr>\n"
      else
        @@body = "#{@@body}\n<tr #{options_to_tags(options)}>#{@@row}</tr>\n"
      end
      @@row = ""
    end

    def counter
      @@counter += 1
    end

    def counter=(n)
      @@counter = n
    end

    def th(name, options = {})
      @@head = "#{@@head}\n<th #{options_to_tags(options)}>#{name}</th>"
    end

    def td(cell, options = {})
      #@@row = "#{@@row}\n<td style='#{options[:style]}' class='#{options[:class]}'>#{cell}</td>"
      @@row = "#{@@row}\n<td #{options_to_tags(options)}>#{cell}</td>"
    end

    def thead
      @@head
    end

    def tbody
      @@body
    end
  end

  class MenuItem
    def initialize
      @@items = ""
    end

    def item(i)
      @@items = "#{@@items}\n<li>#{i}</li>"
    end

    def to_s
      @@items
    end
  end
end