#!/bin/bash

#get results from the model

def="test1"
echo "Press enter to use default name [$def] or type the new name: "
read -t 60 name


if [ ! -z "$name" ]
then
def=$name
fi

defe=20
echo "Press enter to use default epoch [$defe] or type the new epoch: "
read -t 30 epo


if [ ! -z "$epo" ]
then
defe=$epo
fi

conda activate facial

cd ../FACIAL  

cp -r ./video_preprocess/"$def.wav" ./examples/audio/"$def.wav"  

cd audio2face  

#if audio is already processed, skip this step
if ! test -f ../FACIAL/examples/test-result/"$def.npz"
then
python audio_preprocessing.py  
python test.py --audiopath ../examples/audio_preprocessed/"$def.pkl" --checkpath ./checkpoint/train1/Gen-10.mdl  
fi

cd ../face_render  

#delete old renders
if [ -d "../examples/rendering/$def" ]
then
rm -r "../examples/rendering/$def"
fi

python rendering_gaosi.py --train_params_path ../video_preprocess/train1_posenew.npz --net_params_path ../examples/test-result/"$def.npz" --outpath '../examples/rendering/'  

cd ..
rm -rf ./face2vid/datasets/train3/test_A ./face2vid/datasets/train3/test_B  
cp -r ./examples/rendering/"$def" ./face2vid/datasets/train3/test_A  
cp -r ./examples/rendering/"$def" ./face2vid/datasets/train3/test_B  

cd face2vid  
python test_video.py --test_id_name "$def" --blink_path "../examples/test-result/$def.npz" --name train3 --model pose2vid --dataroot ./datasets/train3/ --which_epoch "$defe" --netG local --ngf 32 --label_nc 0 --n_local_enhancers 1 --no_instance --resize_or_crop resize  
ffmpeg -y -i "../examples/test_image/$def/test_1.avi" -i "../video_preprocess/$def.wav" -c copy "../examples/test_image/$def/test_1_audio.avi"  
ffmpeg -y -i "../examples/test_image/$def/test_1_audio.avi"  "../examples/test_image/$def/test_1_audio.mp4"  

cp ../examples/test_image/"$def"/test_1_audio.mp4 ../Results/"$def"_epoch_"$defe"_results.mp4  
 
echo "Output is saved in Results folder"