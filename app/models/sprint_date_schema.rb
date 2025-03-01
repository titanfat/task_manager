class SprintDateSchema < Dry::Validation::Contract
  params do
    required(:start_date).filled(:date)
    required(:end_date).filled(:date)
    required(:created_at).filled(:date)
  end

  rule(:start_date, :end_date, :created_at) do
    key(:start_date).failure('Sprint cannot be earlier than end_date') if values[:start_date] > values[:end_date]
    key(:start_date).failure('Sprint cannot be earlier than created') if values[:start_date] < values[:created_at]
  end
end