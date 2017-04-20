%Copyright (c) 2017 Quoc-Tin Phan (quoctin.phan@unitn.it), Duc-Tien Dang-Nguyen and Giulia Boato

clear all
clc

addpath('../libsvm');

[labels_train, data_train] = libsvmread(['data_train.scaled']);
[labels_test, data_test] = libsvmread(['data_test.scaled']);

kernel = 5;
run_with_threshold_estimation(data_train, labels_train, data_test, labels_test, kernel);
