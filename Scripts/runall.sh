#!/bin/bash
if ! test -f ../FACIAL/video_preprocess/train1.mp4 || ! test -f ../FACIAL/video_preprocess/test1.wav
then 
echo 'Training video or Test audio are not found'
exit
fi

echo

bash -i preprocess.sh
if [ "$?" -eq 1 ]
then
echo "An error occured in preprocessing"
exit
fi

bash -i training.sh
bash -i infrence.sh