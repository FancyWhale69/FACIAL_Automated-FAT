#!/bin/bash

#This script will install all the files project from github, and place modles and extra files in their places.
#If the env are already installed please press 2 when promted by the script



echo "do you want to install the envs & docker image?"

nvd=1

select yn in "Yes" "No"; do
    case $yn in
        Yes ) conda env create -f ../envs/deep.yml; conda env create -f ../envs/mtcnn.yml; conda env create -f ../envs/facial.yml; sudo docker pull algebr/openface; nvd=0; break;;
        No ) break;;
    esac
done







cd ..
git clone https://github.com/zhangchenxu528/FACIAL.git || echo "$_ failed to download"; exit 1
git clone https://github.com/sicxu/Deep3DFaceRecon_pytorch.git || echo "$_ failed to download"; exit 1
conda activate deep
cd Deep3DFaceRecon_pytorch || echo "$_ dir does not exist"; exit 1
git clone https://github.com/NVlabs/nvdiffrast || echo "$_ failed to download"; exit 1

if [ $nvd -eq 0 ]
then
cd nvdiffrast || exit 1
pip install .
cd ..
fi


git clone https://github.com/deepinsight/insightface.git || echo "$_ failed to download"; exit 1
cp -r ./insightface/recognition/arcface_torch ./models/
# cp ../models/01_MorphableModel.mat ./BFM/01_MorphableModel.mat
# cp ../models/Exp_Pca.bin ./BFM/Exp_Pca.bin

mkdir ./checkpoints
mkdir ./checkpoints/model
# cp ../models/epoch_20.pth ./checkpoints/model/epoch_20.pth

cd ..

mkdir -p ./FACIAL/audio2face/checkpoint/obama
mkdir ./FACIAL/Results
mkdir ./FACIAL/video_preprocess
mkdir ./FACIAL/face_render/BFM
conda activate facial
if [ $nvd -eq 0 ]
then
pip install gdown
fi

#https://drive.google.com/uc?id=
gdown -O ./Deep3DFaceRecon_pytorch/BFM/01_MorphableModel.mat https://drive.google.com/uc?id=1K3Ojg5waDaYexNYkg006zpqR-BNobvRi || echo "$_ failed to download"; exit 1
gdown -O ./Deep3DFaceRecon_pytorch/BFM/Exp_Pca.bin https://drive.google.com/uc?id=1VitGK-HEsIVyAf0LLyBZ7gYM6Pz1H_71 || echo "$_ failed to download"; exit 1
gdown -O ./Deep3DFaceRecon_pytorch/checkpoints/model/epoch_20.pth https://drive.google.com/uc?id=1xRZSsoPF3O3dMr3ZhRI04MLPC7pSMH0n || echo "$_ failed to download"; exit 1

gdown -O ./FACIAL/audio2face/checkpoint/obama/Gen-20-0.0006273046686902202.mdl https://drive.google.com/uc?id=1gA14zQZm3bOxSNkbuYdBkcDNxrX1POJv || echo "$_ failed to download"; exit 1
gdown -O ./FACIAL/audio2face/ds_graph/output_graph.pb https://drive.google.com/uc?id=183hTRI96jIoFehSH79LUhFIlnao8mVmT || echo "$_ failed to download"; exit 1
gdown -O ./FACIAL/face_render/BFM/BFM_model_front.mat https://drive.google.com/uc?id=1FJy1AkDUHY5QsiOA0alc90czw-XiikJ7 || echo "$_ failed to download"; exit 1
gdown -O ./FACIAL/face_render/BFM/std_exp.txt https://drive.google.com/uc?id=1BKi_oTDoNaHpt_sbkpgO1CwvbEMTLCH7 || echo "$_ failed to download"; exit 1


# cp ./models/Gen-20-0.0006273046686902202.mdl ./FACIAL/audio2face/checkpoint/obama/Gen-20-0.0006273046686902202.mdl
# cp ./models/output_graph.pb ./FACIAL/audio2face/ds_graph/output_graph.pb
# cp ./models/BFM_model_front.mat ./FACIAL/face_render/BFM/BFM_model_front.mat
# cp ./models/std_exp.txt ./FACIAL/face_render/BFM/std_exp.txt


cp ./Scripts/lands.py ./Deep3DFaceRecon_pytorch/lands.py
rm ./FACIAL/face_render/handle_netface.py
cp ./Scripts/handle_netface.py ./FACIAL/face_render/handle_netface.py
rm ./FACIAL/face2vid/data/base_dataset.py
cp ./Scripts/base_dataset.py ./FACIAL/face2vid/data/base_dataset.py

mkdir ./FACIAL/video_preprocess/train1_image
mkdir ./FACIAL/video_preprocess/detections
mkdir ./FACIAL/video_preprocess/train1_openface
mkdir ./FACIAL/video_preprocess/train1_deep3Dface

 echo "If you didn't see any errors, Then you are ready to go"