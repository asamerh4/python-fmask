#!/bin/bash
set -e

source activate myenv

export PATH=$PATH:/opt/conda/envs/myenv/bin:/bin
export GDAL_DATA=/opt/conda/envs/myenv/share/gdal

##RIOS
export RIOS_DFLT_DRIVER='GTiff'
export RIOS_DFLT_DRIVEROPTIONS='COMPRESS=LZW TILED=YES BLOCKXSIZE=256 BLOCKYSIZE=256'
export RIOS_DFLT_BLOCKXSIZE=256
export RIOS_DFLT_BLOCKYSIZE=256

##TBD...
export OPENBLAS_NUM_THREADS=1
export OMP_NUM_THREADS=1
export OMP_THREAD_LIMIT=1
export GOTO_NUM_THREADS=1
export OMP_DISPLAY_ENV=TRUE
export NUMEXPR_NUM_THREADS=1

#AWS S2-TILES
#s3://s2-sync/tiles/33/X/WH/2016/9/9/1/ -> S3 input pattern
#s3://s2-derived/tiles/33/X/WH/2016/9/9/1/ -> S3 output pattern

#get tile from S3
/opt/conda/bin/aws s3 sync ${inputId} ./tile

echo "###################"
echo "#pythonfmask 0.4.2#"
echo "###################"
echo ""
echo "S2-granule: "${inputId}
echo ""
echo "-->stack of ALL the bands, at the 20m resolution..."
gdalbuildvrt -resolution user -tr 20 20 -separate allbands.vrt tile/B0[1-8].jp2 tile/B8A.jp2 tile/B09.jp2 tile/B1[0-2].jp2
echo "done!"
echo ""
echo "-->Make a separate image of the per-pixel sun and satellite angles..."
fmask_sentinel2makeAnglesImage.py -i tile/*.xml -o angles.img
echo "done!"
echo ""
echo "-->create the cloud mask image..."
fmask_sentinel2Stacked.py -v -a allbands.vrt -z angles.img -o tile/CLOUDMASK.tif
echo "done!"
echo ""
echo "-->move to S3"
/opt/conda/bin/aws s3 sync tile/ ${outputId}
echo "done! bye."

rm ~/*.img*
rm ~/*.vrt*
rm -rf ~/tile


