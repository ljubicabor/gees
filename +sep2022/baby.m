

m = Model.fromFile("+sep2023/baby.model", growth=true);


m.ss_roc_a = 1.02;
m.k = 2;

m.a = 1;
m = steady(m, "fixLevel", "a");

% table(m, ["steadyLevel", "steadyChange"])


% Neutral comparative static

m1 = m;
m1.a = 1.10;
m1 = steady(m1, "fixLevel", "a");

% table([m, m1], ["steadyLevel", "steadyChange"])

% Proper comparative static

m2 = m;
m2.k = 3;
% m2.a = 1;
m2 = steady(m2, "fixLevel", "a");

table([m, m1, m2], ["steadyLevel", "steadyChange"])


% Alternative neutral comp static

m3 = m;
m3.y = 4;
m3 = steady(m3, "fixLevel", "y");

table([m, m1, m2, m3], ["steadyLevel", "steadyChange"])


