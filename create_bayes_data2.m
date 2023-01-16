clear;

i=1;
types = ["samples/cat/","samples/one/","samples/zero/","samples/follow/","samples/forward/","samples/bird/","samples/visual/","samples/up/"];

% Parameters:
nSamples = 300;
nWords = 8;
wordLength = 100;
minLen = 20;
features = 39;

winLen = 25; % ms
overlap = 12.5; % ms

% Classifier data is in matrix of size k x 1 x l x m (mean)
% or k x k x l x m (covariance)
% where:
% k - number of mfcc features
% l - length of classifiable sample
% m - number of blacklisted words
meanF=zeros(wordLength,features,nWords);
stdF=zeros(wordLength,features,nWords);

while i <= nWords
    ADS = audioDatastore(types(i));
    j=1;
    F = cell(wordLength,1);
    while j <= nSamples
        [audioIn,info] = read(ADS);
        
        win = hamming(round(info.SampleRate * winLen / 1000), 'periodic');
        ol = round(info.SampleRate * overlap / 1000);
        
        [coeffs,delta,deltaDelta,loc] = mfcc(audioIn, info.SampleRate, ...
            'Window', win, 'OverlapLength', ol, 'LogEnergy', 'Replace');
        cepstr = [coeffs, delta, deltaDelta]';
        
        % find good data
        first = find(cepstr(1,:) > -4, 1,'first');
        last = find(cepstr(1,:) > -4, 1,'last');
        cepstr = cepstr(:,first:last);
        
        kMax = size(cepstr,2);
        
        if kMax < minLen
            continue
        end
        
        for k = 1:kMax
            F{k} = [F{k}, cepstr(:,k)];
        end
        
        j = j+1;
    end
    
    for k = 1:wordLength
        if size(F{k},1) == 0
            % if there are no samples, copy last results (extended silence)
            meanF(k,:,i) = meanF(k-1,:,i);
            stdF(k,:,i) = stdF(k-1,:,i);
        else
            meanF(k,:,i) = mean(F{k},2);
            stdF(k,:,i) = std(F{k},[],2);
        end
    end
    
    i=i+1;
    
end

% save data/classifierData2 meanF stdF