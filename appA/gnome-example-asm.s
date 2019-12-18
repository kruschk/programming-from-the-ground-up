# PURPOSE:	This program is meant to be an example of what GUI programs
#		look like written with the GNOME libraries.
#
# INPUT:	The user can only click on the "Quit" button or close the window.
#
# OUTPUT:	The application will close.
#
# PROCESS:	If the user clicks on the "Quit" button, the program will
#		display a dialog asking if they are sure. If they click yes, it
#		will close the application. Otherwise, it will continue
#		running.
#

.section .data

### GNOME definitions - These were found in the GNOME header files for the C
#			language and converted into their assembly equivalents.
#

