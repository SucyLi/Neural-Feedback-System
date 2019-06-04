close all; clear; clc;

%% step1. load EEG data
% run eeglab.m first
dataFile='motorSubj001_run003.cnt';

EEG = pop_loadcnt(dataFile); % load cnt file
% EEG.setname='CNT file';
% EEG = eeg_checkset(EEG);

% load file
load EEG64locs.mat

% load standard 64 channel loc file
EEG.chanlocs = loc; % miss NAZ, LM, RM

%% step2. plot the raw eeg data
pop_eegplot(EEG, 1, 1, 1); % CHECK EVENT START TIME

%% step3. filtering, e.g., 1HZ~
filteredEEG = pop_eegfilt(EEG, 1, 0, [], [0]); % pop_eegfilt(EEG, 1)

%% step4. segment the eeg data, e.g., start the first onset~
start_time = floor(EEG.event(1).latency/200); % unit: s
start_ind = find(filteredEEG.times == start_time*1000); % unit: ms
filteredEEG.pnts = numel(start_ind:30776);
filteredEEG.times = filteredEEG.times(start_ind:end);
filteredEEG.data = filteredEEG.data(:, start_ind:end);

% change the end to onset of last event + duration

%% step5. run ICA
icaEEG = pop_runica(filteredEEG, 'icatype', 'runica', 'options', {'extended',1});
icaEEG = eeg_checkset(icaEEG);

%% step6. visualize IC on the surface
pop_topoplot(icaEEG, 0, [1:64], 'ERP image', [8,8] ,0, 'electrodes', 'on');

%% step7. remove the ICs of artifacts, manually or automatically

%% manually
% artifact_ind = [2]; % OBSERVE AND WRITE DOWN ARTIFACT COMPONENT INDICES
% cleanEEG = pop_subcomp(icaEEG, artifact_ind, 0);

%% automatically
icaEEG.icaquant = pop_icablinkmetrics(icaEEG);
disp('ICA Metrics are located in: EEG.icaquant.metrics')
disp('Selected ICA component(s) are located in: EEG.icaquant.identifiedcomponents') 
[~,index] = sortrows([icaEEG.icaquant.icaquant.metrics.convolution].');
icaEEG.icaquant.metrics = icaEEG.icaquant.icaquant.metrics(index(end:-1:1)); 
clear index

cleanEEG = pop_subcomp(icaEEG,icaEEG.icaquant.icaquant.identifiedcomponents,0);

%% step8. plt the cleaned eeg data
pop_eegplot(cleanEEG, 1, 1, 1);
