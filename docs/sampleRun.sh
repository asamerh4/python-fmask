docker run \
--rm \
--memory=12g \
--memory-swap=12g \
-e inputId="s3://s2-sync/tiles/33/X/WH/2016/9/9/1/" \
-e outputId="s3://s2-derived/tiles/33/X/WH/2016/9/9/1/" \
-it \
opus-test08.eoc.dlr.de:5000/s2-fmask:fmask0.4.2-snap4.0-v0.2 \
./run-fmask.sh