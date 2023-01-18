clear;

load("data/classifierData2")

types = ["samples/cat/","samples/one/","samples/zero/","samples/follow/",...
    "samples/forward/","samples/bird/","samples/visual/","samples/up/",...
    ...
    "samples/backward/","samples/bed/","samples/dog/","samples/down/",...
    "samples/eight/","samples/five/","samples/four/","samples/go/",...
    "samples/happy/","samples/house/","samples/learn/","samples/left/",...
    "samples/nine/","samples/off/","samples/stop/","samples/wow/"];


nWords = 8;

thLearningSet = 300;

thTestSet = 600;

% Base probability modifier for not blacklisted word
anonA = 5;

% Learning set hits and misses
lsHitMiss = zeros(nWords+1,2);

% Test set hits and misses
tsHitMiss = zeros(nWords+1,2);

for c = 1:length(types)
    ADS = audioDatastore(types(c));
    
    for i = 1:thTestSet
        [audioIn,info] = read(ADS);
    
        bayes_classifier2;
        
        [val, class] = max(P);
        
        if c <= nWords
            x = c;
            if class == c
                hit = 1;
            else
                hit = 2;
            end
        else
            x = 9;
            if class == 9
                hit = 1;
            else
                hit = 2;
            end
        end
        
        if i > thLearningSet
            tsHitMiss(x,hit) = tsHitMiss(x,hit)+1;
        else
            lsHitMiss(x,hit) = lsHitMiss(x,hit)+1;
        end
        
    end
end

tsHitMiss = tsHitMiss ./ sum(tsHitMiss,2);
lsHitMiss = lsHitMiss ./ sum(lsHitMiss,2);

clf;
subplot(2,1,1);
bar(lsHitMiss);
grid on;

subplot(2,1,2);
bar(tsHitMiss)
grid on;