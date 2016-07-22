require "thor"
require "httparty"

API_KEY = "your_developer_api_key"

class MinuteDockCLI < Thor
  include HTTParty
  base_uri "https://minutedock.com/api/v1/"


  desc "status", "Returns the current entry status from MinuteDock"
  def current_contact_status
    status_data = self.class.get("/entries/current.json", query: { api_key: API_KEY })
    status_response = status_data.parsed_response

    if status_response["contact_id"]
      new_status_response = self.class.get(
        "/entries/current.json?contact_id=#{status_response["contact_id"]}",
        query: { api_key: API_KEY })

      puts %(your timer is currently #{(status_response["timer_active"]
            ) ? "active" : "paused"},with contact contact_id #{new_status_response["contact_id"]})
    else
      puts %(Your timer is currently #{(status_response["timer_active"]
            ) ? "active" : "paused"}, for no contact)
    end
  end

  desc "minute_logger", "Logs the current entry"
  def minute_logger
    response = self.class.post("/entries/current/log.json", query: { api_key: API_KEY })
    if response.success? && response.parsed_response["logged"] == true
      puts "Okay, we've logged that!"
    end
  end

  desc "list_projects", "List all goal entry"
  def list_projects
    response = self.class.get("/projects.json", query: { api_key: API_KEY })
    if response
      puts response
    else
      puts %(you have no projects currently)
    end
  end

  desc "list_contact", "list all contacts"
  def list_contact
    response = self.class.get("/contacts.json", query: {api_key: API_KEY})
    if response
      puts response
    else
      puts %(you have no contacts presently)
    end
  end

  desc"get_contact_details", "post a specific contact"
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
                              query: {api_key: API_KEY}
                              )
    if response.success? == true
      puts %(successfully created contact)
    else
      puts %(awww was not succesfull)
    end
  end
end

MinuteDockCLI.start(ARGV)