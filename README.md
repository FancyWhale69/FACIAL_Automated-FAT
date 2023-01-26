# FACIAL_Automated-FAT
## GOAL
A colliction of scripts that automate the process of setting up, training, and infrence of [FACIAL](https://github.com/zhangchenxu528/FACIAL).

## Table Of Contents
1. [Features](#features)
2. [Scripts](#scripts)
3. [Prerequisite](#prerequisite)
4. [How to use it](#steps)
    - [training only](#training-only)
    - [infrence only](#infrence-only)
5. [openface using windows](#openface-using-windows)  
6. [openface using docker](#openface-using-docker)
7. [Notes](#notes)

## Features
- installation and setup of all necessary environments and dependencies, like: [deep3Dface](https://github.com/sicxu/Deep3DFaceRecon_pytorch).
- one script to rule them all, just run the runall.sh file to preprocess, train, and infer.
- automatically chooses the least utilized GPU if the user is not present.
- ~~multiable safe guards to ensure everything runs smoothly.~~ Removed, causes some issues.
- made FACIAL compatable with the output of Deep3DFaceRecon_pytorch.
- changed some deprecated functions in FACIAL.
- provided a python script to extract the 5-points landmarks needed by Deep3DFaceRecon_pytorch. `lands.py`.
- reorganized the structure of files to make pathing easy inside the script.

## Scripts
- install.sh => install conda environments & setup file structure. `installing the environments can be skipped by entring 2`.
- runall.sh => runs the following scripts: preprocess.sh, training.sh, infrence.sh.
- preprocess.sh => prepare the data for FACIAL training. ~~(The openface step is not implemented yet).~~
- training.sh => train the FACIAL model & audio feature extracter & prepare 3d renders.
- infrence.sh => generate the output video from FACIAL.
- clean.sh => delete all the generated files during preprocessing, training, and infrence.
### **NOTE: Run the scripts with `bash -i <script name>`**

## Prerequisite
- download the [models](https://drive.google.com/drive/folders/1-ln5VrxMqeKW8jttkqqKhzoF37aCYq4g?usp=share_link) and place them inside ./FACIAL_Automated-FAT/models.
- ffmpeg
- anaconda
- docker

## Steps
**Note: Run the scripts with `bash -i <script_name>`**
1. after cloning the repo, download [models](https://drive.google.com/drive/folders/1-ln5VrxMqeKW8jttkqqKhzoF37aCYq4g?usp=share_link) and place them inside `./FACIAL_Automated-FAT/models`.

2. go to `./FACIAL_Automated-FAT/Scripts` and run `bash -i install.sh`.
   - you need to enter 1 (yes) to install the conda environments & docker image. 
   - otherwise if you just want to fetch the FACIAL & Deep3Dface repos enter 2 (no).
   
3. get both training video & infrence audio and rename them into `train1.mp4` & `test1.wav`, and place them into `./FACIAL_Automated-FAT/FACIAL/video_preprocess`.
   - make sure the wav file is mono.
   - make sure the training video is 512x512 & 30fps.
   
4. from `./FACIAL_Automated-FAT/Scripts` run `bash -i runall.sh`, to start preprocessing, taining, and infrence.
   - the docker name should be at least 3 alphabetical characters long.
   
5. ourput video will be saved in `./FACIAL_Automated-FAT/FACIAL/Results/<audio_file_name>_epoch_<epoch_number>_results.mp4`
  
## training only
1. Both  `./FACIAL_Automated-FAT/FACIAL/video_preprocess/train1_deep3Dface/*.mat` & `./FACIAL_Automated-FAT/FACIAL/video_preprocess/train1_openface/train1_512_audio.csv` must be present before running `bash -i training.sh`
2. choose gpu id when prompted, if gpu not selected within 30s the gpu with lowest usage will be selected.

## infrence only
1. enter the audio file name without the extension, or the default name `test1` will be selected after 60s.
2. enter which epoch to use, or default epoch `20` will be selected after 30s.
3. ourput video will be saved in `./FACIAL_Automated-FAT/FACIAL/Results/<audio_file_name>_epoch_<epoch_number>_results.mp4`

## openface using windows
download openface in [windows](https://github.com/TadasBaltrusaitis/OpenFace/wiki/Windows-Installation) and follow these steps:
- open "cmd" from the search bar.
- navigate to `OpenFace_2.2.0_win_x64` by writing
`cd Desktop/OpenFace_2.2.0_win_x64` in the cmd terminal.
- write `FeatureExtraction.exe -fdir <path_to_image_folders>`
- after the program is finished open the `OpenFace_2.2.0_win_x64` in 
window explorer and go to `processed` folder.
- inside `processed` folder you will find a csv file with the same name
as the image folders.
### **NOTE: before placing the .csv file in train1_openface rename it into `train1_512_audio.csv`**

## openface using docker
download openface [docker](https://hub.docker.com/r/algebr/openface/) and follow these steps:  
- to start container run `sudo docker run -itt  -v "path":/home/openface-build/train1_512_audio --rm algebr/openface:latest`, where `path` is the location of the images folder.
- run `export OMP_NUM_THREADS=1 && export VECLIB_MAXIMUM_THREADS=1` to avoid some issues with openBLAS, as [mentioned](https://github.com/TadasBaltrusaitis/OpenFace/wiki/Unix-Installation#OpenBLAS).  
- run `./build/bin/FeatureExtraction -fdir ./train1_512_audio && cp processed/train1_512_audio.csv train1_512_audio` to copy the csv file to the shared folder.  
- run `exit` to exit the container.  
- csv file will be located inside the folder specified in `path`

## Notes
- Please ensure that the video file is named (train1.mp4) & audio file is (test1.wav) and place them inside `FACIAL/video_preprocess`.
- ~~unfortunately I couldn't add the [openface](https://github.com/TadasBaltrusaitis/OpenFace) in the preprocess pipeline.~~ openface is added in the preprocess step through [docker](https://hub.docker.com/r/algebr/openface)
- This script and conda env are tested on ubuntu 20.04LTS.
