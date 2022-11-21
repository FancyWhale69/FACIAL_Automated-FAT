#!/bin/bash

#Start the pre-training preprocess

while : 
do
    if test -f ../FACIAL/video_preprocess/train1_openface/train1_512_audio.csv
    then 
    break
    fi
    read -p "Please place train1_512_audio.csv in FACIAL/video_preprocess/train1_openface then press Enter"
done

while : 
do
    if [ ! -z "$(ls -A ../FACIAL/video_preprocess/train1_deep3Dface)" ]
    then 
    break
    fi
    read -p "Please place *.mat files in FACIAL/video_preprocess/train1_deep3Dface then press Enter"
done

conda activate facial


cd ../FACIAL

cd face_render/face3d/mesh/cython
python setup.py build_ext -i
cd ../../../

python handle_netface.py
python fit_headpose.py --csv_path '../video_preprocess/train1_openface/train1_512_audio.csv' --deepface_path '../video_preprocess/train1_deep3Dface/train1.npz' --save_path '../video_preprocess/train1_posenew.npz'
python render_netface_fitpose.py --real_params_path '../video_preprocess/train1_posenew.npz' --outpath '../video_preprocess/train_A/'

ffmpeg -y -i "../video_preprocess/train1.mp4" -acodec pcm_s16le -f wav -ac 1 -ar 16000  ../video_preprocess/train1.wav
cp -r ../video_preprocess/train1.wav ../examples/audio/train1.wav


cd ../audio2face
python audio_preprocessing.py
python fintuning2-trainheadpose.py --audiopath '../examples/audio_preprocessed/train1.pkl' --npzpath '../video_preprocess/train1_posenew.npz' --cvspath '../video_preprocess/train1_openface/train1_512_audio.csv' --pretainpath_gen '../audio2face/checkpoint/obama/Gen-20-0.0006273046686902202.mdl' --savepath './checkpoint/train1'

cd ..
cp -r ./video_preprocess/train_A ./face2vid/datasets/train3/train_A
cp -r ./video_preprocess/train1_image ./face2vid/datasets/train3/train_B

cd face2vid


#if user is not present(30 sec passes) choose the gpu with the lowest usage
gp=$(nvidia-smi --list-gpus | wc -l)
x=-1
while [ $x -ge $gp -o $x -lt 0 ]
do 

echo -n "[ "

for ((i=0; i<$gp; i++))
    do
    echo -n "$i "
    done
echo "] Choose gpu id: "

read -t 30 var

if [ -z $var ]
then 
x=$(nvidia-smi --query-gpu=memory.free,index --format=csv,nounits,noheader | sort -nr | head -1 | awk '{ print $NF }')
break
fi
x=$(( $var ))
done

python train.py --blink_path "../video_preprocess/train1_openface/train1_512_audio.csv" --name train3 --model pose2vid --dataroot ./datasets/train3/ --netG local --ngf 32 --num_D 3 --tf_log --niter_fix_global 0 --label_nc 0 --no_instance --save_epoch_freq 2 --lr=0.0001 --resize_or_crop resize --no_flip --verbose --n_local_enhancers 1 --gpu_ids $x