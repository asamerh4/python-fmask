#!/bin/bash
set -e

export RIOS_DFLT_DRIVER='GTiff'
export RIOS_DFLT_DRIVEROPTIONS='COMPRESS=LZW TILED=YES BLOCKXSIZE=256 BLOCKYSIZE=256'
export RIOS_DFLT_BLOCKXSIZE=256
export RIOS_DFLT_BLOCKYSIZE=256

export MKL_NUM_THREADS=1
export OMP_NUM_THREADS=1,3,5
#export OMP_DYNAMIC=false
export OMP_THREAD_LIMIT=1
export GOTO_NUM_THREADS=1
export OMP_DISPLAY_ENV=TRUE
export NUMEXPR_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1


l1File=$(ls /s2/raw_granule/S2*.xml)
outputFile=${inputId}-fmask.nc


if [[ ${inputId:82:1} > M ]]; then
      format=SENTINEL-2-MSI-20M-UTM${inputId:80:2}N
else
      format=SENTINEL-2-MSI-20M-UTM${inputId:80:2}S
fi

echo "###################"
echo "#pythonfmask 0.4.2#"
echo "###################"
echo ""
echo "S2-granule: "${inputId}
echo ""
echo "-->stack of ALL the bands, at the 20m resolution..."
gdalbuildvrt -resolution user -tr 20 20 -separate allbands.vrt /s2/raw_granule/GRANULE/*/IMG_DATA/S2*_B0[1-8].jp2 /s2/raw_granule/GRANULE/*/IMG_DATA/S2*_B8A.jp2 /s2/raw_granule/GRANULE/*/IMG_DATA/S2*_B09.jp2 /s2/raw_granule/GRANULE/*/IMG_DATA/S2*_B1[0-2].jp2
echo "done!"
echo ""
echo "-->Make a separate image of the per-pixel sun and satellite angles..."
fmask_sentinel2makeAnglesImage.py -i /s2/raw_granule/GRANULE/*/S2*.xml -o angles.img
echo "done!"
echo ""
echo "-->create the cloud mask image..."
fmask_sentinel2Stacked.py -a allbands.vrt -z angles.img -o cloud.tif
echo "done!"
echo ""
echo "-->merge cloud-image to original granule..."
./snap-4.0/bin/gpt -e -c 2G snap-4.0/fmask-read-merge-graph.xml -PmasterProduct=${l1File} -PinputFormat=${format} -t ${outputFile} -f NetCDF4-BEAM cloud.tif
echo "done!"
echo ""
echo "-->move to FS"
mv ${outputFile} /s2/fmask_granules/
echo "done! bye."

rm ~/*.tif*
rm ~/*.img*
rm ~/*.vrt*


