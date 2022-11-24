# FACIAL_Automated-FAT
## GOAL
A colliction of scripts that automate the process of setting up, training, and infrence of [FACIAL](https://github.com/zhangchenxu528/FACIAL).

## Features
- installation and setup of all necessary environments and dependencies [(deep3Dface)](https://github.com/sicxu/Deep3DFaceRecon_pytorch).
- one script to rule them all, just run the runall.sh file to preprocess, train, and infer.
- automatically chooses the least utilized GPU if the user is not present.
- multiable safe guards to ensure everything runs smoothly.
- made FACIAL compatable with the output of Deep3DFaceRecon_pytorch.
- changed some deprecated functions in FACIAL.
- provided a python script to extract the 5-points landmarks needed by Deep3DFaceRecon_pytorch. (lands.py).
- reorganized the structure of files to make pathing easy inside the script.

## Scripts
- install.sh => install conda environments & setup file structure. (installing the environments can be skipped).
- runall.sh => runs the following scripts: preprocess.sh, training.sh, infrence.sh.
- preprocess.sh => prepare the data for FACIAL training. ~~(The openface step is not implemented yet).~~
- training.sh => train the FACIAL model & audio feature extracter & prepare 3d renders.
- infrence.sh => generate the output video from FACIAL.
- clean.sh => delete all the generated files during preprocessing, training, and infrence.
### **NOTE: Run the scripts with "bash -i <script name>"**

## prerequisite
- download the [models](https://drive.google.com/drive/folders/1-ln5VrxMqeKW8jttkqqKhzoF37aCYq4g?usp=share_link) and place them inside ./FACIAL_Automated-FAT/models.
- ffmpeg
- anaconda
- docker

## if openface fails during preprocess
comment out from line 11 to line 37 inside preprocess.sh, then download openface in [windows](https://github.com/TadasBaltrusaitis/OpenFace/wiki/Windows-Installation) and follow these steps:
- open "cmd" from the search bar.
- navigate to "OpenFace_2.2.0_win_x64" by writing
"cd Desktop/OpenFace_2.2.0_win_x64" in the cmd terminal.
- write "FeatureExtraction.exe -fdir <path_to_image_folders>"
- after the program is finished open the "OpenFace_2.2.0_win_x64" in 
window explorer and go to "processed" folder.
- inside "processed" folder you will find a csv file with the same name
as the image folders.
### **NOTE: before placing the .csv file in train1_openface rename it into "train1_512_audio.csv"**

## NOTES
- Please ensure that the video file is named (train1.mp4) & audio file is (test1.wav) and place them inside FACIAL/video_preprocess.
- ~~unfortunately I couldn't add the [openface](https://github.com/TadasBaltrusaitis/OpenFace) in the preprocess pipeline.~~ openface is added in the preprocess step through [docker](https://hub.docker.com/r/algebr/openface)
- This script and conda env are tested on ubuntu 20.04LTS.
