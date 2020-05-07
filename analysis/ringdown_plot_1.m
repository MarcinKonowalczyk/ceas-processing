close all; clear; clc;
%% Ringdown without absorber
M1 = dlmread('ringdown_noA.txt','\t',1,0);

t1 = min(M1(:,1)):max(M1(:,1)); % Time axis
c1 = zeros(1,max(t1)-min(t1));
I0 = M1(1,1);
for j=1:size(M1,1)
    c1(M1(j,1)-I0+1) = M1(j,2);
end
t0 = M1(2,1);
t1 = t1-t0;

irf = hann(10)/trapz(hann(10)); % 10 frames irf 
cc1 = conv(c1,irf,'same'); % Convolved counts

%% Ringdown with absorber
M2 = dlmread('ringdown_A.txt','\t',1,0);

t2 = min(M2(:,1)):max(M2(:,1)); % Time axis
c2 = zeros(1,max(t2)-min(t2));
I0 = M2(1,1);
for j=1:size(M2,1)
    c2(M2(j,1)-I0+1) = M2(j,2);
end
t0 = M2(2,1);
t2 = t2-t0;

irf = hann(10)/trapz(hann(10)); % 10 frames irf 
cc2 = conv(c2,irf,'same'); % Convolved counts

%% Fit
region = c1~=0 & t1 < 1e3;
[y,x] = findpeaks(cc1(region),'Threshold',1e-1);
temp = t1(region); x = temp(x);
P1 = polyfit(x,log(y),1);
P1 = @(t) exp(P1(2)).*exp(t*P1(1));
%
region = c2~=0 & t2 < 1e3;
[y,x] = findpeaks(cc2(region),'Threshold',1e-1);
temp = t2(region); x = temp(x);
P2 = polyfit(x,log(y),1);
P2 = @(t) exp(P2(2)).*exp(t*P2(1));
tt = linspace(0,1000,1e2);

%%
h = [];
figure(1); clf; hold on;
h(1) = plot(t1,cc1,'-');
plot(tt,P1(tt),'k--','LineWidth',1);
h(2) = plot(t2,cc2,'-');
h(3) = plot(tt,P2(tt),'k--','LineWidth',1);
axis square; grid on; box on;
xlim([-10 610]); ylim([0 100]);
xlabel('time / frames'); ylabel('counts');
legend(h,'No absorber','Absorber','Exp. fit');
title('Cavity ringdown');

%%
figure(2); clf; hold on;
plot(t1,cc1,'-');
plot(tt,P1(tt),'k--','LineWidth',1);
plot(t2,cc2,'-');
plot(tt,P2(tt),'k--','LineWidth',1);
axis square; grid on; box on;
a = gca; a.YScale = 'log';
xlim([-10 610]); ylim([1e-2 3e2]);
xlabel('time / frames'); ylabel('counts');
legend(h,'No absorber','Absorber','Exp. fit');