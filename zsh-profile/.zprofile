case $TERM in
    xterm*)
        precmd () {print -Pn "\e]0;`hostname`\a"}
        ;;
esac