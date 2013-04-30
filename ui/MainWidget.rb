require 'Qt'
require 'soap/rpc/driver'
require './DragLabel.rb'

class MainWidget < Qt::Widget
  slots 'submit()'

  def initialize
    super
    @hbox = Qt::HBoxLayout.new
    init_layout
    setLayout @hbox
  end

  def init_layout
    drag_service_1 = DragLabel.new("Item Selection\nAnd Cost Calculation")
    drag_service_1.setFrameStyle(Qt::Frame::StyledPanel | Qt::Frame::Raised)
    drag_service_1.setAlignment(Qt::AlignCenter)
    drag_service_1.setFont(Qt::Font.new("Arial", 14))

    drag_service_2 = DragLabel.new('XP Check')
    drag_service_2.setFrameStyle(Qt::Frame::StyledPanel | Qt::Frame::Raised)
    drag_service_2.setAlignment(Qt::AlignCenter)
    drag_service_2.setFont(Qt::Font.new("Arial", 14))

    drag_service_3 = DragLabel.new('Item Distribution')
    drag_service_3.setFrameStyle(Qt::Frame::StyledPanel | Qt::Frame::Raised)
    drag_service_3.setAlignment(Qt::AlignCenter)
    drag_service_3.setFont(Qt::Font.new("Arial", 14))

    vbox = Qt::VBoxLayout.new
    vbox.addWidget(drag_service_1)
    vbox.addWidget(drag_service_2)
    vbox.addWidget(drag_service_3)
    @hbox.addLayout vbox, 0

    workflow_frame = Qt::Frame.new
    workflow_frame.setFrameStyle(Qt::Frame::StyledPanel)
    @grid_layout = Qt::GridLayout.new
    @grid_layout.setVerticalSpacing(10)

    6.times do |i|
      6.times do |j|
        drag_label = DragLabel.new
        drag_label.setFont(Qt::Font.new("Arial",14))
        @grid_layout.addWidget(drag_label, i, j)
      end
    end
    workflow_frame.setLayout(@grid_layout)

    #@hbox.addLayout(vbox)
    @hbox.addWidget(workflow_frame)

    @out_label = Qt::Label.new()
    @out_label.setAlignment(Qt::AlignCenter)
    @out_label.setFont(Qt::Font.new("Arial", 14))

    submit_button = Qt::PushButton.new('Submit')
    submit_button.setFont(Qt::Font.new("Arial", 14))
    connect(submit_button, SIGNAL('clicked()'), self, SLOT('submit()'))
    vbox = Qt::VBoxLayout.new
    vbox.addWidget(@out_label)
    vbox.addWidget(submit_button)
    @hbox.addLayout(vbox, 0)
  end

  def submit()
    num_services = 0
    6.times do |i|
      6.times do |j|
        if @grid_layout.itemAtPosition(i,j).widget().text != "      "
          num_services += 1
        end
      end
    end
    if num_services >= 1
      begin
        user = Qt::InputDialog.getText(self, "Field 1","Field: Username")
        item = Qt::InputDialog.getText(self, "Field 2","Field: Item")
        amount = Qt::InputDialog.getInt(self, "Field 3","Field: Amount")
        driver = SOAP::RPC::Driver.new('http://orthrus.kyliejo.com:8080/', 'urn:ruby:ItemSelection')
        driver.add_method("item_select", "username", "item", "amount")
        @out_label.setText(driver.item_select(user, item, amount).to_s)
      rescue
        # Do nothing if error
      end
    end
  end
end
