docker run \
--rm \
--memory=12g \
--memory-swap=12g \
-e AWS_DEFAULT_REGION="eu-central-1"
-e inputId="s3://s2-sync/tiles/33/X/WH/2016/9/9/1/" \
-e outputId="s3://s2-derived/tiles/33/X/WH/2016/9/9/1/" \
-it \
asamerh4/python-fmask:fmask0.4-aws-3b19a7b ./run-fmask.sh