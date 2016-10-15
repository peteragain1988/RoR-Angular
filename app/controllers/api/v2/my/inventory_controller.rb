class Api::V2::My::InventoryController < Api::V2::ApplicationController
  skip_before_filter :authenticate_user, only: :tickets_zip
  before_filter :tickets_zip
  
  def index
    inventories = Inventory.includes(
        facility: [],
        confirmed_inventory_option: [],
        client:[],
        released_tickets:[]
    ).joins(event_date: [:event]).where(client_id: current_user[:company_id]).where("now() < upper(event_dates.event_period)")

    
    render json: inventories
  end

  def tickets_zip
    @inventory = Inventory.includes(event_date:[:event]).find(params[:id])

    @tickets = @inventory.event.tickets.merge(Ticket.available).where(client_id: @inventory.client_id)

    file_name = @inventory.event.name.underscore
    t = Tempfile.new("tickets_temp_zip-#{Time.now}")
    
    
    #cookies["download_finished"] = "true"


    Zip::OutputStream.open(t) do |zipfile|
      @tickets.each do |ticket|
        begin
          
          if ticket.storage_type == "local"
            zipfile.add("#{ticket.file_name}", "public/tickets/#{ticket.file_name}")
          elsif ticket.storage_type == "remote"
            data = open(ticket.pdf.url).read
            zipfile.put_next_entry("#{ticket.row}-"+ticket.pdf_file_name) # Give it next file a filename
            zipfile.print(data) # Add file to zip
            
            #zipfile.add("#{ticket.pdf_file_name}", data)
          end
        rescue Zip::ZipEntryExistsError
        end
      end
    end

    send_file t.path, :type => 'application/zip',
              :disposition => 'attachment',
              :filename => file_name + ".zip"
    t.close
    
    @inventory = Inventory.find(params[:id])
    #@client_ids = @inventory.tickets_zip_downloaded.to_json
    
    #if @client_ids && !@client_ids.values.include?(params[:client_id])
     # @client_ids[Time.new.to_i] = params[:client_id]
     if !@inventory.tickets_zip_downloaded
       @client_ids = []
       @client_ids.push params[:client_id]
       @inventory.tickets_zip_downloaded = @client_ids.to_json
       @inventory.save
     else
       @client_ids = JSON.parse(@inventory.tickets_zip_downloaded)
       if !@client_ids.include?(params[:client_id])
         @client_ids.push params[:client_id]
         logger.debug "jkljkl #{@client_ids.inspect}"
         @inventory.tickets_zip_downloaded = @client_ids.to_json
         @inventory.save
       end
     end
    #end
    #cookies["download_finished"] = "true"

  end
end