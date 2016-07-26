require "thor"
require "httparty"
require_relative "application"
require_relative "messages"

API_KEY = MINUTE_DOCK_DEVELOPER_KEY

class MinuteDockCLI < Thor
  include HTTParty
  include Messages
  base_uri "https://minutedock.com/api/v1/"

  desc "status", "Returns the current entry status with contact details"
  def current_contact_status
    data = self.class.get("/entries/current.json",
                          query: { api_key: API_KEY }
                         )
    response = data.parsed_response

    if response["contact_id"]
      current_contact_message(response)
    else
      no_contact(response)
    end
  end

  desc "minute_logger", "Logs the current entry"
  def minute_logger
    response = self.class.post("/entries/current/log.json",
                               query: { api_key: API_KEY }
                              )

    if response.success? && response.parsed_response["logged"] == true
      minute_logger_success
    else
      minute_logger_error
    end
  end

  desc "list_projects", "List all goal entry"
  def list_projects
    response = self.class.get("/projects.json", query: { api_key: API_KEY })
    if response
      project_details(response)
    else
      no_project
    end
  end

  desc "list_contacts", "list all contacts"
  def list_contacts
    response = self.class.get("/contacts.json", query: { api_key: API_KEY })
    if response
      contact_details(response)
    else
      no_contact_created
    end
  end

  desc"get_contact_details", "fill in contact details"
  def get_contact_details
    say("Input just first name for contact")
    @name = ask("first name: ")

    say("Input shortcode for contact")
    @short_code = ask("short_code: ")
  end

  desc"create a contact", "post a specific contact"
  def create_contact
    get_contact_details
    response = self.class.post(
      "/contacts.json?contact[name]=#{@name}&contact[short_code]=#{@short_code}",
      query: { api_key: API_KEY }
    )
    if response.success? == true
      contact_success
    else
      contact_error
    end
  end
end

MinuteDockCLI.start(ARGV)
