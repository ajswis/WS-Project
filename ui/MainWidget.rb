require 'Qt'
require './DragLabel.rb'
require './WorkflowWidget.rb'

class MainWidget < Qt::Widget
  slots 'submit()'

  def initialize
    super
    @hbox = Qt::HBoxLayout.new
    init_layout
    init_menus
    setLayout @hbox
  end

  def init_layout
    drag_service_1 = DragLabel.new('Service 1', true)
    drag_service_1.setFrameStyle(Qt::Frame::StyledPanel | Qt::Frame::Raised)
    drag_service_1.setAlignment(Qt::AlignCenter)
    drag_service_1.setFont(Qt::Font.new("Arial", 14))

    drag_service_2 = DragLabel.new('Service 2', true)
    drag_service_2.setFrameStyle(Qt::Frame::StyledPanel | Qt::Frame::Raised)
    drag_service_2.setAlignment(Qt::AlignCenter)
    drag_service_2.setFont(Qt::Font.new("Arial", 14))

    drag_service_3 = DragLabel.new('Service 3', true)
    drag_service_3.setFrameStyle(Qt::Frame::StyledPanel | Qt::Frame::Raised)
    drag_service_3.setAlignment(Qt::AlignCenter)
    drag_service_3.setFont(Qt::Font.new("Arial", 14))

    publish_button = Qt::PushButton.new("Register\nServices")
    publish_button.setFont(Qt::Font.new("Arial", 14))

    vbox = Qt::VBoxLayout.new
    vbox.addWidget(drag_service_1)
    vbox.addWidget(drag_service_2)
    vbox.addWidget(drag_service_3)
    vbox.addWidget(publish_button)
    @hbox.addLayout(vbox, 0)

    #setup_frame = WorkflowWidget.new
    #vbox = Qt::VBoxLayout.new
    #vbox.addWidget setup_frame
    #@hbox.addLayout vbox, 1
    workflow_frame = Qt::Frame.new
    workflow_frame.setFrameStyle(Qt::Frame::StyledPanel)
    #workflow_frame.setFrameShape(Qt::Frame::Box)
    #workflow_frame.setFixedSize(200,200)
    @grid_layout = Qt::GridLayout.new
    @grid_layout.setVerticalSpacing(10)

    6.times do |i|
      6.times do |j|
        drag_label = DragLabel.new
        #drag_label.setFont(Qt::Font.new("Arial",14))
        @grid_layout.addWidget(drag_label, i, j)
      end
    end
    workflow_frame.setLayout(@grid_layout)

    #@hbox.addLayout(vbox)
    @hbox.addWidget(workflow_frame)

    out_label = Qt::Label.new('Output')
    out_label.setAlignment(Qt::AlignCenter)
    out_label.setFont(Qt::Font.new("Arial", 14))

    submit_button = Qt::PushButton.new('Submit')
    submit_button.setFont(Qt::Font.new("Arial", 14))
    vbox = Qt::VBoxLayout.new
    vbox.addWidget(out_label)
    vbox.addWidget(submit_button)
    @hbox.addLayout(vbox, 0)

    connect(submit_button, SIGNAL('clicked()'), self, SLOT('submit()'))
  end

  def init_menus
  end

  def submit()
  end
end
