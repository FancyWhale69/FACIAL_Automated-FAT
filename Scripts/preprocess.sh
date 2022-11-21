#!/bin/bash
if ! test -f ../FACIAL/video_preprocess/train1.mp4 || ! test -f ../FACIAL/video_preprocess/test1.wav
then 
echo 'Training video or Test audio are not found'
exit
fi

#legacy code
# while : 
# do
#     echo "Enter a unique name:"
#     read docname 
#     if [ ! -z $docname ]
#     then 
#     break
#     fi
# done

#get 5-point landmarks and place detections inside train1_image
conda activate mtcnn
ffmpeg -i ../FACIAL/video_preprocess/train1.mp4 -r 30 ../FACIAL/video_preprocess/train1_image/%d.png || exit 1
python ../Deep3DFaceRecon_pytorch/lands.py -i ../FACIAL/video_preprocess/train1_image -o ../FACIAL/video_preprocess/detections
cp -R ../FACIAL/video_preprocess/detections ../FACIAL/video_preprocess/train1_image/detections || exit 1

#strat extracting 3d mesh of the face, copy .mat files to train1_deep3Dface, and delete detections from train1_image
conda activate deep
cd ../Deep3DFaceRecon_pytorch/ || exit 1
python test.py --name=model --epoch=20 --img_folder=../FACIAL/video_preprocess/train1_image
cd ./checkpoints/model/results/train1_image || exit 1
cp ./epoch_20_000000/*.mat ../../../../../FACIAL/video_preprocess/train1_deep3Dface || echo "An Error happened while coping files from Deep3DFaceRecon_pytorch/checkpoints/model/results/train1_image/epoch_20_000000" ; exit 1
cd ../.. && rm -r ./results || exit 1
cd ../../.. || exit 1
rm -r ./FACIAL/video_preprocess/train1_image/detections || exit 1


#legacy code
# cd ../FACIAL/video_preprocess/train1_image
# path=$(pwd)
# cd ../train1_openface
# path2=$(pwd)
# cd ../../../Scripts
# sudo docker run -itd --name $docname  -v "$path":/home/openface-build/train1_512_audio --rm algebr/openface:latest 
# sudo docker exec -ti $docname ./build/bin/FeatureExtraction -fdir ./train1_512_audio 
# sudo docker exec -ti $docname cp processed/train1_512_audio.csv train1_512_audio
# sudo docker stop $docname
# cp ../FACIAL/video_preprocess/train1_image/train1_512_audio.csv ../FACIAL/video_preprocess/train1_openface
# rm -f ../FACIAL/video_preprocess/train1_image/train1_512_audio.csv
