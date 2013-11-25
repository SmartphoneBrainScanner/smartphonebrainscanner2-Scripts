function [ vargout ] = psdplot(x,Fs,type,plotOn)
% PSD = psdplot(x,Fs,type,plotOn)

if strcmp('psd',type)
    
    nfft = 2^nextpow2(length(x));
    Pxx = abs(fft(x,nfft)).^2/length(x)/Fs;
    
    % Create a single-sided spectrum
    
    Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',Fs);
    if plotOn
        plot(Hpsd);
    end
    vargout = Hpsd.data;
elseif strcmp('mss',type)
    
    X = fft(x);
    X = X(1:floor((length(X)/2+1)));       %one-sided DFT
    P = (abs(X)/length(x)).^2;      % Compute the mean-square power
    P(2:end-1)=2*P(2:end-1);        % Factor of two for one-sided estimate
    
    % at all frequencies except zero and the Nyquist
    Hmss=dspdata.msspectrum(P,'Fs',Fs,'spectrumtype','onesided');
    if plotOn
        plot(Hmss);                     % Plot the mean-square spectrum.
    end
    vargout = Hmss.data;
else
    disp('Must be psd or mss')
    return
end
end

