function [OUTEEG, com] = pop_movechannels(INEEG)

    if isobject(INEEG) % eegobj
        disp('Error in pop_movechannels(): This function is not designed to work with the EEG object.')
        beep
    else
        if isempty(INEEG)
            disp('Error in pop_movechannels(): This function cannot run on an empty EEG dataset.')
            beep
        else
            if isempty(INEEG.data)
                disp('Error in pop_movechannels(): This function cannot run on an empty EEG dataset.')
                beep
            else

                % Prepare List of Current Channels in EEG.data
                listch = cell(1,size(INEEG.chanlocs,2)+1);
                listch{1} = '';
                for ch =1:size(INEEG.chanlocs,2)
                        listch{ch+1} = [num2str(ch) ' = ' INEEG.chanlocs(ch).labels ];
                end
                % Prepare List of Current Channels in EEG.skipchannels
                try
                    listch2 = cell(1,size(INEEG.skipchannels.labels,2)+1);
                    listch2{1} = '';
                    for ch =1:size(INEEG.skipchannels.labels,2)
                            listch2{ch+1} = [num2str(ch) ' = ' INEEG.skipchannels.labels{ch} ];
                    end
                catch
                    listch2=[ 'No Channels Available' ];
                end
                
                g1 = [0.5 0.5 ];
                g2 = [0.05 0.475 0.475];
                s1 = [1];
                geometry = { s1 g2 s1 s1 g2 s1};
                uilist = { ...
                      { 'Style', 'text', 'string', 'Restore Channel to EEG.data'} ...
                      ...
                      { } ...
                      { 'Style', 'text', 'string', 'Channels in EEG.skipchannels'  } ...
                      { 'Style', 'popupmenu', 'string', listch2 'tag' 'EEGSKIP' } ...
                      ...
                      { } ...
                      ...
                      { 'Style', 'text', 'string', 'Remove Channel from EEG.data'} ...
                      ...
                      { } ...
                      { 'Style', 'text', 'string', 'Channels in EEG.data'  } ...
                      { 'Style', 'popupmenu', 'string', listch 'tag' 'EEGDATA' } ...
                      ...
                      { } ...
                      ...
                  };

                  [ tmp1 tmp2 strhalt structout ] = inputgui( geometry, uilist, 'pophelp(''movechannels'');', 'Relocate Referential/Bipolar Channel -- pop_movechannels');
                  if ~isempty(structout)
                      if (structout.EEGSKIP > 1)
                          chanlab = INEEG.skipchannels.labels(structout.EEGSKIP-1);
                          OUTEEG = movechannels( INEEG, 'Location', 'skipchannels', 'Direction', 'Restore', 'Channels', chanlab);
                          com = sprintf('\nEquivalent Code:\n\t%s= movechannels(%s, ''Location'', ''skipchannels'', ''Direction'', ''Restore'', ''Channels'', { ''%s'' });\n', inputname(1), inputname(1), INEEG.skipchannels.labels{structout.EEGSKIP-1});
                          disp(com)
                      end
                      if (structout.EEGDATA > 1)
                          chanlab = {INEEG.chanlocs(structout.EEGDATA-1).labels};
                          OUTEEG = movechannels( INEEG, 'Location', 'skipchannels', 'Direction', 'Remove', 'Channels', chanlab);
                          com = sprintf('\nEquivalent Code:\n\t%s= movechannels(%s, ''Location'', ''skipchannels'', ''Direction'', ''Remove'', ''Channels'', { ''%s'' });\n', inputname(1), inputname(1), INEEG.chanlocs(structout.EEGDATA-1).labels);
                          disp(com)
                      end
                  else
                      OUTEEG = INEEG;
                      com = '';
                  end
            end
        end
    end
end