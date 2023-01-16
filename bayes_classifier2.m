% REQUIRES:
% meanF - matrix of mean mfcc feature parameters
% covF - covariance matrix of mfcc feature parameters
% audioIn - sample of audio to analyze
% info - audio input information

% GET SIZE

[T, features, classes] = size(meanF);

% PERFORM MFCC ON INCOMING DATA

winLen = 25; % ms
overlap = 12.5; % ms

win = hamming(round(info.SampleRate * winLen / 1000), 'periodic');
ol = round(info.SampleRate * overlap / 1000);
        
[coeffs,delta,deltaDelta,loc] = mfcc(audioIn, info.SampleRate, ...
        'Window', win, 'OverlapLength', ol, 'LogEnergy', 'Replace');
featureMatrix = [coeffs, delta, deltaDelta];

% crop to word start

first = find(featureMatrix(:,1) > -4, 1,'first');
last = find(featureMatrix(:,1) > -4, 1,'last');
featureMatrix = featureMatrix(first:last,:);

% CLASSIFY

P = ones(1,classes)/classes; 
% start with equal distribution - every word is equally probable

% Classification horizon
h = min(T, size(featureMatrix,1));

P_rel = zeros(1,classes);

for t = 1:h % Frame number
    P_rel_full = normpdf(featureMatrix(t,:), ...
                    meanF(t,:,:), stdF(t,:,:));
    P_rel(1,:) = prod(P_rel_full, 2);
    P = P .* P_rel;
    
    P = P / norm(P,1);
end

% OUTPUT:
% P - probability of each word in list
