
i=1;
types = ["samples/cat/","samples/one/","samples/zero/","samples/follow/","samples/forward/","samples/bird/","samples/visual/","samples/up/"];
while i < 9
    ADS = audioDatastore(types(i));
    E=[];
    sigma=[];
    j=1;
    while ADS.hasdata
        [audioIn,info] = read(ADS);
        [coeffs,delta,deltaDelta,loc] = mfcc(audioIn,info.SampleRate);
        E(i,j,:) = [mean(coeffs),mean(delta),mean(deltaDelta)];
        sigma(i,j,:) = [std(coeffs),std(delta),std(deltaDelta)];
        j=j+1;
    end
    j=1;
    i=i+1;
end