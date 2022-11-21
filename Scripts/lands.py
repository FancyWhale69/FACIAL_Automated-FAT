from mtcnn import MTCNN
import cv2
import os
from tqdm import tqdm
import argparse
parser = argparse.ArgumentParser(description='Image resize')
parser.add_argument('-i', default='./', type=str, help='Directory for inputs')
parser.add_argument('-o', default='./', type=str, help='Directory for results')
args = parser.parse_args()
os.environ["CUDA_VISIBLE_DEVICES"] = "1" 

detector = MTCNN()

for name in tqdm(os.listdir(args.i)):
    try:
        img = cv2.cvtColor(cv2.imread(f"{args.i}/{name}"), cv2.COLOR_BGR2RGB)
        points= detector.detect_faces(img)[0]['keypoints']
    except Exception as e:
        print(e)
        print(name)

    with open(f'{args.o}/{name.split(".")[0]}.txt', 'w') as f:
        for p in points.keys():
            i = points[p]
            f.writelines(f'{i[0]} {i[1]}\n')
