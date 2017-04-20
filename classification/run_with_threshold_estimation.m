%   Copyright (c) 2017 Quoc-Tin Phan (quoctin.phan@unitn.it), Duc-Tien Dang-Nguyen and Giulia Boato
%   These code called functions from LibSVM, Copyright (c) 2000-2014 Chih-Chung Chang and Chih-Jen Lin

function run_with_threshold_estimation(data_train, labels_train, data_test, labels_test, kernel, c, g)
%   function run_with_threshold_estimation calculate the prediction performance
%   in terms of FRR, FAR, HTER, Accuracy, AUC and EER.
%   data_train is the filename of the file containing [labels, 1xd
%   histograms] of the training set.
%   data_test is the filename of the file containing [labels, 1xd
%   histograms] of the testing set.
%   label = -1 for attacks, 1 for real access.
%   kernel: SVM kernel (5 is Histogram Intersection Kernel).

	pos_inds = find((labels_train == 1));
	neg_inds = find((labels_train == -1));
	data_devel = data_train([pos_inds(1:30); neg_inds(1:270)], :);
	labels_devel = labels_train([pos_inds(1:30); neg_inds(1:270)]);
	
	data_train([pos_inds(1:30); neg_inds(1:270)], :) = [];
	labels_train([pos_inds(1:30); neg_inds(1:270)]) = [];

    % find best c and g
    if kernel == 2
        if nargin < 6
            bestcv = 0;
            for log2c = -4:2:4
                for log2g = -4:2:4
                    cmd = ['-t ', num2str(kernel), ' -q -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
                    cv = get_cv_ac(labels_train, data_train, cmd, 3);
                    if (cv >= bestcv)
                        bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
                    end
                    fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
                end
            end
        else
            bestc = g;
            bestg = c;
        end
        model = svmtrain(labels_train, data_train, ['-t ', num2str(kernel), ' -c ' num2str(bestc) ' -g ' num2str(bestg) ' -b 1 -q']);
    else
        model = svmtrain(labels_train, data_train, ['-t ', num2str(kernel), ' -b 1 -q']);
    end
    %estimating the threshold
    [predicted_label, accuracy, decision_values] = svmpredict(labels_devel, data_devel, model, ' -q -b 1');

    [FPR, TPR, Thr, AUC, OPTROCPT] = perfcurve(labels_devel, decision_values(:,1), 1);

    FRR = 1 - TPR;
    FAR = FPR;

    [minD, ind] = min(abs(FAR - FRR));

    desired_threshold = Thr(ind);

    %classifying the test set
    [~, ~, decision_values] = svmpredict(labels_test, data_test, model, '-q -b 1');

    %calibrate the result with the desired threshold
    predicted_label = (decision_values(:,1) >= desired_threshold);
    predicted_label = -1*(predicted_label == 0) + predicted_label;

    % output scores
    scores = decision_values;

    %calculating FRR: 1 ==> -1
    FRR = sum((labels_test - predicted_label) == 2)*100 / sum(labels_test == 1);
    fprintf('\nFRR = %.2f', FRR);


    %calculating FAR: -1 ==> 1
    FAR = sum((-labels_test + predicted_label) == 2)*100 / sum(labels_test == -1);
    fprintf('\nFAR = %.2f', FAR);

    %calculating HTER
    HTER = (FAR + FRR) / 2;
    fprintf('\nHTER = %.2f', HTER);

    %calculating accuracy
    acc = 100 - (sum(predicted_label ~= labels_test))*100 / length(predicted_label);
    fprintf('\nAcc = %.2f', acc);

    %calculating EER
    [FPR, TPR, ~, AUC, ~] = perfcurve(labels_test, decision_values(:,1), 1);

    FRR = 1 - TPR;
    FAR = FPR;

    [~, ind] = min(abs(FAR - FRR));
    EER = FAR(ind);

    fprintf('\nEER = %.4f', EER);

    fprintf('\nAUC = %.4f\n', AUC);

end
