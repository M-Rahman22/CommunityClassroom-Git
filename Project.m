% Clear all previously collected data and plots
clear m; clearvars -except teamID; close all;

% Add the helper files to your so that you can them in this file
addpath(fullfile(pwd, 'helperFiles'));
% addpath(fullfile('Mohammad.m'));

% excel, txt, csv
% read that in, analyze it


% now your program sees and can access all helperFiles
% - checkProductLice4nses.m
% CollectData.m
% ....

checkProductLicenses();


% Create a mobile device object
m = mobiledev;

% Set the sampling rate and duration of data collection
samplerate = 100; % Hz
duration = 30; % Seconds

% Collect data from the accelerometer of the mobile device
m = CollectData(duration, samplerate);


% Extract the acceleration data and the corresponding timestamps from the collected data
[a, t] = accellog(m);

% Extract the acceleration signals from the acceleration matrix
x = a(:, 1);
y = a(:, 2);
z = a(:, 3);

% Compute the magnitude of the acceleration vector
mag = sqrt(sum(x.^2 + y.^2 + z.^2,2));

magNoG = mag - mean(mag)


%Count the number of steps taken
% by finding peaks in the acceleration
% magnitude data.

minPeakHeight = max(1,std(magNoG));

warning Off %Suppress warning thrown if
            % no peaks detected
[pks, locs] = findpeaks(magNoG, ...
                       'MINPEAKHEIGHT',...
                       minPeakHeight);

numSteps = numel(pks)

%The peak locations can be visualized
% with the acceleration magnitude data

figure; hold on
plot(t, magNoG);
plot(t(locs), pks, 'r', ...
    'Marker', 'v', 'Linestyle', 'none');
title('Counting steps');
xlabel('Time (s)');
ylabel('|Acceleration|, No Gravity');
legend({'|Acceleration|, No Gravity', 'Steps'})
hold off;

warning on 

m.AccelerationSensorEnabled = 0;

clear m;