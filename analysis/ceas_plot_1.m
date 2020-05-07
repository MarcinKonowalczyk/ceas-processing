close all; clear; clc;

%% Make IRF
N = 15;
irf = hann(N);
irf = irf./trapz(irf);

%% CEAS without absorber
M1 = dlmread('ceas_noA.txt','\t',1,0);

t1 = min(M1(:,1)):max(M1(:,1)); % Time axis
c1 = zeros(1,max(t1)-min(t1));
I0 = M1(1,1);
for j=1:size(M1,1)
    c1(M1(j,1)-I0+1) = M1(j,2);
end
t0 = M1(2,1);
t1 = t1-t0;

cc1 = conv(c1,irf,'same'); % Convolved counts

%% CEAS with absorber
M2 = dlmread('ceas_A.txt','\t',1,0);

t2 = min(M2(:,1)):max(M2(:,1)); % Time axis
c2 = zeros(1,max(t2)-min(t2));
I0 = M2(1,1);
for j=1:size(M2,1)
    c2(M2(j,1)-I0+1) = M2(j,2);
end
t0 = M2(2,1);
t2 = t2-t0;

cc2 = conv(c2,irf,'same'); % Convolved counts

%% Fit
m = @(t,p) p(2)*(1-exp(-t/p(1)));

f = @(p) mean((cc1-m(t1,p)).^2);
pf1 = fminsearch(f,[10,100]);
f = @(p) mean((cc2-m(t2,p)).^2);
pf2 = fminsearch(f,[10,100]);

%% Plot
h = [];
figure(1); clf; hold on;
h(1) = plot(t1,cc1,'-');
plot(t1,m(t1,pf1),'k--','LineWidth',1);
h(2) = plot(t2,cc2,'-');
h(3) = plot(t2,m(t2,pf2),'k--','LineWidth',1);
axis square; grid on; box on;
xlim([-10 2e3]); ylim([0 20]);
xlabel('time / frames'); ylabel('counts');
%legend(h,...
%    'No absorber','Absorber','Exp. fit',...
%    'Location','SouthEast');
%title('Intensity accumulation in the cavity');