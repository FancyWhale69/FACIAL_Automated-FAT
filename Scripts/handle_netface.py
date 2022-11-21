import os, sys
import numpy as np
from scipy.io import loadmat,savemat
import glob
from scipy.signal import savgol_filter
import argparse
from tqdm import tqdm
parser = argparse.ArgumentParser(description='netface_setting')
parser.add_argument('--param_folder', type=str, default='../video_preprocess/train1_deep3Dface')

opt = parser.parse_args()

param_folder = opt.param_folder

mat_path_list = sorted(glob.glob(os.path.join(param_folder, '*.mat')))
len_mat = len(mat_path_list)
faceshape = np.zeros((len_mat, 257),float)

for i,name in tqdm(zip(range(1,len_mat+1), mat_path_list)):
    mat_contents= loadmat(os.path.join(param_folder,name.split('/')[-1]))
    coeff= np.concatenate((mat_contents['id'][0],
                        mat_contents['exp'][0],
                        mat_contents['tex'][0],
                        mat_contents['angle'][0],
                        mat_contents['gamma'][0],
                        mat_contents['trans'][0]))
    faceshape[i-1,:] = coeff


frames_out_path = os.path.join(param_folder,'train1.npz')
np.savez(frames_out_path, face = faceshape)