read -rep "Do you really want to exit? [y|n]: " response
case $response in
   [Yy]*) echo "Yes"; exit 0 ;;
   [Nn]*) echo "No"; exec bash -l ;;
       *) exit
esac
