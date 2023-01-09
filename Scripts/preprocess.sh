#!/bin/bash
if ! test -f ../FACIAL/video_preprocess/train1.mp4  
then 
echo 'Training video or Test audio are not found'
exit
fi

sudo echo

# Docker container name
# while : 
# do
#     echo "Enter a unique name:"
#     read docname 
#     if [ ! -z "$docname" ]
#     then 
#     break
#     fi
# done

ffmpeg -i ../FACIAL/video_preprocess/train1.mp4 -r 30 ../FACIAL/video_preprocess/train1_image/%d.png  

#Docker for openface
# cd ../FACIAL/video_preprocess/train1_image  
# path=$(pwd)
# cd ../../../Scripts  
# sudo docker run -itd --name "$docname"  -v "$path":/home/openface-build/train1_512_audio --rm algebr/openface:latest 
# sudo docker exec -ti "$docname" git clone https://github.com/xianyi/OpenBLAS.git
# sudo docker exec -ti "$docname" cd OpenBLAS
# sudo docker exec -ti "$docname" make -j4
# sudo docker exec -ti "$docname" make install
# sudo docker exec -ti "$docname" cd ..
# sudo docker exec -ti "$docname" ./build/bin/FeatureExtraction -fdir ./train1_512_audio 
# sudo docker exec -ti "$docname" cp processed/train1_512_audio.csv train1_512_audio
# sudo docker stop "$docname"
# cp ../FACIAL/video_preprocess/train1_image/train1_512_audio.csv ../FACIAL/video_preprocess/train1_openface  
# rm -f ../FACIAL/video_preprocess/train1_image/train1_512_audio.csv  

#get 5-point landmarks and place detections inside train1_image
conda activate mtcnn
python ../Deep3DFaceRecon_pytorch/lands.py -i ../FACIAL/video_preprocess/train1_image -o ../FACIAL/video_preprocess/detections  
cp -R ../FACIAL/video_preprocess/detections ../FACIAL/video_preprocess/train1_image/detections  

#strat extracting 3d mesh of the face, copy .mat files to train1_deep3Dface, and delete detections from train1_image
conda activate deep
cd ../Deep3DFaceRecon_pytorch/  
python test.py --name=model --epoch=20 --img_folder=../FACIAL/video_preprocess/train1_image  
cd ./checkpoints/model/results/train1_image  
cp ./epoch_20_000000/*.mat ../../../../../FACIAL/video_preprocess/train1_deep3Dface  
cd ../.. && rm -r ./results  
cd ../../..  
rm -r ./FACIAL/video_preprocess/train1_image/detections  





