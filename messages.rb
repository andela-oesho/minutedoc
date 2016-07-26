module Messages
  def current_contact_message(response)
    puts %(your timer is currently #{(response['timer_active']
          ) ? 'active' : 'paused'},with contact_id #{response['contact_id']})
  end

  def no_contact(response)
    puts %(Your timer is currently #{(response['timer_active']
          ) ? 'active' : 'paused'}, for no contact)
  end

  def minute_logger_success
    puts %(Okay, we've logged that!)
  end

  def minute_logger_error
    puts %(awww, you have no log online)
  end

  def project_details(project)
    puts %(your total number of projects is #{project.size}, below are details),
         project
 end

  def no_project
    puts %(you have no projects currently)
  end

  def contact_details(contact)
    puts %(your total number of contacts is #{contact.size}, below are details),
         contact
end

  def no_contact_created
    puts %(you have no contacts presently)
  end

  def contact_success
    puts %(successfully created contact)
  end

  def contact_error
    puts %(awww was not succesfull)
  end
end
