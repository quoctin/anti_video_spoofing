%Copyright (c) 2017 Quoc-Tin Phan (quoctin.phan@unitn.it), Duc-Tien Dang-Nguyen and Giulia Boato

function hist = LDP_TOP_2nd_hist_ff_noise(data, width, height, nframe, Rt, from_frame, filter)
%   LDP_TOP_2nd_hist returns histogram of 2nd-order LDP_TOP
%   data: matrix of dimension M x N x F containing F video frames of size M x N
%   width: width of RoI
%   height: height of RoI
%   nframe: number of frames used to apply LDP
%   Rt: temporal distance between frames, can be single resolution, e.g. Rt
%   = 1, can also be multi-resolution, e.g. Rt = [1:2]
%   from_frame: the begining frame
%   filter: kind of filter that is used, can take one value of {'median','gaussian','wiener'}

    xc = floor(height / 2);
    yc = floor(width / 2);

    if nframe == 1
        tc = 1;
    else
        tc = floor(nframe / 2);
    end

    XY = zeros(height, width);

    H2 = [];
    H3 = [];
    H1 = [];

    [~,~,z] = size(data);

    for r = 1:length(Rt)%for all Rt

        XT = zeros(height, nframe);
        TY = zeros(nframe, width);

        frame_ind = 1;
        ind = 1;

        for t = 1:(nframe*Rt(r) + from_frame - 1)
            if ind <= z

                frame = data(:,:,ind);

                if t < from_frame
                    continue;
                end

                if Rt(r) ~= 1 && mod(t-1,  Rt(r)) ~= 0
                    continue;
                end

                frame = im2double(frame);

                roiY = (size(frame,1) / 2 - height/2 + 1):(size(frame,1) / 2 + height/2);
                roiX = (size(frame,2) / 2 - width/2 + 1):(size(frame,2) / 2 + width/2);
                frame = frame(roiY, roiX);

                frame = noise_extraction(frame, filter);

                XT(1:height, ind) = frame(1:height, yc);
                TY(ind, 1:width) = frame(xc, 1:width);

                ind = ind + 1;

                if frame_ind == tc
                    XY = frame;
                    H1 = [H1, LDP_2nd_hist(XY)];
                end

                frame_ind = frame_ind + 1;

            else
                disp('The video is too short');
                hist = [];
                return;
            end
        end

        if nframe > 1
            H2 = [H2, LDP_2nd_hist(XT)];
            H3 = [H3, LDP_2nd_hist(TY)];
        end
    end

    hist = [H1, H2, H3];

end
