module TaskParser
  module_function

  def tasks_parser(data)
    attributes = %w[id title description sprint status created creator]

    tasks ||= data.map do |issue|


      fields = issue.fetch('fields')
      sprint = fields.fetch('sprint', {})
      creator = fields.fetch('creator', {})
      status = fields.fetch('status', 'backlog')

      attributes.to_h do |attr|
        value =
          case attr
          when 'id' then issue['key']
          when 'title' then fields&.dig('summary') || 'Empty title'
          when 'status' then status&.dig('name')
          when 'description' then fields['description']
          when 'created' then fields['created']
          when 'sprint'
            {
              name: sprint&.dig('name'),
              state: sprint&.dig('state'),
              start_date: sprint&.dig('startDate') || DateTime.current,
              end_date: sprint&.dig('endDate') || DateTime.current + 2.week
            }
          when 'creator'
            {
              email: creator['emailAddress'],
              full_name: creator['displayName'],
            }
          end

        [attr.to_sym, value]
      end
    end
  end
end