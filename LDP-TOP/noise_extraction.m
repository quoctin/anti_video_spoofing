%Copyright (c) 2017 Quoc-Tin Phan (quoctin.phan@unitn.it), Duc-Tien Dang-Nguyen and Giulia Boato

function N = noise_extraction(I, filter)
%	This function returns the noise residual of I
%   I is a grayscale image
%	filter can take one value of {'gaussian', 'median', 'wiener'}

		if nargin < 2
            filter = 'gaussian';
        end

        if strcmp(filter, 'median')
            denoisedI = medfilt2(I, [7 7]);
        elseif strcmp(filter, 'gaussian')
            H = fspecial('gaussian', [7 7], 2);
            denoisedI = imfilter(I, H, 'replicate');
        elseif strcmp(filter, 'wiener')
            denoisedI = wiener2(I, [7 7]);
		else
			error('This filter is not supported')
        end

        noise = I - denoisedI;

        N = fft2(noise);
        N = fftshift(N);
        N = log(1 + abs(N));
end
