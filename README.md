find-here-mode
==============

Command and minor mode to run the shell find command and open from results

Installation
------------

Put find-here-mode.el to somewhere Emacs can find them. Add the
following to your `.emacs`:

    (require 'find-here-mode)

Usage
-----

Call `M-x run-find-here` for a prompt for a name pattern. The results
for running the find command in the same directory as the current
buffer's file will be listed in a new buffer. Enter to open a file,
`q` to quit.