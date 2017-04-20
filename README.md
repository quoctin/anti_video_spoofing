This source code is the implementation of the paper:

Quoc-Tin Phan, Duc-Tien Dang-Nguyen, Giulia Boato, Francesco G. B. De Natale, "Using LDP-TOP in Video Based Spoofing Detection". (submitted to ICIAP 2017).

 ## Prerequisites
 * LibSVM version 3.20
 * Matlab R2014a or newer


 ## How to use the code?
 ### Feature extraction (/LDP-TOP)

   Define parameters:
   * **ROI_width**: width of region of interest.
   * **ROI_height**: height of region of interest.
   * **nframe**: number of frames used in LDP-TOP calculation.
   * **filter**: type of denoising filter. This variable can take one value of {'median', 'gaussian', 'wiener'}.

   Load video and call either:
   * **LDP_TOP_2nd_hist_ff_noise**: using second-order LDP-TOP.

   or
   * **LDP_TOP_3rd_hist_ff_noise**: using third-order LDP-TOP.

   Examples (take a look at **feature_extraction_example.m** for more details):

   ```Matlab
    ROI_width = 256;
    ROI_height = 256;
    nframe = 100;
    Rt = 1;
    from_frame = 1;
    filter = 'gaussian';
    feature_dim = 3*4*256*length(Rt);

    data = read_video('101_0001.MOV')

    hist2 = LDP_TOP_2nd_hist_ff_noise(data, ROI_width, ROI_height, nframe, Rt, from_frame, filter);
    hist3 = LDP_TOP_2nd_hist_ff_noise(data, ROI_width, ROI_height, nframe, Rt, from_frame, filter);
   ```

   Details of training and testing set on UVAD is located in **/UVAD**.

### Classification (/classification)

  After download [LibSVM 3.20](https://www.csie.ntu.edu.tw/~cjlin/libsvm/),
  * We implement **Histogram Intersection Kernel** which is not originally supported by LibSVM. To use the new kernel, replace {svm.c,svm.h} by /libsvm/{svm.c,svm.h} and build LibSVM following the user guide.
  * Replace mex files in **/libsvm** by your mex files built from LibSVM.

  Suppose your extracted features are stored in *mat* files:
  * **data_train.mat** contains:
    * *data_train*: training features.
    * *labels_train*: training labels.
  * **data_test.mat** contains:
    * *data_test*: testing features.
    * *labels_test*: testing labels.

  Before running classification, you need to normalize your features by calling the Matlab script **/classification/normalize_data.m**. After this step, you should have **data_train.scaled** and **data_test.scaled**.

  Finally you can run classification by calling **/classification/run_classification.m**.

## You have question?

Please feel free to contact **Quoc-Tin Phan** [quoctin.phan@unitn.it](mailto:quoctin.phan@unitn.it).
