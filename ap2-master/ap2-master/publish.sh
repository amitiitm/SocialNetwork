echo "============================================================"
echo 'Updating AP2 3001'
echo "============================================================"
echo " "
cd /home/ranjan/ap2/ap2 && git checkout master && git pull 
wait $!
TAG=$(git describe --abbrev=0 --tags)
echo "Fetching TAG $TAG"
git checkout $TAG && touch tmp/restart.txt
wait $!
echo " "
echo "============================================================"
echo 'Updating AP2 '
echo "============================================================"
echo " "
cd /opt/openfo/ap2 && git checkout master && git pull 
wait $!
echo "Fetching TAG $TAG"
git checkout $TAG && touch tmp/restart.txt
echo " "echo " "
echo "============================================================"
echo 'Updating OPENFO 3000'
echo "============================================================"
cd /home/ranjan/openfo && git checkout master && git pull 
wait $!
TAG=$(git describe --abbrev=0 --tags)
echo "Fetching TAG $TAG"
git checkout $TAG && touch tmp/restart.txt
wait $!

echo "============================================================"
echo 'Updating Openfo'
echo "============================================================"
cd /opt/openfo/website && git checkout master && git pull 
wait $!
TAG=$(git describe --abbrev=0 --tags)
echo "Fetching TAG $TAG"
git checkout $TAG && touch tmp/restart.txt
wait $!



