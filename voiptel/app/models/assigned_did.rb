class AssignedDid < ActiveRecord::Base
    #  index [:user_id, :phone_id]
    belongs_to :account
    belongs_to :user
    belongs_to :phone
    belongs_to :did
    belongs_to :account_did

    before_destroy :decrement_did_count
    after_save :increment_did_count

    private
    def decrement_did_count
        account_assigned_dids = AssignedDid.find(:all, :conditions => {:account_id => account.id, :did_id => did.id})
        if account_assigned_dids.size == 1
            AccountDid.delete(account_did)
            #AssignedDid.delete(account_assigned_dids)
            did.assigned_count -= 1
            did.save
        end
    end

    def increment_did_count
        account_assigned_dids = AssignedDid.find(:all, :conditions => {:account_id => account.id, :did_id => did.id})
        if account_assigned_dids.size == 1
            did.assigned_count += 1
            did.save
        end
    end

end
