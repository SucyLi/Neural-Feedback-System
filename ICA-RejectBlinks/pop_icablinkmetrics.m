function [OUTEEG, com] = pop_icablinkmetrics(INEEG)

    if isobject(INEEG) % eegobj
        disp('Error in pop_icablinkmetrics(): This function is not designed to work with the EEG object.')
        beep
    else
        if isempty(INEEG)
            disp('Error in pop_icablinkmetrics(): This function cannot run on an empty EEG dataset.')
            beep
        else
            if isempty(INEEG.data)
                disp('Error in pop_icablinkmetrics(): This function cannot run on an empty EEG dataset.')
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
                geometry = { s1 g2 g2 g2 s1 s1 g2 g2 g2 s1};
                uilist = { ...
                      { 'Style', 'text', 'string', 'Channel Artifact Manifests In'} ...
                      ...
                      { } ...
                      { 'Style', 'text', 'string', 'Channel in EEG.data'  } ...
                      { 'Style', 'popupmenu', 'string', listch 'tag' 'EEGDATA' } ...
                      ...
                      { } ...
                      { 'Style', 'text', 'string', '         or'  } ...
                      { } ...
                      ...
                      { } ...
                      { 'Style', 'text', 'string', 'Channel in EEG.skipchannels'  } ...
                      { 'Style', 'popupmenu', 'string', listch2 'tag' 'EEGSKIP' } ...
                      ...
                      { } ...
                      ...
                      { 'Style', 'text', 'string', 'Thresholds for Artifact Selection (entering NaN will skip that metric) '} ...
                      ...
                      { } ...
                      { 'Style', 'text', 'string', 'Correlation Alpha'} ...
                      { 'Style', 'edit', 'string', '0.001' 'tag' 'Correlation'  } ...
                      ...
                      { } ...
                      { 'Style', 'text', 'string', 'Convolution Alpha'} ...
                      { 'Style', 'edit', 'string', '0.001' 'tag' 'Convolution'  } ...
                      ...
                      { } ...
                      { 'Style', 'text', 'string', 'PercentReduction Alpha'} ...
                      { 'Style', 'edit', 'string', '0.001' 'tag' 'PercentReduction'  } ...
                      ...
                      { } ...
                      ...
                  };

                  [ tmp1 tmp2 strhalt structout ] = inputgui( geometry, uilist, 'pophelp(''icablinkmetrics'');', 'Compute ICA Eye Blink Metrics -- pop_icablinkmetrics');
                  OUTEEG = INEEG;
                  if ~isempty(structout)
                      structout.Correlation = str2num(structout.Correlation);
                      structout.Convolution = str2num(structout.Convolution);
                      structout.PercentReduction = str2num(structout.PercentReduction);
                      if (structout.EEGDATA > 1)
                          OUTEEG.icaquant = icablinkmetrics(INEEG,'ArtifactChannel',INEEG.data(structout.EEGDATA-1,:),'MetricThresholds',[structout.Correlation,structout.Convolution,structout.PercentReduction],'VisualizeData', 'True');
                          com = sprintf('\nEquivalent Code:\n%s.icaquant = icablinkmetrics(%s,''ArtifactChannel'',EEG.data(find(strcmp({EEG.chanlocs.labels},''%s'')),:),''MetricThresholds'',%s,''VisualizeData'',''True'');\n', inputname(1),inputname(1),INEEG.chanlocs((structout.EEGDATA-1)).labels,mat2str([structout.Correlation,structout.Convolution,structout.PercentReduction]));
                          disp(com)
                          disp('ICA Metrics are located in:    EEG.icaquant.metrics')
                          if (OUTEEG.icaquant.identifiedcomponents ~= 0)
                              if (size(OUTEEG.icaquant.identifiedcomponents,2) > 1)
                                  com = sprintf('Components %s were identified as exhibiting above threshold values and are candidates for removal.\n',mat2str(OUTEEG.icaquant.identifiedcomponents));
                              else
                                  com = sprintf('Component %d was identified as exhibiting above threshold values and is a candidate for removal.\n',OUTEEG.icaquant.identifiedcomponents);
                              end
                          else
                              com = sprintf('No components exhibited above threshold values.\n');
                          end
                          disp(com)
                      else
                          if (structout.EEGSKIP > 1)
                              OUTEEG.icaquant = icablinkmetrics(INEEG,'ArtifactChannel',INEEG.skipchannels.data(structout.EEGSKIP-1,:),'MetricThresholds',[structout.Correlation,structout.Convolution,structout.PercentReduction],'VisualizeData', 'True');
                              com = sprintf('\nEquivalent Code:\n%s.icaquant = icablinkmetrics(%s,''ArtifactChannel'',EEG.skipchannels.data(%d,:),''MetricThresholds'',%s,''VisualizeData'',''True'');\n', inputname(1), inputname(1), (structout.EEGSKIP-1),mat2str([structout.Correlation,structout.Convolution,structout.PercentReduction]));
                              disp(com)
                              disp('ICA Metrics are located in:    EEG.icaquant.metrics')
                              if (OUTEEG.icaquant.identifiedcomponents ~= 0)
                                  if (size(OUTEEG.icaquant.identifiedcomponents,2) > 1)
                                      com = sprintf('Components %s were identified as candidates for removal.\n',mat2str(OUTEEG.icaquant.identifiedcomponents));
                                  else
                                      com = sprintf('Component %d was identified as a candidate for removal.\n',OUTEEG.icaquant.identifiedcomponents);
                                  end
                              else
                                  com = sprintf('No components exhibited statistically significant values.\n');
                              end
                              disp(com)
                          else
                              fprintf('\n\nError in pop_icablinkmetrics(): No Artifact Channel Selected.\n\n')
                              beep
                              com = '';
                          end
                      end
                  else
                      com = '';
                  end
            end
        end
    end
end