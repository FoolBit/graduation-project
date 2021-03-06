clc;clear;close all;

%% load data
% h:hidden status，细胞的状态
% syn_efficacy: 突触效能
load('WMnew.mat');

%% params
n_tpt = size(h, 1); % time points
n_trial = size(h, 2); % number of trials

%% init var
acc_neuron_cue = nan(n_tpt, 2, 2);
acc_syn_cue = nan(n_tpt, 2, 2);

%% trial select
idx = true(1,n_trial); 

% cue_idx是两行，第一行记录哪些trial是cue1，第二行记录哪些trail是cue2
cue1_idx = (cue == 0) & idx; 
cue2_idx = (cue == 1) & idx;
cue_idx = [cue1_idx;cue2_idx];

clear idx cue1_idx cue2_idx
%% train
for t = 1:n_tpt % 每个时间点计算一次
    for c = 1:2 % 分别训练cue1和cue2的trial
        idx = cue_idx(c,:);
        fprintf('Processing timepoint: %i\n',t);
        trainingData = [squeeze(h(t,idx,:)), double(stim1(idx)')]; % 训练数据的格式：[细胞状态， 呈现的刺激]， 下同
        [~, acc_neuron_cue(t, 1, c)] = trainLinearSVM(trainingData);
        
        trainingData = [squeeze(h(t,idx,:)), double(stim2(idx)')];
        [~, acc_neuron_cue(t, 2, c)] = trainLinearSVM(trainingData);
        
        trainingData = [squeeze(syn_efficacy(t,idx,:)), double(stim1(idx)')];
        [~, acc_syn_cue(t, 1, c)] = trainLinearSVM(trainingData);
        
        trainingData = [squeeze(syn_efficacy(t,idx,:)), double(stim2(idx)')];
        [~, acc_syn_cue(t, 2, c)] = trainLinearSVM(trainingData);
    end
end

%% save data
save('accData_wmnew_cue.mat','acc_neuron_cue','acc_syn_cue');