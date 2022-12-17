% LOAD REFERENCE DATA
load data\classifier1.mat

[features, T, classes] = size(EF);

% PERFORM MFCC ON INCOMING DATA

% placeholder
featureMatrix = ones(39, 50) * -1;


% CLASSIFY

P = ones(classes,1)/classes; 
% start with equal distribution - every word is equally probable

P_rel = zeros(classes,1);

for t = 1:T
    P_rel_full = normpdf(featureMatrix(:,t), ...
                    EF(:,t,:), sF(:,t,:));
    P_rel(:,1) = prod(P_rel_full, 1);
    P = P .* P_rel;
    P = P / norm(P,1);
end

