  module PhoneDidHandler

    @@mobile_temp_lan = "19492021009"
    @@phone_temp_lan = "18882219265"
    @@toll_free_did_area_codes = ["800","888","877","866","855"]

    def self.get_assigned_count_to_did did
        is_toll_free_number = false
        @@toll_free_did_area_codes.collect{|no| "1#{no}"}.each do |num|
            is_toll_free_number = true if did.number.starts_with?(num)
            break if is_toll_free_number
        end
        if is_toll_free_number
            # check if this is the first toll free number
            toll_number = self.get_temp_lan_for_phone
            if toll_number == did.number
                # this is the number used for users
                return Phone.count({:conditions=>["phone_type in (1,3) and id not in (select phone_id from assigned_dids)"]})
            else
                return did.assigned_dids.count
            end
        end

        # check for mobile toll free number
        mob_toll_free = self.get_temp_lan_for_mobile
        if mob_toll_free and mob_toll_free == did.number
            return Phone.count({:conditions=>["phone_type in (2) and id not in (select phone_id from assigned_dids)"]}) + did.assigned_dids.count
        end
        return did.assigned_dids.count
    end

    def self.reassign_phone_dids_for_area_code area_code
        puts "------------------------>>>>>>    Reassigning phone dids for area_code #{area_code}"
        Phone.find(:all,:conditions=>["is_per_lan <> 1 and area_code = ?", area_code]).each do |phone|
            self.process_new_phone phone
        end
    end

    def self.reassign_phone_dids_for_rate_center rate_center
        puts "----------------->    Reassigning dids for rate_center #{rate_center}"
        Phone.find(:all,:conditions =>["area_code_info_id in (select id from area_code_infos where ratecenter = ?)", rate_center]).each do |phone|
            self.process_new_phone phone
        end
    end

    # return temp lan based on phone type
    def self.temp_lan_for phone
        if phone and phone.phone_type == Phone::MOBILE
            return self.get_temp_lan_for_mobile
            #@@mobile_temp_lan
        else
            return self.get_temp_lan_for_phone
            #@@phone_temp_lan
        end
    end

    # returns number and is permanent lan
    def self.get_phone_lan phone
        if phone.assigned_did
            if phone.is_per_lan==1
                return phone.assigned_did.did.number,true
            end
        end
        self.process_new_phone phone
        if phone.assigned_did
            if phone.is_per_lan==1
                return phone.assigned_did.did.number,true
            else
                return phone.assigned_did.did.number, false
            end
        else
            if [Phone::WORK,Phone::HOME].include? phone.phone_type
                return self.get_temp_lan_for_phone, false
                #return @@phone_temp_lan, false
            else
                return self.get_temp_lan_for_mobile, false
                #return @@mobile_temp_lan, false
            end
        end
    end

    def self.process_new_phone phone
        puts "**** Inside process_new_phone **************"
        return if phone.assigned_did and phone.is_per_lan==1
        puts "******* Phone type is #{phone.phone_type}"
        if [Phone::WORK,Phone::HOME].include? phone.phone_type
            self.process_phone phone
        else
            self.process_cell_phone phone
        end
    end

    private

    def self.get_temp_lan_for_phone
        Did.find(:first,:conditions=>["active=1 and did_type=1 and number like '1"+@@toll_free_did_area_codes.join("%%' or number like '1")+"%%'"]).number
    end

    def self.get_temp_lan_for_mobile
        # get irvine rate_center with max assigned_count
        did = Did.find(:first,:conditions=>["active=true and rate_center=? and did_type=1","IRVINE"],:order=>"assigned_count desc")
        did.number if did
    end

    def self.process_cell_phone phone
        # look for account did and process the closest one
        best_choice,matching_rate_center_and_npa = self.assign_did_from_account_dids(phone)
        return best_choice if matching_rate_center_and_npa
        did = self.assign_did_with_matching_rate_center_and_npa(phone)
        return did if did

        other_best_did_found = self.assign_did_with_matching_area_code phone
        if other_best_did_found
            if best_choice
                if best_choice.area_code_info.distance_to(phone.area_code_info) < other_best_did_found.area_code_info.distance_to(phone.area_code_info)
                    # use best_choice
                    puts "Using best choice from already existing account dids for phone #{phone.number} did: #{best_choice.number}"
                        unless phone.new_record?
                            if (phone.assigned_did.nil? or phone.is_per_lan!=1) and (Time.now.to_i-phone.created_at.to_i>15)
                                phone.notes=''
                            end
                        end
                        phone.is_per_lan = 1
                        phone.assign_did best_choice
                else
                    #use other_best
                    puts "Using other best choice which has same area code for phone #{phone.number} did: #{other_best_did_found.number} "
                        unless phone.new_record?
                            if (phone.assigned_did.nil? or phone.is_per_lan!=1) and (Time.now.to_i-phone.created_at.to_i>15)
                                phone.notes=''
                            end
                        end
                        phone.is_per_lan = 1
                        phone.assign_did other_best_did_found
                end
            else
                puts " Using other best choice which has same area code for phone #{phone.number} did: #{other_best_did_found.number} "
                    unless phone.new_record?
                        if (phone.assigned_did.nil? or phone.is_per_lan!=1) and (Time.now.to_i-phone.created_at.to_i>15)
                            phone.notes=''
                        end
                    end
                    phone.is_per_lan = 1
                    phone.assign_did other_best_did_found
            end
        else
            if best_choice
                puts "Using best choice from already existing account dids for phone #{phone.number} did: #{best_choice.number}"
                    unless phone.new_record?
                        if (phone.assigned_did.nil? or phone.is_per_lan!=1) and (Time.now.to_i-phone.created_at.to_i>15)
                            phone.notes=''
                        end
                    end
                    phone.is_per_lan = 1
                    phone.assign_did best_choice
            end
        end
    end

    def self.process_phone phone
        # look for account did and process the closest one
        puts "**** Processing phone #{phone.number} "
        best_choice,matching_rate_center_and_npa = self.assign_did_from_account_dids(phone)
        return best_choice if matching_rate_center_and_npa
        did = self.assign_did_with_matching_rate_center_and_npa(phone)
        return did if did

        if best_choice
            # the case when not matching the rate center
            puts "Using best choice from already existing account dids"
            unless phone.new_record?
                if (phone.assigned_did.nil? or phone.is_per_lan!=1) and (Time.now.to_i-phone.created_at.to_i>15)
                    phone.notes=''
                end
            end
            phone.assign_did best_choice
            phone.is_per_lan = 3
            return best_choice
        end
        return nil if phone.area_code_info.nil? or phone.area_code_info.ratecenter.blank?
        self.assign_temp_did_with_matching_area_code(phone) or self.assign_temp_did_with_matching_rate_center(phone)
    end

    # this method returns the best match from available attached dids to the account, must have 
    # 1. same area code
    # 2. can have different rate center
    def self.assign_did_from_account_dids phone
        account_dids = AccountDid.find_by_account_and_area_code(phone.account, phone.area_code).sort do |ad1,ad2|
            ad2.assigned_dids.to_a.count <=> ad1.assigned_dids.to_a.count
        end
        rate_center_and_npa_match = false
        best_choice = nil
        account_dids.each do |account_did|
            if account_did.did && account_did.did.can_be_used_with?(phone)
                if (account_did.did.can_be_used_with?(phone)).is_a? Float
                    # this is not rate center match
                    best_choice = account_did.did
                else
                    # rate center and area_code matched
                    rate_center_and_npa_match = true
                    best_choice = account_did.did
                    break
                end
            end
        end
        if best_choice and rate_center_and_npa_match
            puts "Have found best match in assign_did_from_account_dids for phone: #{phone.number} : did #{best_choice.number}"
            unless phone.new_record?
                if (phone.assigned_did.nil? or phone.is_per_lan!=1) and (Time.now.to_i-phone.created_at.to_i>15)
                    phone.notes=''
                end
            end
            phone.is_per_lan=1
            phone.assign_did best_choice
        end
        return best_choice, rate_center_and_npa_match
    end

    def self.assign_did_with_matching_rate_center_and_npa phone
        return nil if phone.area_code_info.nil? or phone.area_code_info.ratecenter.blank?
        dids_from_same_rate_center = Did.find :all, :conditions => {:active=>1, :rate_center => phone.area_code_info.ratecenter, :area_code=>phone.area_code}
        dids_from_same_rate_center.each do |did|
            unless phone.new_record?
                if (phone.assigned_did.nil? or phone.is_per_lan!=1) and (Time.now.to_i-phone.created_at.to_i>15)
                    phone.notes=''
                end
            end
            phone.is_per_lan=1
            phone.assign_did did
            return did
        end
        nil
    end

    def self.assign_temp_did_with_matching_area_code phone
        dids = Did.find :all, :conditions => {:area_code => phone.area_code, :active=>1}
        self.assign_did_with_min_distance phone,dids
    end

    def self.assign_did_with_matching_area_code phone
        dids = Did.find :all, :conditions => {:area_code => phone.area_code, :active=>1}
        self.assign_did_with_min_distance phone,dids,1
    end

    def self.assign_temp_did_with_matching_rate_center phone
        dids = Did.find :all, :conditions => {:rate_center=> phone.area_code_info.ratecenter, :active=>1}
        self.assign_did_with_min_distance phone,dids
    end

    def self.assign_did_with_min_distance phone, dids, is_per_lan=2
        return nil if phone.area_code_info.nil? or phone.area_code_info.ratecenter.blank?
        best_choice = nil
        max_distance = 100000
        dids.each do |did|
            next unless did.area_code_info
            if max_distance > phone.area_code_info.distance_to(did.area_code_info)
                max_distance = phone.area_code_info.distance_to(did.area_code_info)
                best_choice = did
            end
        end
        if best_choice and (is_per_lan==1 or max_distance<=4)
            puts "Assigning temp lan for phone #{phone.number} did: #{best_choice.number} with distance: #{max_distance}"
                unless phone.new_record?
                    if (phone.assigned_did.nil? or phone.is_per_lan!=1) and (Time.now.to_i-phone.created_at.to_i>15)
                        phone.notes=''
                    end
                end
            phone.is_per_lan = is_per_lan
            phone.assign_did best_choice
            return best_choice
        end
        nil
    end
end
