ADS = audioDatastore("samples/cat/")
i=1;
E=[];
sigma=[];
while ADS.hasdata
    [audioIn,info] = read(ADS);
    [coeffs,delta,deltaDelta,loc] = mfcc(audioIn,info.SampleRate);
    E = [E;mean(coeffs)];
    sigma = [sigma;std(coeffs)];
end