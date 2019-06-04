function [icablinkmetricsout, matrixofVEOGiBlinks, matrixofICAiBlinks, matrixofEEGiBlinks, matrixofICAConvolution, matrixofEEGiBlinksafterICAremoval, matrixofEEGConvolutionafterICAremoval, meanofVEOGiBlinks, meanofEEGiBlinks] = icablinkmetrics(INEEG, varargin)
%   Computes metrics to determine which ICA component relates to the artifact. Returns a structure containing: 
%
%       1   metrics:
%           a   the correlation between the measured artifact in the artifact channel and each ICA component.
%           b   the adjusted normalized convolution of the ICA component activity with the measured artifact in the artifact channel.
%           c   the percent reduction in the artifact present in the EEG for each ICA component if it was removed.
%       2   identifiedcomponents: the ICA components which exhibits statistically significant values for all three metrics.
%       3   artifactlatencies: the latencies which were used in the computation of the metrics.
%
%   A list of point latencies which correspond to the occurrence of the artifact can be inputted or if no 
%   data is provided a template matching procedure eyeblinklatencies() will be run on the artifact channel. 
%   This list is used to create averages surrounding the time point for the artifact, the data, and the ICA 
%   component. The window period controls the area of interest surrounding the artifact latencies.
%   If the EOG channels are not available for some reason, it is also possible to input another channel 
%   (ex. FP1) which exhibits the EOG artifact.
%
%   1   Input continuous EEG dataset From EEGLAB 
%   2   The available parameters are as follows:
%       a    'ArtifactChannel' - Vector of data which exhibits the artifact. Typically data from the VEOG electrode.
%       b    'ArtifactLatencies' - Vector of markers corresponding to the point latency of the artifact.
%       c    'Window' - Window period in milliseconds surrounding the artifact. Default is [-150 150].
%       d    'MinimumArtifacts' - Minimum number of artifacts necessary to compute metrics. Default is 4.
%       e    'Alpha' - Minimum Significance level - applied globally. Default is p <= 0.001
%       f    'Tails' - [ 1 | 2 (default) ] Number of tails for p value.
%       g    'MetricThresholds' - Matrix of alpha thresholds for each  metric [Correlation, Convolution, PercentReduction]. Default uses global alpha.
%       h    'TemplateThreshold' - Critical correlation threshold with template to identify as an eyeblink. Passthrough for eyeblinklatencies, default 0.96.
%       I     'VisualizeData' - [ 'True' | 'False' [default] Option to plot data visualizations.
%       j     'MinimumCorrelation' - Minimum correlation between artifact and component. Default is 0.8 (very strong correlation).
%
%   Example Code:
%
%   EEG.icaquant = icablinkmetrics(EEG, 'ArtifactChannel', EEG.data(find(strcmp({EEG.chanlocs.labels},'VEOG')),:), 'Alpha', 0.001, 'VisualizeData', 'True');
%
%
%   NOTE: You must have the Matlab Statistics Toolbox installed.
%
%   Author: Matthew B. Pontifex, Health Behaviors and Cognition Laboratory, Michigan State University, January 12, 2015
%   revised 3-29-15 to use p values instead of thresholds
%   revised 11-1-15 to improve computational speed
%   revised 2-24-16 to also require very strong correlation between artifact and the component (r > 0.8)

    if ~isempty(varargin)
             r=struct(varargin{:});
    end
    try, r.Alpha; catch, r.Alpha = 0.001; end
    try, r.Tails; catch, r.Tails = 2; end
    try, r.Window; catch, r.Window = [-150 150]; end
    try, r.MinimumArtifacts; catch, r.MinimumArtifacts = 4; end
    try, r.MetricThresholds; catch, r.MetricThresholds = [r.Alpha, r.Alpha, r.Alpha]; end
    try, r.VisualizeData; catch, r.VisualizeData = 'False'; end
    try, r.TemplateThreshold; catch, r.TemplateThreshold = 0.96; end
    try, r.MinimumCorrelation; catch, r.MinimumCorrelation = 0.8; end
    
    
    if isequal(r.MetricThresholds, [0.6,0.4,25])
        warning('icablinkmetrics(). The thresholds specified seem to be from the icablinkmetrics version 1. The updated version now uses statistical thresholds. The default setting is p <= 0.001')
    end
    if (size(INEEG.data,3) > 1)
        error('Error at icablinkmetrics(). This function is designed for continous EEG, but an epoched EEG dataset has been inputted.');
    end
    if isempty(INEEG.icaweights)
        error('Error at icablinkmetrics(). ICA weights must first be computed.');
    end
    try
        r.ArtifactChannel; 
    catch
        try
            % Test blink detectors
            blinkcounts = NaN(1,INEEG.nbchan);
            for cC = 1:INEEG.nbchan
                [T, ArtifactLatencies] = evalc('eyeblinklatencies(''BlinkActivity'', INEEG.data(cC,:), ''SampleRate'', INEEG.srate, ''Threshold'', 0.96)');
                blinkcounts(cC) = numel(ArtifactLatencies);
            end
            keychannel = find(blinkcounts == max(blinkcounts));
            if ~isempty(keychannel)
                r.ArtifactChannel = INEEG.data(keychannel,:);
            else
                error('Error at icablinkmetrics(). Missing information! Please input Artifact channel information.'); 
            end
        catch
            error('Error at icablinkmetrics(). Missing information! Please input Artifact channel information.'); 
        end
    end
    
    if isempty(INEEG.icaact)
        INEEG.icaact = (INEEG.icaweights*INEEG.icasphere)*reshape(INEEG.data, INEEG.nbchan, INEEG.trials*INEEG.pnts);
        INEEG.icaact = reshape( INEEG.icaact, size(INEEG.icaact,1), INEEG.pnts, INEEG.trials);
    end
    try
        r.ArtifactLatencies; 
    catch % no latency markers were inputted
        fprintf('\n')
        fprintf('icablinkmetrics(). Artifact latency information not provided. Running eyeblinklatencies() on inputted artifact channel.')
        r.ArtifactLatencies = eyeblinklatencies('BlinkActivity', r.ArtifactChannel, 'SampleRate', INEEG.srate, 'Threshold', r(1).TemplateThreshold);
        if (numel(r.ArtifactLatencies) < r.MinimumArtifacts)
            fprintf('Warning at icablinkmetrics(). A small number of eye blinks were found in the data. Adjusting parameters for searching and trying again.\n')
            r.ArtifactLatencies = eyeblinklatencies('BlinkActivity', r.ArtifactChannel, 'SampleRate', INEEG.srate, 'Threshold', 0.9);
        end
    end
    if (numel(r.ArtifactLatencies) < r.MinimumArtifacts)
        error('Error at icablinkmetrics(). Too few blink events are available for reliable metrics. Try including more markers.');
    end
    ArtifactLatencies = r.ArtifactLatencies;
   
    %% Step 1: Make sure inputted blink latencies do not overlap ends of data with the window period and that the blinks are consistent
    % Set window period in points instead of ms
    r.Window(1) = floor(r.Window(1)*(INEEG.srate/1000));
    r.Window(2) = floor(r.Window(2)*(INEEG.srate/1000));
    
    % Screen blink latencies relative to window period
    for blinkindex = 1:size(ArtifactLatencies,2)
        if ((ArtifactLatencies(blinkindex) + r.Window(1)) < 0) || ((ArtifactLatencies(blinkindex) + r.Window(2)) > INEEG.pnts)
            ArtifactLatencies(blinkindex) = 0;
        end
    end
    ArtifactLatencies = ArtifactLatencies(ArtifactLatencies~=0); % Remove blinks which would overlap with zero and the end of the data
    if (numel(ArtifactLatencies) < r.MinimumArtifacts)
        error('Error at icablinkmetrics(). Too few blink events are available for reliable metrics. Try including more markers or shortening the window period.');
    end
    
    %% Step 2: Prepare Data Matrices
    % Create Average Eyeblink from Artifact Channel (i.e., VEOG)
    r.ArtifactChannel = fastsmooth(r.ArtifactChannel, floor(INEEG.srate/50), 2, 1); % Smooth the VEOG channel to remove high frequency activity
    matrixofVEOGiBlinks = zeros(size(ArtifactLatencies,2),(r.Window(2)-r.Window(1))+1);
    for blinkindex = 1:size(ArtifactLatencies,2)
        matrixofVEOGiBlinks(blinkindex,:) = r.ArtifactChannel(1,(r.Window(1)+ArtifactLatencies(blinkindex)):(r.Window(2)+ArtifactLatencies(blinkindex))); % extract data from the artifact channel for the window period
        matrixofVEOGiBlinks(blinkindex,:) = matrixofVEOGiBlinks(blinkindex,:) - matrixofVEOGiBlinks(blinkindex,1); %baseline correct
    end
    if (size(ArtifactLatencies,2) == 1)
        meanofVEOGiBlinks = matrixofVEOGiBlinks; % Compute mean eyeblink artifact
    else
        meanofVEOGiBlinks = mean(matrixofVEOGiBlinks); % Compute mean eyeblink artifact
    end
    
    % Populate Component Matrix From ICA activity - Number of ICA Components * Window Period * Number of Artifacts
    matrixofICAiBlinks3D = zeros(size(INEEG.icaweights,1), (r.Window(2)-r.Window(1))+1, size(ArtifactLatencies,2));
    for blinkindex = 1:size(ArtifactLatencies,2) % for each artifact
        tempmat = INEEG.icaact(:,(r.Window(1)+ArtifactLatencies(blinkindex)):(r.Window(2)+ArtifactLatencies(blinkindex))); % Extract data from icaact
        for compindex = 1:size(INEEG.icaweights,1) % for each component
            tempmat(compindex,:) = tempmat(compindex,:) - tempmat(compindex,1); % Baseline correct matrix
        end
        matrixofICAiBlinks3D(:,:,blinkindex) = tempmat; % load baseline corrected windowed data from icaact into matrix
    end
    % Average Across Eyeblinks - Number of ICA Components * Window Period
    if (size(ArtifactLatencies,2) == 1)
        matrixofICAiBlinks = matrixofICAiBlinks3D;
    else
        matrixofICAiBlinks = zeros(size(INEEG.icaweights,1), (r.Window(2)-r.Window(1))+1);
        for compindex = 1:size(INEEG.icaweights,1) % for each component
            tempmat = squeeze(matrixofICAiBlinks3D(compindex,:,:))'; % Extract data only for this compnent
            matrixofICAiBlinks(compindex,:) = mean(tempmat);
        end
    end
    
    % Populate Eyeblink Matrix From Raw EEG - Number of EEG Channels * Window Period * Number of Artifacts
    matrixofEEGiBlinks3D = zeros(INEEG.nbchan, (r.Window(2)-r.Window(1))+1, size(ArtifactLatencies,2));
    for blinkindex = 1:size(ArtifactLatencies,2) % for each artifact
        tempmat = INEEG.data(:,(r.Window(1)+ArtifactLatencies(blinkindex)):(r.Window(2)+ArtifactLatencies(blinkindex))); % Extract data from EEG.data
        for chanindex = 1:INEEG.nbchan % for each channel
            tempmat(chanindex,:) = tempmat(chanindex,:) - tempmat(chanindex,1); % Baseline correct matrix
        end
        matrixofEEGiBlinks3D(:,:,blinkindex) = tempmat; % load baseline corrected windowed data from EEG.data into matrix
    end
    % Average Across Eyeblinks - Number of EEG Channels * Window Period
    if (size(ArtifactLatencies,2) == 1)
        matrixofEEGiBlinks = matrixofEEGiBlinks3D;
    else
        matrixofEEGiBlinks = zeros(INEEG.nbchan, (r.Window(2)-r.Window(1))+1);
        for chanindex = 1:INEEG.nbchan % for each channel
            tempmat = squeeze(matrixofEEGiBlinks3D(chanindex,:,:))'; % extract data only for this channel
            matrixofEEGiBlinks(chanindex,:) = mean(tempmat);
        end
    end
    
    %% Step 3: Compute Metrics comparing the EOG blink with the ICA components
    % Correlate EOG blinks with components
    Correlation = ones(1,size(INEEG.icaweights,1));
    CorrelationP = NaN(1,size(INEEG.icaweights,1));
    for compindex = 1:size(INEEG.icaweights,1) % for each ICA component
        [Rval, Pval] = corrcoef([meanofVEOGiBlinks(:) matrixofICAiBlinks(compindex,:)']); % Compute correlation between mean eyeblink and mean ICA activity surrounding eyeblink
        Correlation(compindex) = abs(Rval(2,1)); % Extract absolute value of correlation - direction makes no difference as VEOG is bipolar
        CorrelationP(compindex) = Pval(2,1); % Extract p value
    end
    
    % meanConvolution of EOG blinks with components
    ConvolutionP = NaN(1,size(INEEG.icaweights,1));
    matrixofICAConvolution = NaN(size(INEEG.icaweights,1),((r.Window(2)-r.Window(1))*2)+1);
    for compindex = 1:size(INEEG.icaweights,1) % for each ICA component
        matrixofICAConvolution(compindex,:) = conv(abs(meanofVEOGiBlinks(:)), abs(matrixofICAiBlinks(compindex,:)')); % convolution of eyeblink artifact and ica activity for each ica component
    end
    Convolution = mean(matrixofICAConvolution');% mean convolution of eyeblink artifact and ica activity for each ica component
    ConvolutionZ = adjustbynumberofsamples(trimzscore(Convolution)); % adjust Z score by number of channels
    sampleZ = trimzscore(ConvolutionZ); % Z score of adjusted convolutions - yes this is the z-score of a z-score but the adjustment takes into account regression towards the mean for larger channel numbers
    for cC = 1:numel(sampleZ) % Compute P value for each adjusted Z score
        %ConvolutionP(cC) = normcdf(-abs(sampleZ(cC)),0,1);
        ConvolutionP(cC) = 0.5 * erfc(-(-abs(sampleZ(cC))-0)/1*sqrt(2)); % Formula obtained from Matlab File Exchange - guassian_mixture_model.m by Matthew Roughan - Oct-28-2009
    end
    
    %% Step 4: Compute Metrics comparing the reduction in blink artifact when components are removed
    meanofEEGiBlinks = mean(abs(matrixofEEGiBlinks)); % return the average rectified blink artifact collapsed across channels
    meanofEEGiBlinks = fastsmooth(meanofEEGiBlinks, floor(INEEG.srate/100), 2, 0); % Smooth the data to remove high frequency noise
    meanofEEGConvolution = mean(conv(abs(meanofEEGiBlinks), abs(meanofEEGiBlinks))); % Convolve EEG artifact with itself as a baseline for computation of percent change
    PercentChangeP = NaN(1,size(INEEG.icaweights,1));
    meanEEGiBlinksafterICAremoval = NaN(size(INEEG.icaweights,1), (r.Window(2)-r.Window(1))+1);
    
    % To increase computational speed, restrict to only epochs containing the artifact
    INEEG.data = reshape(matrixofEEGiBlinks3D, size(matrixofEEGiBlinks3D,1), size(matrixofEEGiBlinks3D,2)*size(matrixofEEGiBlinks3D,3));
    INEEG.pnts = size(INEEG.data,2);
    INEEG.xmin = 0;
    INEEG.xmax = (INEEG.pnts-1)/INEEG.srate+INEEG.xmin;
    INEEG.times = INEEG.times(1:size(INEEG.data,2));
    INEEG.icaact = [];
    ORIGEEG = INEEG; % Save copy of original EEG set
    
    % Cycle through removing each ICA component and determining its effect on the ERP time series
    fprintf('icablinkmetrics(): Removing Components (with replacement)')
    % Establish matrix for EEG data after removal of each ICA component - Number of ICA components * Window Period
    matrixofEEGConvolutionafterICAremoval = zeros(size(INEEG.icaweights,1),((r.Window(2)-r.Window(1))*2)+1);
    PercentChangeofEEGConvolutionafterICAremoval = zeros(1,size(INEEG.icaweights,1));
    for compindex = 1:size(INEEG.icaweights,1) % For each ICA Component
        clear INEEG
        INEEG = ORIGEEG;
        [T, INEEG] = evalc('pop_subcomp( INEEG, compindex, 0);'); % Remove component
        fprintf('.')
        % Populate Eyeblink Matrix From Raw EEG - Number of EEG Channels * Window Period * Number of Artifacts
        matrixofEEGiBlinks3DafterICAremoval = reshape(INEEG.data, size(matrixofEEGiBlinks3D,1), size(matrixofEEGiBlinks3D,2), size(matrixofEEGiBlinks3D,3));
        % Average Across Eyeblinks - Number of Channels * Window Period
        if (size(ArtifactLatencies,2) == 1)
            matrixofEEGiBlinksafterICAremoval = matrixofEEGiBlinks3DafterICAremoval;
        else
            matrixofEEGiBlinksafterICAremoval = zeros(INEEG.nbchan, (r.Window(2)-r.Window(1))+1);
            for chanindex = 1:INEEG.nbchan % for each channel
                tempmat = squeeze(matrixofEEGiBlinks3DafterICAremoval(chanindex,:,:))'; % extract data only for this channel
                matrixofEEGiBlinksafterICAremoval(chanindex,:) = mean(tempmat);
            end
        end
        tempmat = mean(abs(matrixofEEGiBlinksafterICAremoval)); % return the average rectified blink artifact collapsed across channels following removal of ICA component
        meanEEGiBlinksafterICAremoval(compindex,:) = fastsmooth(tempmat, floor(INEEG.srate/100), 2, 0); % Smooth the data to remove high frequency noise
        matrixofEEGConvolutionafterICAremoval(compindex,:) = conv(abs(meanofEEGiBlinks(:)), abs(meanEEGiBlinksafterICAremoval(compindex,:))); % Convolve original EEG artifact with EEG data following ICA removal
        % Compute Percent Change
        PercentChangeofEEGConvolutionafterICAremoval(compindex) = ((meanofEEGConvolution-mean(matrixofEEGConvolutionafterICAremoval(compindex,:)))/meanofEEGConvolution)*100;
    end
    % Apply more conceptually appropriate labels
    PercentChange = PercentChangeofEEGConvolutionafterICAremoval;
    matrixofEEGiBlinksafterICAremoval = meanEEGiBlinksafterICAremoval; 
    clear INEEG
    INEEG = ORIGEEG;
    fprintf('\n')

    % Compute P value for each Z score
    sampleZ = trimzscore(PercentChange); % Z score of percent reductions
    for cC = 1:numel(sampleZ)
        %PercentChangeP(cC) = normcdf(-abs(sampleZ(cC)),0,1);
        PercentChangeP(cC) = 0.5 * erfc(-(-abs(sampleZ(cC))-0)/1*sqrt(2)); % Formula obtained from Matlab File Exchange - guassian_mixture_model.m by Matthew Roughan - Oct-28-2009
    end
    
    % Adjust pvalues based on number of tails
    if (r.Tails == 2)
        CorrelationP = CorrelationP * 2;
        ConvolutionP = ConvolutionP * 2;
        PercentChangeP = PercentChangeP * 2;
    end
    
    % Check for Matlab version bug which can return P values greater than 1 Seems to be isolated to the Correlation statistic but checking on all to be safe
    CorrelationP(find(CorrelationP>1)) = 1;
    ConvolutionP(find(ConvolutionP>1)) = 1;
    PercentChangeP(find(PercentChangeP>1)) = 1;
    
    %% Step 5: Apply threshold settings
    if ~(isnan(r.MetricThresholds(1)))
        selCorrelationa = find(CorrelationP <= r.MetricThresholds(1));
        selCorrelationb = find(Correlation >= r.MinimumCorrelation);
        selCorrelation = intersect(selCorrelationa,selCorrelationb); % correlation with artifact must be above specified level as well
    else
        selCorrelation = 1:size(INEEG.icaweights,1);
    end
    if ~(isnan(r.MetricThresholds(2)))
        selConvolutionZ = find(ConvolutionP <= r.MetricThresholds(2));
    else
        selConvolutionZ = 1:size(INEEG.icaweights,1);
    end
    if ~(isnan(r.MetricThresholds(3)))
        selPercentChange = find(PercentChangeP <= r.MetricThresholds(3));
        selPercentChangeDir = find(PercentChange>0); % take only components that make the artifact smaller
        selPercentChange = intersect(selPercentChange, selPercentChangeDir);
    else
        selPercentChange = 1:size(INEEG.icaweights,1);
    end
    ThresholdedComponents = intersect(intersect(selCorrelation,selConvolutionZ),selPercentChange);
    
    %% Load metrics into structure
    metrics = struct('component', [],'correlation', [], 'corr_Pvalue', [], 'convolution', [], 'conv_Pvalue', [], 'percentreduction', [], 'perc_Pvalue', []);
    boolwarn = 0;
    for cR = 1:size(INEEG.icaweights,1)
        metrics(cR).component = cR;
        metrics(cR).correlation = Correlation(cR);
        metrics(cR).corr_Pvalue = CorrelationP(cR);
        metrics(cR).convolution = ConvolutionZ(cR);
        metrics(cR).conv_Pvalue = ConvolutionP(cR);
        metrics(cR).percentreduction = PercentChange(cR);
        metrics(cR).perc_Pvalue = PercentChangeP(cR);
        if (abs(PercentChange(cR)) > 200)
            boolwarn = 1;
        end
    end
    
    if (boolwarn == 1)
        error('Error at icablinkmetrics(). The Percent Reduction in the artifact suggests that a bad channel may have been included in the ICA computation. Try visually inspecting the data following removal of a component to see if any channels become noisy.')    
    end
    
    matrixofselected = zeros(1, size(INEEG.icaweights,1));
    if (isempty(ThresholdedComponents))
        ThresholdedComponents = 0;
    else
        for cComp = 1:numel(ThresholdedComponents)
            matrixofselected(ThresholdedComponents(cComp)) = 1;
        end
    end
    
    comparisons = struct('artifactcorrelation', [], 'artifactconvolution', [], 'artifactpercentreduction', [], 'nonartifactcorrelation', [],'nonartifactconvolution', [], 'nonartifactpercentreduction', []);
    comparisons.artifactcorrelation = Correlation(matrixofselected~=0);
    comparisons.artifactconvolution = ConvolutionZ(matrixofselected~=0);
    comparisons.artifactpercentreduction = PercentChange(matrixofselected~=0);
    comparisons.nonartifactcorrelation = Correlation(matrixofselected==0);
    comparisons.nonartifactconvolution = ConvolutionZ(matrixofselected==0);
    comparisons.nonartifactpercentreduction = PercentChange(matrixofselected==0);
    
    icablinkmetricsout = struct('metrics', metrics, 'identifiedcomponents', ThresholdedComponents, 'comparisons', comparisons, 'artifactlatencies', ArtifactLatencies);

    if (strcmpi(r.VisualizeData, 'True'))
        try
                visualize_icablinkmetrics(ThresholdedComponents, r.Window, matrixofVEOGiBlinks, matrixofICAiBlinks, matrixofICAConvolution, meanofEEGiBlinks, matrixofEEGiBlinksafterICAremoval)
        catch
                warning('Data visualization appears to have had a problem...')
        end
    end
    
end
    
    