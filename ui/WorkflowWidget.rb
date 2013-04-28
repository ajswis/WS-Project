require 'Qt'

class WorkflowWidget < Qt::Widget

  def initialize
    super
    setAcceptDrops true
    setMinimumSize 250,250
    setMaximumSize 250,250

    @service_locations = Array.new
  end


  def dragMoveEvent(event)
    if event.mimeData.hasFormat("text/plain")
      event.setDropAction(Qt::MoveAction)
      event.accept
    end
  end


  def mousePressEvent(event)
    square = targetSquare(event.pos)
    drag = Qt::Drag.new(self)
    #pixmap = Qt::Pixmap something here
    mimeData = Qt::MimeData.new

    mimeData.setText(@text)
    drag.setMimeData(mimeData)
    drag.setHotSpot(event.pos - square.topLeft)
    #drag.setPixmap(pixmap)
    drag.exec(Qt::MoveAction)
  end

end
