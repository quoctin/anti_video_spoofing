%Copyright (c) 2017 Quoc-Tin Phan (quoctin.phan@unitn.it), Duc-Tien Dang-Nguyen and Giulia Boato

clear all
clc

data_name = 'data_train';
load([data_name 'data_train.mat'])
sparse_features = sparse(data_train);
libsvmwrite([data_name '.svm'], labels_train, sparse_features);
system(['./../libsvm/svm-scale -s scaling_parameters ', data_name, '.svm', ' > ', data_name, '.scaled']);
system(['rm ', data_name, '.svm']);

data_name = 'data_test';
load([data_name '.mat'])
sparse_features = sparse(data_test);
libsvmwrite([data_name '.svm'], labels_test, sparse_features);
system(['./../libsvm/svm-scale -r scaling_parameters ', data_name, '.svm', ' > ', data_name, '.scaled']);
system(['rm ' data_name '.svm']);
