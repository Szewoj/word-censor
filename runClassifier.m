clear;

load("data/classifierData2")

types = ["samples/cat/","samples/one/","samples/zero/","samples/follow/","samples/forward/","samples/bird/","samples/visual/","samples/up/"];

thLearningSet = 500;

thTestSet = 1000;

classTh = 0.1;

% Learning set hits and misses
lsHitMiss = zeros(length(types)+1,2);

% Test set hits and misses
tsHitMiss = zeros(length(types)+1,2);

for c = 1:length(types)
    ADS = audioDatastore(types(c));
    
    for i = 1:thTestSet
        [audioIn,info] = read(ADS);
    
        bayes_classifier2;
        
        [val, class] = max(P);
        
        if class == c, hit = 1; else, hit = 2; end
        
        if val > classTh
            if i > thLearningSet
                tsHitMiss(c,hit) = tsHitMiss(c,hit)+1;
            else
                lsHitMiss(c,hit) = lsHitMiss(c,hit)+1;
            end
        else
            if i > thLearningSet
                tsHitMiss(c,2) = tsHitMiss(c,2)+1;
            else
                lsHitMiss(c,2) = lsHitMiss(c,2)+1;
            end
        end
    end
end

clf;
subplot(2,1,1);
bar(lsHitMiss);

subplot(2,1,2);
bar(tsHitMiss)