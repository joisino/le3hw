if [ $# != 1 ]; then
    echo "Usage: $0 hexfile"
    exit 1
fi

if [ ! -e ./tmp ]; then
    mkdir ./tmp
fi

cp $1 ./tmp/hexfile
cat ./tmp/hexfile | ../hextodig/hextodig > ./tmp/digfile
../unfolddig/unfolddig ./tmp/digfile > ./tmp/unfolded
../topng/topng ./tmp/unfolded
