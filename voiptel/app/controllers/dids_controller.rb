class DidsController < ApplicationController
  def index
    has_advanced_pager(Did)
    @dids = Did.find(:all, :conditions => @sql_conditions, :order => "created_at DESC", :offset => @start, :limit => @limit)
    @path = dids_path
    resp
  end

  def edit
    @did = Did.find(params[:id])
    resp
  end

  def update
    @did = Did.find(params[:id])
    if @did.update_attributes(params[:did])
      @did.reassign_did_to_phones_if_not_active
      @success = true
    else
      @success = false
    end
  end

  def upload
    csv = params[:did_list]
    path = File.join("tmp/imports", csv.original_filename)
    # Saving the file
    open(path, "w") { |io| io.write(csv.read) }

    #Importing into db
    DidImporter::import_csv(path)
    redirect_to :action => 'index'
    resp
  end

  def area_codes
    @area_codes = AreaCode.find(:all, :conditions => {:country_id => 1}, :order => "area_code ASC")
  end

  def rate_centers
    @rate_centers = Npanxx.find(:all, :order => "npa ASC")
  end

  def destroy
    Did.destroy(params[:id])
    resp
  end

  def new
    @did = Did.new
    @did.active = false
    resp
  end

  def cid_problem
    @cid_problems = CidProblem.find(:all, :order => "created_at DESC")
  end

  def create
    logger.info { "---------------------------------------------------------------------------------" }
    did_form = params[:did]
    numbers = did_form[:numbers]
    numbers = numbers.gsub("\r", "")
    did_numbers = did_form[:numbers].split("\n")
    for did_number in did_numbers do
      did_number = did_number.strip
      did = Did.find_by_number(did_number)
      unless did
        did = Did.new
        if did_number.length == 10
          did_number = "1#{did_number}"
        end
        did.number = did_number
        did.did_provider_id = did_form[:did_provider]
        did.channels = 100000
        did.active = did_form[:active]
        did.did_type = did_form[:did_type]
        area_code_info = AreaCodeInfo.find(:first, :conditions => {:npanxx => did_number[1..6]})
        begin
          did.save
          did.reassign_did_to_phones_if_not_active
        rescue Exception => e
          puts "Exception in saving #{e.inspect}"
        end

      else
        logger.info { "DID #{did_number} Already Exists!" }
      end
      logger.info { "********************************************" }
    end

    #redirect_to :action => 'index'

  end

  def edit_all
    @record_ids = params[:record_ids]
    resp
  end

  def update_all
    Did.update_all("did_type=#{params[:did][:did_type]}, active=#{params[:did][:active]}", "id in(#{params[:record_ids]})")
  end

  def delete_all
    #There is problem with call back so don't use destroy_all
    #Did.destroy_all("id in(#{params[:record_ids]})")
    params[:record_ids].split(",").each do |id|
      begin
        Did.destroy(id)
      rescue Exception => e
        Rails.logger.info "Exception Raised: #{e}"
      end
    end
    render :update_all
  end

  def get_distance
    phone1 = params[:phone1]
    phone2 = params[:phone2]
    phone1_npanxx = AreaCodeInfo.find_by_npanxx((phone1[:npa].to_i * 1000 + phone1[:nxx].to_i))
    phone2_npanxx = AreaCodeInfo.find_by_npanxx((phone2[:npa].to_i * 1000 + phone2[:nxx].to_i))

    @phone1_rate_center = phone1_npanxx.ratecenter
    @phone1_latitude = phone1_npanxx.lat
    @phone1_longitude = phone1_npanxx.long

    @phone2_rate_center = phone2_npanxx.ratecenter
    @phone2_latitude = phone2_npanxx.lat
    @phone2_longitude = phone2_npanxx.long
    @distance = RateCenterInfo::distance(phone1_npanxx.lat, phone1_npanxx.long, phone2_npanxx.lat, phone2_npanxx.long)
  end

end
