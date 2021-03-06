WS-Project for COMP4302
=======================

Group Members
-------------
-	Andrew Swistak
-	Kylie Jo Infield
-	Kenneth Brown

Compilation
------------
Not necessary as this is written in Ruby.

Installation and Usage
------------
Before trying to install the system, you should only try to run this on a Linux platform. You will need the following software:
- Java 1.6+
- Minecraft Server from http://www.minecraft.net/download
- Ruby 1.9+
- The Ruby gem 'soap4r-ruby1.9' (```gem install soap4r-ruby1.9```)
- Qt Ruby bindings. (```libqtruby4shared2``` on Ubuntu distributions, ```kdebindings-qtruby``` on ArchLinux)

First, start off by running a minecraft server in a screen. You will need to know the name of the screen, so I recommend naming it something memorable:

    screen -S MinecraftServer

Once the screen is running, start the minecraft server with

    java -jar /path/to/minecraft-server.jar

A folder with configuration files and other data will be generated at the location of the server .jar file. You will need to know this location later. You can now exit the screen by pressing ```CTRL+A``` then ```d```.

Next, you need to get the three services up and running. You should modify each script to match the information for your minecraft server and screen session. The ```$HOST_NAME_OF_SERVICE``` for each service should be where the ruby file will execute. The value of the ```$SCREEN_NAME``` should be the name you gave to the screen session when you started the minecraft server. ```$USER_RUNNING_MC_SERVER``` should contain the user you ran the server as. **If you didn't execute the server as different user, this will still need to be set to whatever your username is.** For the XpCheckServer.rb, you need to set the path to player save file. The location will be somewhere within the folder created by the server .jar file, typically in another folder called *world/*. Once you have everything adjusted to your setup, run the services as root.

The last thing to do is run the interface. Before running the UI, change the value ```$HOST_NAME_OF_ITEM_SELECT_SERVICE``` in WainWidget.rb to the URL or IP of where the first service is running. More than likely, you are running it locally, so just change it to localhost. Now, call the UI by typing ```./WorkFlowUi.rb``` or ```ruby WorkFlowUI.rb``` from the ```ui/``` directory. Now all you need to do is drag some elements and click submit. You will need to provide a target user. This should be the username picked when creating a Mojang account. You will also need to provide the name of an item. You can just use "Stone" for this field, but if you are interested, you can check ItemSelectServer.rb to see a list of the available items.

Unfortunately, to actually test if the services have given you items, you need to purchase access to the Minecraft game from Mojang and log on the server via the Minecraft client (also downloadable from http://www.minecraft.net/download).
