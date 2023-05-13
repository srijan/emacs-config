# Setup

1. Install emacs
2. Install firacode nerd font mono
3. Run:

   ``` shellsession
   cd ~
   git clone https://github.com/srijan/emacs-config
   mv .emacs.d .emacs.d.bak
   git clone https://github.com/plexus/chemacs2 .emacs.d
   echo '(("default" . ((user-emacs-directory . "~/emacs-config"))))' > .emacs-profiles.el
   ```
   
4. Start emacs
