# Not an automated script, just a collection of tweaks to the PS1 prompt

shorten_path() {
    pwd | sed -E 's|^/home/[^/]+|~|; s|/([^/]{1})[^/]*/|\1/|g'
}
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]$(shorten_path)\[\033[00m\]\n\$ '
