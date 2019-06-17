TOOLS_DIR=$*

# Description:
#   Cut-down of ImageMagick installation (because it is over 80Mb).
#   This includes the often used convert.exe image conversion tool.
#
#   ImageMagick is available for both Windows and Linux. The Windows
#   installation was used here, and was downloaded from:
#   http://www.imagemagick.org/download/binaries/

#   Note: ImageMagick-6.9.4-7-Q8-x64-static.exe was used, as version
#         7 did not seem to include convert.exe
#
#   Note: Various files were removed from the installation to use
#         less disk space. These include:
#         ffmpeg.exe,  compare.exe, conjure.exe, composite.exe, mogrify.exe, 
#         identify.exe,  stream.exe, montage.exe, imdisplay.exe
#
#   Note: The following is a C# GUI wrapper tool around ImageMagick:
#         https://github.com/MattDolan/ImageConverter/tree/master/vs2010
#         This is handy becaue it displays the command-line used for
#         your selected convert.exe conversion.
#
#   Note: If you get an error when running convert.exe on Windows, check
#         that you are not invoking the Windows built-in convert.exe!!
#
#   Note: It seems that newer versions of ImageMagick have renamed 
#         convert.exe to magick.exe.
#
# References:
#   http://www.howtogeek.com/109369/how-to-quickly-resize-convert-modify-images-from-the-linux-terminal/
#   http://www.imagemagick.org/script/convert.php
#
# Usage:
#   convert
#
# Example usage:
#   convert piechart.png -resize 50% piechart.jpg
#
# Examples from using GUI tool https://github.com/MattDolan/ImageConverter/tree/master/vs2010:
#   magick.exe -density 150 c:\tmp\chapter1-arial.png -quality 100 c:\tmp\out.tiff
#   magick.exe -density 150 c:\tmp\chapter1-arial.png -quality 100 c:\tmp\out.jpg
#   magick.exe -density 150 c:\tmp\chapter1-arial.png -quality 100 c:\tmp\chapter1-arial.gif
#   magick.exe -density 150 c:\tmp\chapter1-arial.png -quality 100 c:\tmp\chapter1-arial.bmp
# 
function convert() {
    if [ "$1" = '-h' ]; then
        usage convert
        return
    fi

    # Unzip imagemagick directory if it does not already exist.
    # (We save about 10Mb by having the files left zipped-up).
    if [ ! -d "$TOOLS_DIR/image/imagemagick/" ]; then
        echo "INFO: Unzip $TOOLS_DIR/image/imagemagick/imagemagick.zip !"
        return
    fi

    $TOOLS_DIR/image/imagemagick/convert.exe $*
}
