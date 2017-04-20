%Copyright (c) 2017 Quoc-Tin Phan (quoctin.phan@unitn.it), Duc-Tien Dang-Nguyen and Giulia Boato

clear all
clc

%::::::::::::CONFIGURATION::::::::::::%
ROI_width = 256;
ROI_height = 256;
nframe = 100;
Rt = 1;
from_frame = 1;
filter = 'gaussian';
feature_dim = 3*4*256*length(Rt);
%::::::::::END CONFIGURATION::::::::::%


%:::::::::::::::::::::::::::::TRAIN-POSITIVE::::::::::::::::::::::::::::::%
files = dir('../UVAD/train/positive/*.txt');
file_list = [];
for i = 1:length(files)
    list = read_file_list([files(i).folder filesep files(i).name]);
    file_list = [file_list; list];
end

pos_labels = ones(size(file_list,1));
pos_features = zeros(size(file_list, 1), feature_dim);
for f = file_list'
    data = read_video(f);
    hist = LDP_TOP_2nd_hist_ff_noise(data, ROI_width, ROI_height, nframe, Rt, from_frame, filter);
end


%:::::::::::::::::::::::::::::TRAIN-NEGATIVE::::::::::::::::::::::::::::::%
files = dir('../UVAD/train/negative/*.txt');
file_list = [];
for i = 1:length(files)
    list = read_file_list([files(i).folder filesep files(i).name]);
    file_list = [file_list; list];
end

neg_label = ones(size(file_list,1));
neg_features = zeros(size(file_list, 1), feature_dim);
for f = file_list'
    data = read_video(f);
    hist = LDP_TOP_2nd_hist_ff_noise(data, ROI_width, ROI_height, nframe, Rt, from_frame, filter);
end

%:::::::::::::::::::::::::::::::TRAIN-DATA::::::::::::::::::::::::::::::::%
features = [pos_features; neg_features];
labels = [pos_labels; neg_labels];
