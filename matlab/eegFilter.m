function [ S ] = eegFilter( X, method, fs )
% Spectral bandpass, stft
if nargin < 2, method = 'bandpower'; end
if nargin < 3, fs = 200; end

[D, N, M] = size(X);
L = 100;
noverlap = 90;
band = [7 15];
plotOn = 0;
stepSize = L-noverlap;
% S = zeros(D,N,M);
for m = 1:M
    switch method
        case 'stft'
            for d=1:D, S(d,:,m) = stft(X(d,:,m),L,noverlap,fs,band,plotOn); end
        case 'bandpower'
            tmp = [X(:,1:min(N,200),m) X(:,:,m)]; %This caused major issues. Doubling the signal seems to work
            tmpS = bandpower( tmp', fs, band, 0.1, 4)';
            S(:,:,m) = tmpS(:, min(N,200)+1:end);
        case 'hp'
            h=fdesign.highpass('N,Fst,Fp',min(floor(N/3),512),0.2,0.5,fs);
            d=design(h,'equiripple'); %Lowpass FIR filter
            S=filtfilt(d.Numerator,1,double(X'))'; %zero-phase filtering
        case 'lp'
            h=fdesign.lowpass('N,Fc',min(floor(N/3),512),48,fs);
            d=design(h);
            S=filtfilt(d.Numerator,1,double(X'))';
    end
end

end

