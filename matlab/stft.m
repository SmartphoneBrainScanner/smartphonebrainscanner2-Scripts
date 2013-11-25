function stftOut = stft(X,L,noverlap,fs,band,plotOn)

if nargin < 6
    L = 50;
    noverlap = 40;
    fs = 100;
    band = [8 15];
    plotOn = 0;
    disp('Using default values')
end
stepSize = L - noverlap;
lenX = length(X);

X = [zeros(L/2,1); X; zeros(L/2,1)];
WIN = hamming(L);
iter = 0;
NFFT =  2^nextpow2(L);

band = round(band * NFFT/fs);
if numel(band) > 1
    band = band(1):band(2);
end
stft_plot = zeros(round(lenX/stepSize),NFFT/2);
stftOut = zeros(round(lenX/stepSize),1);

for i = 1:stepSize:lenX
	iter = iter + 1;
	Xwin = X(i:(i + L - 1)).* WIN; % bør der egentlig zero paddes her?
	signalout = abs(fft(Xwin, NFFT));
	stft_plot(iter,:) = signalout(1:NFFT/2);
    stftOut(iter) = mean(signalout(band));
end

if plotOn
    figure,
    imagesc(0:(stepSize):(lenX-1),0:1:fs/2,stft_plot');
    xlabel('Time (seconds)');
    ylabel('Frequency (Hz)');
    axis('xy')
    
    figure, spectrogram(X,L,noverlap,NFFT,fs)
end


