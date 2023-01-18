clear;

load("data/classifierData2")

types = ["samples/cat/","samples/one/","samples/zero/","samples/follow/",...
    "samples/forward/","samples/bird/","samples/visual/","samples/up/",...
    "samples/go/","samples/stop/"];

anonA = 5;


ADS = audioDatastore(types(2));
    
[audioIn,info] = read(ADS);

bayes_classifier2;
        
[val, class] = max(P)
