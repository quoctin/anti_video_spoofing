%Copyright (c) 2017 Quoc-Tin Phan (quoctin.phan@unitn.it), Duc-Tien Dang-Nguyen and Giulia Boato

function data = read_video(path)
%   This function reads video and return a 3D matrix
%   path: video file path
    V = VideoReader(path);
    maxNumFrame = 400; % suppose that 400 is enough for buffering
    data = zeros(V.height, V.width, maxNumFrame);
    fInd = 1;
    while hasFrame(V)
        frame = readFrame(V);
        frame(:,:,2:3) = [];
        data(:,:,fInd) = frame;
        fInd = fInd + 1;
    end
    data(:,:,fInd:maxNumFrame) = [];
end
