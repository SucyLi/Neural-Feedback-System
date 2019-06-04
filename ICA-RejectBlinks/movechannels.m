function [ OUTEEG ] = movechannels(INEEG, varargin)
%   Function to remove channels from the basic EEG.data
%   structure but retain them within the EEG data set. The function can
%   also be used to restore the data back into the EEG.data structure and
%   update the EEG.chanloc structure.
%
%   1   Input EEG structure
%   2   The available parameters are as follows:
%       a    'Location' - Label of EEG structure to store or obtain data from
%       b    'Direction' - [ 'Remove' | 'Restore' ] channels from/to the EEG.data structure
%       c    'Channels' - Array of channels.
%       
%   Example Code:
%
%   % Removes data from EEG.data and places it into EEG.skipchannels
%   EEG = movechannels( EEG, 'Location', 'skipchannels', 'Direction', 'Remove', 'Channels', { 'M1' 'M2' 'VEOG' 'HEOG'});
%
%   % Removes data from EEG.skipchannels and places it into EEG.data
%   EEG = movechannels( EEG, 'Location', 'skipchannels', 'Direction', 'Restore', 'Channels', { 'M1' 'M2' 'VEOG' 'HEOG'});
%
%   Author: Matthew B. Pontifex, Health Behaviors and Cognition Laboratory, Michigan State University, December 21, 2014

    if ~isempty(varargin)
             r=struct(varargin{:});
    end
    try, r.Location; catch, error('Error at movechannels(). Missing information! Please input label of the EEG structure.');   end
    try, r.Direction; catch, error('Error at movechannels(). Missing information! Please input whether you would like to Remove or Restore the channels.');   end
    try, r.Channels; desiredarray = {r.Channels}; catch, error('Error at movechannels(). Missing information! Please input channels to operate on.');   end
    
    boolcont = 'False';
    if (strcmpi(r(1).Direction,'Remove'))
        boolcont = 'True';
    end
    if (strcmpi(r(1).Direction,'Restore'))
        boolcont = 'True';
    end
    if (strcmpi(boolcont,'False'))
        error('Error at movechannels(). Missing information! Please input whether you would like to Remove or Restore the channels.');
    end
    
    % Load existing information into variables
    try
        currentlabels = eval(['INEEG.', r(1).Location, '.labels']);
        currentdata = eval(['INEEG.', r(1).Location, '.data']);
    catch
        currentlabels = {};
        currentdata = [];
    end
    
    % If the user would like to remove the channels from the data
    if (strcmpi(r(1).Direction,'Remove'))
        for chanindex = 1:size(desiredarray, 2)
                chann = 0;
                for m=1:size(INEEG.chanlocs, 2)
                    if (strcmp(INEEG.chanlocs(m).('labels'),(desiredarray(chanindex))) > 0)
                        chann = m;
                        break;
                    end
                end
                if (chann ~=0)
                    % Check to see if that channel already exists in the temporary set
                    boolcont = 'False';
                    for chan2index = 1:size(currentlabels,2)
                        if (strcmpi(currentlabels(chan2index),desiredarray(chanindex)))
                            boolcont = 'True';
                        end
                    end
                    if (strcmpi(boolcont,'False'))
                        currentlabels(end+1) = desiredarray(chanindex);
                        currentdata(end+1,:) = INEEG.data(chann,:);
                    end
                end
        end
        % Load data into EEG structure
        INEEG.(sprintf('%s',r(1).Location)).labels = currentlabels;
        INEEG.(sprintf('%s',r(1).Location)).data = currentdata;

        INEEG = pop_select( INEEG, 'nochannel', currentlabels); % Remove channels from data
        INEEG = eeg_checkset(INEEG);
        
        outmessage = ['Channels have been moved from EEG.data to EEG.', r(1).Location];
        disp(sprintf('\n%s\n',outmessage))
    end
    
    if (strcmpi(r(1).Direction,'Restore'))
        removearray = ones(size(currentlabels));
        for chanindex = 1:size(desiredarray, 2)
            chann = 0;
            for m=1:size(INEEG.chanlocs, 2)
                if (strcmp(INEEG.chanlocs(m).('labels'),(desiredarray(chanindex))) > 0)
                    chann = m;
                    break;
                end
            end
            if (chann == 0)
                chann2 = 0;
                for chan2index = 1:size(currentlabels, 2);
                    if (strcmp(currentlabels(chan2index),(desiredarray(chanindex))) > 0)
                        INEEG.data(end+1,:) = currentdata(chan2index,:);
                        INEEG.chanlocs(end+1).labels = currentlabels{chan2index};
                        removearray(chan2index) = 0;
                    end
                end
            end
        end
        INEEG.nbchan = size(INEEG.data,1);
        newdata = [];
        newlabels = {};
        for chanindex = 1:size(removearray, 2)
            if (removearray(chanindex) == 1)
                newlabels(end+1) = currentlabels(chanindex);
                newdata(end+1,:) = currentdata(chanindex,:);
            end
        end
        if (numel(newlabels) > 0)
            % Load remaining data into EEG structure
            INEEG.(sprintf('%s',r(1).Location)).labels = newlabels;
            INEEG.(sprintf('%s',r(1).Location)).data = newdata;
        else
            INEEG.(sprintf('%s',r(1).Location)).labels = [];
            INEEG.(sprintf('%s',r(1).Location)).data = [];
            INEEG.(sprintf('%s',r(1).Location)) = rmfield(INEEG.(sprintf('%s',r(1).Location)),'labels');
            INEEG.(sprintf('%s',r(1).Location)) = rmfield(INEEG.(sprintf('%s',r(1).Location)),'data');
            if (numel(structfun(@numel,INEEG.(sprintf('%s',r(1).Location)))) == 0)
                INEEG = rmfield(INEEG,(sprintf('%s',r(1).Location)));
            end
        end
        INEEG = eeg_checkset(INEEG);
        outmessage = ['Channels have been moved from EEG.', r(1).Location, ' to EEG.data'];
        disp(sprintf('\n%s\n',outmessage))
    end
    OUTEEG = INEEG;
end


