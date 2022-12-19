clear;

i=1;
types = ["samples/cat/","samples/one/","samples/zero/","samples/follow/","samples/forward/","samples/bird/","samples/visual/","samples/up/"];

% Parameters:
nSamples = 500;
nWords = 8;
wordLength = 55;
features = 39;

winLen = 25; % ms
overlap = 12.5; % ms

% Classifier data is in matrix of size k x l x m
% where:
% k - length of classifiable sample
% l - number of mfcc features
% m - number of blacklisted words
meanF=zeros(wordLength,features,nWords);
stdF=zeros(wordLength,features,nWords);

while i <= nWords
    ADS = audioDatastore(types(i));
    j=1;
    F = zeros(wordLength,features,nSamples);
    while j <= nSamples
        [audioIn,info] = read(ADS);
        
        win = hamming(round(info.SampleRate * winLen / 1000), 'periodic');
        ol = round(info.SampleRate * overlap / 1000);
        
        [coeffs,delta,deltaDelta,loc] = mfcc(audioIn, info.SampleRate, ...
            'Window', win, 'OverlapLength', ol, 'LogEnergy', 'Replace');
        cepstr = [coeffs, delta, deltaDelta];
        
        tMax = size(cepstr,1);
        
        lng = min(tMax, wordLength);
        
        F(1:lng,:,j) = cepstr(1:lng,:);
        j=j+1;
    end
    meanF(:,:,i) = mean(F,3);
    stdF(:,:,i) = std(F,[],3);
    i=i+1;
end


save data/classifierData meanF stdF