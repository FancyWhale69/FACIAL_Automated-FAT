#!/bin/bash
echo "Are you sure you want to clean the whole project? it will be like starting a new one (Back up your video and audio files)?"

select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
done

rm -r -f ../FACIAL/video_preprocess/*
rm -r ../FACIAL/Results
rm -r ../FACIAL/face2vid/datasets/train3/*
rm -r ../FACIAL/face2vid/checkpoints/*
rm -r ../FACIAL/examples/test_image/*
rm -r ../FACIAL/examples/rendering/*
rm -r ../Deep3DFaceRecon_pytorch/checkpoints/model/results

mkdir ../FACIAL/video_preprocess/train1_image

mkdir ../FACIAL/video_preprocess/detections
mkdir ../FACIAL/video_preprocess/train1_openface
mkdir ../FACIAL/video_preprocess/train1_deep3Dface

if [ ! -d "../FACIAL/Results" ]
then 
mkdir ../FACIAL/Results
fi
