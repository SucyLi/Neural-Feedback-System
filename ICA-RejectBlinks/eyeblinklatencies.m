function [iBlinkLatencies, iBlinklength, iBlink, meaniBlink, iBlinkEpochs] = eyeblinklatencies(varargin)
%   Uses an idealized eyeblink to identify only those periods associated with 
%   the eyeblink in the EOG channel. Returns the latencies of the eyeblinks
%   and the length of the iblink period.
%
%   1   'BlinkActivity' - EOG Data
%   2   'SampleRate' - EEG sampling rate
%   3   'Threshold' - Critical correlation threshold to identify as an eyeblink - Default is 0.96
%   4   'Template' - Vector to use as template for eyeblink.
%
%   Outputs:
%   1    iBlinkLatencies - Array of data points corresponding to the onset data point of the eyeblink 
%   2    iBlinklength - Number of points the eyeblink spans
%   3    iBlink - Returns the eyeblink template
%   4    meaniBlink - Returns the mean eyeblink activity
%   5    iBlinkEpochs - Returns a matrix of the eyeblink activity
%       
%   Example Code:
%   EEG.icaquant.artifactlatencies = eyeblinklatencies('BlinkActivity', EEG.data(find(strcmp({EEG.chanlocs.labels},'VEOG')),:), 'SampleRate', EEG.srate, 'Threshold', 0.96);
%
%   % Full outputs 
%   [iBlinkLatencies, iBlinklength, iBlink, meaniBlink, iBlinkEpochs] = eyeblinklatencies('BlinkActivity', EEG.data(find(strcmp({EEG.chanlocs.labels},'VEOG')),:), 'SampleRate', EEG.srate, 'Threshold', 0.96);
%
%   NOTE: You must have the Matlab Statistics Toolbox installed.
%
%   Author: Matthew B. Pontifex, Health Behaviors and Cognition Laboratory, Michigan State University, July 28, 2014
    if ~isempty(varargin)
             r=struct(varargin{:});
    end
    try, r.BlinkActivity;  tDat = r.BlinkActivity; catch, r.BlinkActivity=0;  error('Error at eyeblinklatencies(). Missing information! Please input Blink Activity data.');   end
    try, r.SampleRate;  samrate = r.SampleRate; catch, r.SampleRate=0;  error('Error at eyeblinklatencies(). Missing information! Please input Sampling Rate.');   end
    try, r.Threshold; correlationthreshold = r.Threshold; catch, r.Threshold=0.96; end
    try, r.Template; iBlink = r.Template; catch, iBlink=[]; end
    
    if (numel(tDat) == 0)
       error('Error at eyeblinklatencies(). Missing information! The channel you inputted does not have any data included.');
    end
    
    tDat = fastsmooth(tDat, floor(samrate/15), 2, 1);% Smooth the artifact channel to remove high frequency noise
    fprintf('\neyeblinklatencies(): Determining Eyeblink Latencies ')
    
    % Identify eyeblink components
    iBlinkLatencies = [];
    if isempty(iBlink)
        iBlink = [0.002103442	0.004102538	0.006056177	0.007978822	0.009864274	0.011719766	0.013558728	0.015388392	0.018213987	0.021078842	0.023960227	0.02685091	0.029752957	0.032679799	0.035638668	0.038617166	0.041594631	0.044511142	0.047397692	0.050293541	0.053222449	0.056191649	0.05917738	0.062145547	0.065080654	0.067994065	0.070902311	0.073786795	0.076605159	0.079320211	0.081893724	0.084284375	0.0864684	0.088428238	0.090129794	0.091526579	0.092578299	0.093251897	0.093512244	0.093342812	0.092746699	0.09171874	0.090235173	0.088258805	0.085753478	0.082686131	0.079013373	0.074678382	0.069609872	0.063738625	0.057004719	0.049354431	0.040729906	0.031059859	0.020266806	0.008283593	-0.004940402	-0.019455803	-0.035344227	-0.052712086	-0.071671989	-0.092324151	-0.114763618	-0.139091637	-0.165418753	-0.193851376	-0.224490753	-0.257417469	-0.292719338	-0.330496574	-0.370833893	-0.413801546	-0.459439828	-0.507768365	-0.558825385	-0.612646014	-0.66923273	-0.728514765	-0.790346759	-0.854573328	-0.921113271	-0.99001132	-1.061343411	-1.135055822	-1.210918164	-1.28858331	-1.367715492	-1.44807296	-1.529420161	-1.61134178	-1.693139424	-1.773977295	-1.853168365	-1.930353107	-2.005337294	-2.077955625	-2.147887832	-2.21476199	-2.2782475	-2.338241048	-2.394763297	-2.447803917	-2.497197606	-2.542717078	-2.58417637	-2.621513494	-2.654780108	-2.684038198	-2.709349752	-2.730735432	-2.748236563	-2.761946127	-2.771957105	-2.778341815	-2.781162246	-2.780501046	-2.776451197	-2.769126344	-2.75865046	-2.745147521	-2.72873117	-2.709546045	-2.687726453	-2.66341703	-2.636752083	-2.607917574	-2.577058141	-2.544339083	-2.509925702	-2.473952301	-2.436604845	-2.398048634	-2.358448966	-2.317971143	-2.276708144	-2.234773615	-2.192270867	-2.149334207	-2.106046284	-2.062489749	-2.018747252	-1.974870448	-1.930941988	-1.887054853	-1.843302024	-1.799770284	-1.75650819	-1.713557066	-1.670970635	-1.628806752	-1.587123272	-1.545967719	-1.505366953	-1.465324075	-1.425853548	-1.386994631	-1.348801046	-1.311322383	-1.274581371	-1.238590408	-1.203373255	-1.168952641	-1.135335798	-1.102509296	-1.070450405	-1.039147762	-1.008603431	-0.978841177	-0.949886825	-0.92174451	-0.8944008	-0.867843608	-0.842088637	-0.817165435	-0.793079683	-0.769802652	-0.747292735	-0.725498868	-0.704373742	-0.683898968	-0.664074959	-0.644900165	-0.62635971	-0.608440163	-0.591454561	-0.5754184	-0.560361642	-0.546336975	-0.533411552	-0.521672157	-0.511217969	-0.502155399	-0.497323475	-0.49310936	-0.48957814	-0.486814531	-0.484913582	-0.483977571	-0.484111877	-0.485446674]; % 400 ms chunk of idealized eyeblink data (500 Hz)
         try 
            TS = timeseries(iBlink',1:200,'name', 'eyeblink'); % Create time series object
            TSC = tscollection(TS);
            TSC2 = resample(TSC, 1:(((1/samrate)*1000)/2):200); % Determine the current ms per sample and divide by 2 (for the 500 hz original) 
            iBlink = TSC2.eyeblink.Data';
        catch
            try % try to use newer implementation of resample
                [N,D] = rat((samrate / 500), 1e-7); %Rational fraction approximation
                iBlink = resample(iBlink,N,D); % matches the idealized eyeblink to the correct sample rate
            catch
                error('error at eyeblinklatencies(): The version of MATLAB you are currently using does not appear to support currently implemented methods of interpolation. Try another method of identifying the eye blinks')
            end
        end
   end
    
    % Cycles through each data point calculating the correlation between the eyeblink and the data
    pointindexStart = 1;
    pcount = 150;
    spantime = floor((size(tDat,2)/samrate)/120); 
    try
        % see if matlab can run crosscorrelation
        tDatxcorr = xcorr(tDat,iBlink); % Obtain cross correlation
        tDatxcorr = tDatxcorr(size(tDat,2):size(tDat,2)+size(tDat,2)-1); % align data
        [pksp, locsp] = findpeaks(tDatxcorr); % obtain peaks
        pksp = abs(trimzscore(pksp,'trimMin', spantime, 'trimMax',spantime)); % Z score and rectify data
        [pksn, locsn] = findpeaks(tDatxcorr*-1); % obtain inverse peaks
        pksn = abs(trimzscore(pksn,'trimMin', spantime, 'trimMax',spantime)); % Z score and rectify data
        tDatxcorrZsel = sort(horzcat(locsp(find(pksp>1)),locsn(find(pksn>1)))); % toss out any peaks that are small
        
        %plot(tDatxcorr)
        %findpeaks(tDatxcorr);
        %tempcorrs = [];
        for i = 1:numel(tDatxcorrZsel)
            pointindexStart = tDatxcorrZsel(i);
            pointindexStop = pointindexStart + size(iBlink,2) - 1;
            bComp = tDat(pointindexStart:pointindexStop);
            R=corrcoef([iBlink(:) bComp(:)]);
            R = abs(R(2,1));
            %tempcorrs(end+1) = R;
            if (R > correlationthreshold)
                iBlinkLatencies(end+1) = pointindexStart+(ceil(size(iBlink,2)*.6));
                fprintf('.')
            end
        end
    catch
        booler = 1;
    end
    if isempty(iBlinkLatencies)
        refperiod = floor((200 / samrate)*1000); % Sets the number of points for the refractory period
        while pointindexStart < (size(tDat,2)-size(iBlink,2))
            pointindexStop = pointindexStart + size(iBlink,2) - 1;
            bComp = tDat(pointindexStart:pointindexStop);
            R=corrcoef([iBlink(:) bComp(:)]);
            R = abs(R(2,1));
            if (R > correlationthreshold)
                iBlinkLatencies(end+1) = pointindexStart+(ceil(size(iBlink,2)*.6));
                pointindexStart = pointindexStart + refperiod;
                fprintf('.')
                pcount = pcount + 1;
                if (pcount > 250)
                    fprintf('\n\n')
                    pcount = 0;
                end
            end
            pointindexStart = pointindexStart + 1;
        end
    end
    iBlinklength = size(iBlink,2);
    tDat = r.BlinkActivity;
    iBlinkEpochs = zeros(size(iBlinkLatencies,2),iBlinklength);
    for blinkindex = 1:size(iBlinkLatencies,2)
        winstart = iBlinkLatencies(blinkindex)-(ceil(size(iBlink,2)*.6));
        winstop = winstart + iBlinklength - 1;
        iBlinkEpochs(blinkindex,:) = tDat(winstart:winstop);
        iBlinkEpochs(blinkindex,:) = iBlinkEpochs(blinkindex,:) - iBlinkEpochs(blinkindex,1); %baseline correct
    end
    meaniBlink = mean(iBlinkEpochs);
    
    % Verify that the artifacts are consistent in case some other artifact was mistakenly included
    try
        for rpt = 1:2
            selfconvolv = sum(conv(meaniBlink(:), meaniBlink(:)))*0.25;
            convolutionofVEOGiBlinks = zeros(1,size(iBlinkLatencies,2));
            correlationofVEOGiBlinks = zeros(1,size(iBlinkLatencies,2));
            for blinkindex = 1:size(iBlinkLatencies,2)
                Rval = corrcoef([meaniBlink(:) iBlinkEpochs(blinkindex,:)']);
                correlationofVEOGiBlinks(blinkindex) = abs(Rval(2,1)); 
                convolutionofVEOGiBlinks(blinkindex) = sum(conv(meaniBlink(:), iBlinkEpochs(blinkindex,:)'));
            end
            correlationofVEOGiBlinks = abs(trimzscore(correlationofVEOGiBlinks)); % Normalize correlations
            convolutionofVEOGiBlinksz = abs(trimzscore(convolutionofVEOGiBlinks)); % Normalize convolutions
            removeVEOGiBlinks = zeros(1,size(iBlinkLatencies,2));
            for blinkindex = 1:size(iBlinkLatencies,2)
                if ((correlationofVEOGiBlinks(blinkindex) > 2.5) || (convolutionofVEOGiBlinksz(blinkindex) > 2.5) || (convolutionofVEOGiBlinks(blinkindex) < selfconvolv)) % If the blink is more than 2.5x deviant or has a convolution less than 20% of the selfconvolution remove it
                    removeVEOGiBlinks(blinkindex) = 1;
                    iBlinkLatencies(blinkindex) = 0;
                end
            end
            if ~(isempty(find(removeVEOGiBlinks, 1))) % if an artifact was removed
                iBlinkLatencies = iBlinkLatencies(iBlinkLatencies~=0); % Remove blinks which are not consistent
                iBlinkEpochs = zeros(size(iBlinkLatencies,2),iBlinklength);
                for blinkindex = 1:size(iBlinkLatencies,2)
                    winstart = iBlinkLatencies(blinkindex)-(ceil(size(iBlink,2)*.6));
                    winstop = winstart + iBlinklength - 1;
                    iBlinkEpochs(blinkindex,:) = tDat(winstart:winstop);
                    iBlinkEpochs(blinkindex,:) = iBlinkEpochs(blinkindex,:) - iBlinkEpochs(blinkindex,1); %baseline correct
                end
                meaniBlink = mean(iBlinkEpochs);
            end
        end
    catch
       booler = 1; 
    end
    fprintf('\n')
end
       
    
    