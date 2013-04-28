require 'Qt'

class DragLabel < Qt::Label

  def initialize(text, allow_drops, parent=nil)
    super( text, parent )
    setAcceptDrops(allow_drops)
  end

  def dragEnterEvent(event)
    if event.mimeData().hasFormat("text/plain")
      event.accept
    else
      event.ignore
    end
  end

  def dragLeaveEvent(event)
    event.accept
  end

  def mousePressEvent(event)
    if event.button() == Qt::LeftButton
      @pos = event.pos()
    end
  end

  def mouseMoveEvent(event)
    return if not event.buttons() & Qt::LeftButton
    return if (@pos - event.pos()).manhattanLength() < Qt::Application.startDragDistance()
    pix = Qt::Pixmap.new(75,15)
    painter = Qt::Painter.new
    painter.begin(pix)
    painter.fillRect(pix.rect(), Qt::Brush.new(Qt::white))
    painter.drawText(pix.rect(), Qt::AlignHCenter | Qt::AlignVCenter, self.text)
    painter.end()
    mimeData = Qt::MimeData.new
    mimeData.setText(self.text)
    drag = Qt::Drag.new(self)
    drag.setPixmap(pix)
    drag.setMimeData(mimeData)
    drag.exec(Qt::MoveAction) #Qt::CopyAction |
  end

  def dropEvent(event)
    if event.mimeData.hasFormat("text/plain")
      #service_data = event.mimeData().data("text/plain")
      #data_stream = Qt::DataStream.new(service_data, Qt::IODevice::ReadOnly)
      #pixmap = Qt::Pixmap.new
      #point = Qt::Point.new
      #data_stream >> pixmap >> point

      #@service_locations.append(point)

      text = event.mimeData().text()
      setText(text)

      event.setDropAction(Qt::MoveAction)
      event.accept
    else
      event.ignore
    end
  end
end
