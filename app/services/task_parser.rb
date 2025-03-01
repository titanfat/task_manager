# frozen_string_literal: true

module TaskParser
  module_function

  def tasks_parser(data)
    data.map do |issue|
      begin
        issue => {
          key: id, fields: { summary:, description:, created:,
            status: { name: status },
            sprint:,
            creator: {
              emailAddress: email,
              displayName: full_name
            }
          }
        }

        { id: id, title: summary, description:, created:, status:,
          sprint: parse_sprint(sprint:),
          creator: { email: email, full_name: full_name }
        }
      rescue NoMatchingPatternError
        logger = Logger.new('t. log')
        logger.add(Logger::ERROR, "#{issue} failed to parse")
      end
    end
  end

  def parse_sprint(sprint)
    return {} unless sprint

    sprint => { sprint: { name:, state:, startDate:, endDate: }}

    { name:, state:, start_date: startDate || DateTime.current, end_date: endDate || DateTime.current + 2.weeks }
  rescue NoMatchingPatternError
    logger = Logger.new('t. log')
    logger.add(Logger::ERROR, "#{sprint} failed to parse")
  end
end