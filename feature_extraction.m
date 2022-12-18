
i=1;
types = ["samples/cat/","samples/one/","samples/zero/","samples/follow/","samples/forward/","samples/bird/","samples/visual/","samples/up/"];
while i < 9
    ADS = audioDatastore(types(i));
    E=[];
    sigma=[];
    data = [];
    j=1;
    while j <= 500
        [audioIn,info] = read(ADS);
        [coeffs,delta,deltaDelta,loc] = mfcc(audioIn,info.SampleRate);
        if size(coeffs,1)>65
            data(j,:,:) = [coeffs(1:65,:),delta(1:65,:),deltaDelta(1:65,:)];
            j=j+1;
        end
    end
    j=1;
    E(i,:,:) = mean(data);
    sigma(i,:,:) = std(data);
    i=i+1;
end