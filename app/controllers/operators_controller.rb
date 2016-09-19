class OperatorsController < SecuredApplicationController
  def reads_total
    render json: { reads_total: ReadingEvent.reads_total }, status: 200
  end
end
