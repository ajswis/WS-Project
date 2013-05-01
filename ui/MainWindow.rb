require 'Qt'
require './MainWidget.rb'

class MainWindow < Qt::MainWindow

  def initialize
    super

    setWindowTitle "Work Flow Project"
    #resize 800,600
    center

    setCentralWidget MainWidget.new
    show
  end

  def center
    qdw = Qt::DesktopWidget.new
    x = (qdw.width - self.width)/2
    y = (qdw.height - self.height)/2
    move x,y
  end
end
