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

cd ../FACIAL || exit 1

cp -r ./video_preprocess/"$def.wav" ./examples/audio/"$def.wav" || exit 1

cd audio2face || exit 1

#if audio is already processed, skip this step
if ! test -f ../FACIAL/examples/test-result/"$def.npz"
then
python audio_preprocessing.py || exit 1
python test.py --audiopath ../examples/audio_preprocessed/"$def.pkl" --checkpath ./checkpoint/train1/Gen-10.mdl || exit 1
fi

cd ../face_render || exit 1

#delete old renders
if [ -d "../examples/rendering/$def" ]
then
rm -r "../examples/rendering/$def"
fi

python rendering_gaosi.py --train_params_path ../video_preprocess/train1_posenew.npz --net_params_path ../examples/test-result/"$def.npz" --outpath '../examples/rendering/' || exit 1

cd ..
rm -rf ./face2vid/datasets/train3/test_A ./face2vid/datasets/train3/test_B || exit 1
cp -r ./examples/rendering/"$def" ./face2vid/datasets/train3/test_A || exit 1
cp -r ./examples/rendering/"$def" ./face2vid/datasets/train3/test_B || exit 1

cd face2vid || exit 1
python test_video.py --test_id_name "$def" --blink_path "../examples/test-result/$def.npz" --name train3 --model pose2vid --dataroot ./datasets/train3/ --which_epoch "$defe" --netG local --ngf 32 --label_nc 0 --n_local_enhancers 1 --no_instance --resize_or_crop resize || exit 1
ffmpeg -y -i "../examples/test_image/$def/test_1.avi" -i "../video_preprocess/$def.wav" -c copy "../examples/test_image/$def/test_1_audio.avi" || exit 1
ffmpeg -y -i "../examples/test_image/$def/test_1_audio.avi"  "../examples/test_image/$def/test_1_audio.mp4" || exit 1

cp ../examples/test_image/"$def"/test_1_audio.mp4 ../Results/"$def"_epoch_"$defe"_results.mp4 || exit 1
 
echo "Output is saved in Results folder"