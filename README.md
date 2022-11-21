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
- preprocess.sh => prepare the data for FACIAL training. (The openface step is not implemented yet).
- training.sh => train the FACIAL model & audio feature extracter & prepare 3d renders.
- infrence.sh => generate the output video from FACIAL.
- clean.sh => delete all the generated files during preprocessing, training, and infrence.

## NOTE
- Please ensure that the video file is named (train1.mp4) & audio file is (test1.wav) and place them inside FACIAL/video_preprocess.
- Please ensure that the csv file is neamed (train1_512_audio.csv) and put it in FACIAL/video_preprocess/train1_openface.
- unfortunately I couldn't add the [openface](https://github.com/TadasBaltrusaitis/OpenFace) in the preprocess pipeline. This will be added in the future if I have enough time. (For now try to run it in windows, its much smoother and easier to install).
- This script and conda env are tested on ubuntu 20.04LTS.
