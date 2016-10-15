module TicketUploads
  extend ActiveSupport::Concern

  included do
    
    store_accessor  :storage,
                    :pdf_file_name, :pdf_file_size, :pdf_content_type, :pdf_updated_at, :storage_type, :file_name
                    
    has_attached_file :pdf,
                      :storage => :s3,
                      :s3_credentials => {
                          :bucket => 'eventhub-tickets',
                          :access_key_id => 'AKIAIZPHUEQUPKCRVCGQ',
                          :secret_access_key => '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'
                      },
                      :path => '/:class/:evend_date/:facility/:inventory/:client/:filename',
                      :s3_protocol => :https
                      
    validates_attachment :pdf, content_type: { content_type: ['application/pdf'] }
    include DeletableAttachment
    
    Paperclip.interpolates :evend_date do|attachment,style| 
      attachment.instance.event_date_id
    end
    
    Paperclip.interpolates :facility do|attachment,style| 
      attachment.instance.facility_id
    end
    
    Paperclip.interpolates :inventory do|attachment,style| 
      attachment.instance.inventory_id
    end
    
    Paperclip.interpolates :client do|attachment,style| 
      attachment.instance.client_id
    end
    
  end
end