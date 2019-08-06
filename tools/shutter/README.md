# Shutter

Shutter is a screen capture and image annotation tool for Linux.

BUT, for the image annotation "Edit" button to work, you need to install some extra libraries.
See https://itsfoss.com/shutter-edit-button-disabled/

Here's how I got the "Edit" button to work on Linux Mint 19.1:

1. Install the following dependencies of libgoo-canvas-perl_0.06-2ubuntu3_amd64.deb:
sudo apt install libextutils-pkgconfig-perl
sudo apt install libextutils-depends-perl

2. Now install the following deb packages (copies are in this directory):
sudo dpkg -i libgoocanvas3_1.0.0-1_amd64.deb
sudo dpkg -i libgoocanvas-common_1.0.0-1_all.deb
sudo dpkg -i libgoo-canvas-perl_0.06-2ubuntu3_amd64.deb 


Other possible screen capture and screen recording apps:
https://filmora.wondershare.com/video-editing-tips/screen-capture-tools-for-linux.html
NOTE: "ScreenStudio" is described here as Java-based screen-recording app. This might
       be worth exploring for both Linux and Windows.


JeremyC 6-8-2019
