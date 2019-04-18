Copy files
	initHuygens.sh
	initGui.sh
	hupro.sh
into you .home folder on doom30.metacentrum.cz server

1) start cmd and ssh session (ssh username@doom30.metacentrum.cz) or use putty.
2) run ./initHuygens.sh
3) start your VNC client with provided informations
4) start xterm on your remote desktop and run ./hupro.sh
5) logout properly after you finish. gui will be shut down when your reservation expire

LINUX users:
start ./dekonvoluce.sh in your terminal everything will be done for you automatically till start ssvnc. You can use SHIFT+INSERT to paste a vnc login from the clipboard.

Script needs to be adjusted in case
1] you want to use different VNC viewer
2] you log in with ssh-key to metacentrum servers

dekonvoluce.sh needs to be rewriten to dekonvoluce.bat script for windows users.

ondrej.sebesta@natur.cuni.cz
	
