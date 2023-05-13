sudo docker login
cd Loader
sudo docker build --build-arg USERNAME=MelSaFer --build-arg PASSWORD=3trZoWOalvOKN7tQ --build-arg DATABASE=OpenLyricsSearch --build-arg ARTISTS_COLLECTION=artistsCollection --build-arg LYRICS_COLLECTION=lyricsCollection -t melanysf/loader-p2 .
sudo docker push melanysf/loader-p2
sudo docker run melanysf/loader-p2