class CustomQuery
  def initialize(sql)
    @sql = sql
    @results = []
    @connection = ActiveRecord::Base.connection
  end

  def execute
    @results = @connection.execute(@sql).to_a
  end

  def find_value(path)
    index, column_name = path.split('|')
    index = index.to_i

    raise_index_or_path_exception if index.blank? || path.blank?

    raise_results_path_exception if index > (results.size - 1)

    results[index][column_name]
  end

  def results
    @results.empty? ? execute : @results
  end

  private

  def raise_index_or_path_exception
    raise ArgumentError,
      'Missing index or path, make sure to use this format ' \
      '"index|column_name". Example: "0|particle_id"'
  end

  def raise_results_path_exception
    raise ArgumentError,
      'The results are empty, or the row you specified does not exist.' \
      'Check the raw results and remember the first row is "0"'
  end
end
