#!/usr/bin/ruby

require 'Qt'
require './MainWindow.rb'

app = Qt::Application.new ARGV
MainWindow.new
app.exec
