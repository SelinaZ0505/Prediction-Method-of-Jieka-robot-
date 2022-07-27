import numpy as np
import scipy.io as io
import os
def npy_mat(npy_path,mat_path):
    npyname_path = os.listdir(npy_path)
    for npyname in npyname_path:
        npyname = os.path.join(npy_path,npyname)
        name = npyname[:-4]
        name = name[39:]
        mat_name = name+'.mat'
        mat_name = os.path.join(mat_path,mat_name)
        npy = np.load(npyname)
        io.savemat(mat_name,{'data':npy})
npy_mat(r'C:\Users\86182\Desktop\电流分析\数据\转矩周期原始数据.npy',r'E:\renqunjishu\mat\test_matC:\Users\86182\Desktop\电流分析\数据\转矩周期原始数据')