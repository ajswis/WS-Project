require 'Qt'

class WorkFlowGridLayout < Qt::GridLayout
  def initialize()
    super(parent)
    setAcceptDrops(true)
  end

  def dropEvent(event)
    if event.mimeData.hasFormat("text/plain")

      event.setDropAction(Qt::MoveAction)
      event.accept
    else
      event.ignore
    end
  end
end
