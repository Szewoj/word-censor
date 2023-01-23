clear;

load("data/classifierData2")

% Base probability modifier for not blacklisted word
anonA = 5;

% 
% ADS = audioDatastore("samples/cat/");
% word = 13;

ADS = audioDatastore("samples/dog/");
word = 13;


for i = 1:word
    [audioIn,info] = read(ADS);
end

bayes_classifier2;
[val, class] = max(P);

if class == classes
    modifier = -0.2;
else
    modifier = 0.2;
end

detection = zeros(size(audioIn));
detection(R(1):R(2)) = modifier;

clf;
plot(audioIn);
hold on
grid on
plot(detection);

