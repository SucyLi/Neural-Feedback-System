function visualize_icablinkmetrics(Identifiedcomponents, Window, matrixofVEOGiBlinks, matrixofICAiBlinks, matrixofICAConvolution, meanofEEGiBlinks, matrixofEEGiBlinksafterICAremoval)
%   GUI to show the ICA components
%   Example Code:
%        [EEG.icaquant, matrixofVEOGiBlinks, matrixofICAiBlinks, matrixofEEGiBlinks, matrixofICAConvolution,...
%            matrixofEEGiBlinksafterICAremoval, matrixofEEGConvolutionafterICAremoval] = icablinkmetrics(EEG, ...
%            'ArtifactChannel', EEG.skipchannels.data(3,:), 'Alpha', 0.05, 'Tails', 2);
%        visualize_icablinkmetrics(EEG.icaquant.identifiedcomponents, [-150 150], matrixofVEOGiBlinks, matrixofICAiBlinks, matrixofICAConvolution, matrixofEEGiBlinksafterICAremoval)
    
    matrixofVEOGiBlinks = abs(matrixofVEOGiBlinks); % rectify eyeblinks
    matrixofICAConvolution = matrixofICAConvolution * 0.00001; % Move decimal place
    try, r.Rows; cRows = r.Rows; catch, cRows = 2; end
    try, r.Columns; cColumns = r.Columns; catch, cColumns = 2; end
    try, r.Polarity; Polarity = r.Polarity; catch, Polarity = 'Positive Up';  end
    try, r.Average; Average = r.Average; catch, Average = 'False';  end
    try, r.TrialWidth; TrialWidth = r.TrialWidth; catch, TrialWidth = 2.5; end
    try, r.TrialColor; TrialColor = r.TrialColor; catch, TrialColor = [0 0.6 0]; end
    try, r.AverageColor; AverageColor = r.AverageColor; catch, AverageColor = [.8 .8 .8]; end
    try, r.AverageWidth; AverageWidth = r.AverageWidth; catch, AverageWidth = 1.5; end
    try, r.guiBackgroundColor; guiBackgroundColor = r.guiBackgroundColor; catch, guiBackgroundColor = [0.941,0.941,0.941]; end
    try, r.guiSize; guiSize = r.guiSize; catch, guiSize = [200,200,1000,750]; end
    if ismac
        try, r.guiFontSize; guiFontSize = r.guiFontSize; catch, guiFontSize = 11; end
    else
        try, r.guiFontSize; guiFontSize = r.guiFontSize; catch, guiFontSize = 9; end
    end
          
    handles=struct;    %'Structure which stores all object handles
    handles.lin.width1 = TrialWidth;
    handles.lin.width2 = AverageWidth;
    handles.lin.color1 = TrialColor; % Trial
    handles.lin.color2 = AverageColor; % Average
    handles.pl.color = guiBackgroundColor;
    handles.pl.size = guiSize;
    handles.size.xpadding = 30;
    handles.size.xceilpadding = 5;
    handles.size.ypadding = 30;
    handles.size.yceilpadding = 5;
    handles.size.xshift = 50;
    handles.size.yshift = 35;
    handles.size.label = 'Position'; %'OuterPosition'
    handles.size.xchannel = 400;
    handles.size.ychannel = 22;
    handles.size.fSz = guiFontSize;
    
    % Calculate Plot Characteristics
    handles.size.xsize = floor((handles.pl.size(3)-(handles.size.xpadding*(cColumns-1))-handles.size.xshift)/cColumns)-handles.size.xceilpadding;
    handles.size.ysize = floor((handles.pl.size(4)-(handles.size.ypadding*(cRows-1))-handles.size.yshift)/cRows)-handles.size.yceilpadding;
    handles.size.xsizeScaled = handles.size.xsize / handles.pl.size(3);
    handles.size.ysizeScaled = handles.size.ysize / handles.pl.size(4);
    handles.size.xpaddingScaled = handles.size.xpadding / handles.pl.size(3);
    handles.size.ypaddingScaled = handles.size.ypadding / handles.pl.size(4);
    handles.size.xshiftScaled = handles.size.xshift/handles.pl.size(3);
    handles.size.yshiftScaled = handles.size.yshift/handles.pl.size(4);
    handles.size.xchannelScaled = handles.size.xchannel/handles.pl.size(3);
    handles.size.ychannelScaled = handles.size.ychannel/handles.pl.size(4);
    
    % Create GUI window
    handles.fig1 = figure('Name','Visualize icablinkmetrics','NumberTitle','off', 'Position',handles.pl.size, 'Color', handles.pl.color, 'MenuBar', 'none', 'KeyPressFcn', @keyPress);
    set(datacursormode(handles.fig1),'UpdateFcn',@myupdatefcn);
    datacursormode on
    %set(handles.fig1,'renderer','opengl')
    % Populate Labels
    celCount = 0;
    rspace = handles.size.yshiftScaled + (handles.size.ysizeScaled*(cRows-1)) + (handles.size.ypaddingScaled*(cRows-1))+(0.83*(handles.size.ysizeScaled + handles.size.ypaddingScaled));
    for cR = 1:cRows
        %cspace = (handles.size.xshiftScaled*.7) + (1/handles.pl.size(3));
        cspace = handles.size.xpaddingScaled;
        for cC = 1:cColumns
            if (cR == 1) && (cC == 1)
                handles.(sprintf('r%dc%d',cR,cC)).tN = uicontrol('Style', 'text', 'String', sprintf('Artifact trials and mean artifact from the artifact channel.'), 'Units','normalized', 'Position', [cspace,rspace,handles.size.xchannelScaled,handles.size.ychannelScaled], 'FontSize', handles.size.fSz);
            end
            if (cR == 1) && (cC == 2)
                handles.(sprintf('r%dc%d',cR,cC)).tN = uicontrol('Style', 'text', 'String', sprintf('Average of each component surrounding the artifact.'), 'Units','normalized', 'Position', [cspace,rspace,handles.size.xchannelScaled,handles.size.ychannelScaled], 'FontSize', handles.size.fSz);
            end
            if (cR == 2) && (cC == 1)
                handles.(sprintf('r%dc%d',cR,cC)).tN = uicontrol('Style', 'text', 'String', sprintf('Convolution between each component and the artifact.'), 'Units','normalized', 'Position', [cspace,rspace,handles.size.xchannelScaled,handles.size.ychannelScaled], 'FontSize', handles.size.fSz);
            end
            if (cR == 2) && (cC == 2)
                handles.(sprintf('r%dc%d',cR,cC)).tN = uicontrol('Style', 'text', 'String', sprintf('Artifact in EEG after each component is removed.'), 'Units','normalized', 'Position', [cspace,rspace,handles.size.xchannelScaled,handles.size.ychannelScaled], 'FontSize', handles.size.fSz);
            end
            celCount = celCount + 1;
            cspace = cspace + handles.size.xsizeScaled + handles.size.xpaddingScaled;
        end
        rspace = rspace - (handles.size.ysizeScaled + handles.size.ypaddingScaled);
    end
    
    % Populate Grid
    celCount = 0;
    axeslist = [];
    rspace = handles.size.yshiftScaled + (handles.size.ysizeScaled*(cRows-1)) + (handles.size.ypaddingScaled*(cRows-1));
    for cR = 1:cRows
        cspace = handles.size.xshiftScaled;
        for cC = 1:cColumns
            
            handles.(sprintf('r%dc%d',cR,cC)).axes = axes(handles.size.label,[cspace,rspace,handles.size.xsizeScaled*0.94,handles.size.ysizeScaled*0.88],'FontSize', handles.size.fSz);
            if (cC == 1) && (cR == 1)
                handles.(sprintf('r%dc%d',cR,cC)).x = Window(1):((size(matrixofVEOGiBlinks,2)-1)/(Window(2)-Window(1))):Window(2);
                handles.(sprintf('r%dc%d',cR,cC)).x = handles.(sprintf('r%dc%d',cR,cC)).x(1,10:end-10);
                temp = mean(matrixofVEOGiBlinks);
                for lC = 1:size(matrixofVEOGiBlinks,1)
                    handles.(sprintf('r%dc%dl%d',cR,cC,lC)).line = line(handles.(sprintf('r%dc%d',cR,cC)).x,matrixofVEOGiBlinks(lC,10:end-10),'LineWidth',handles.lin.width2, 'Color',[.8 .8 .8], 'Tag', sprintf('Blink Number: %d',lC));
                    uistack(handles.(sprintf('r%dc%dl%d',cR,cC,lC)).line, 'down', 1);
                end
                handles.(sprintf('r%dc%dlblink',cR,cC)).line = line(handles.(sprintf('r%dc%d',cR,cC)).x, temp(:,10:end-10),'LineWidth',handles.lin.width1, 'Color',handles.lin.color1, 'Tag', sprintf('Mean Eye Blink'));
                ylabel(handles.(sprintf('r%dc%d',cR,cC)).axes,'Amplitude');
            end
            if (cC == 2) && (cR == 1)
                handles.(sprintf('r%dc%d',cR,cC)).x = Window(1):((size(matrixofICAiBlinks,2)-1)/(Window(2)-Window(1))):Window(2);
                handles.(sprintf('r%dc%d',cR,cC)).x = handles.(sprintf('r%dc%d',cR,cC)).x(1,10:end-10);
                for lC = 1:size(matrixofICAiBlinks,1)
                    tempcolor = rand(1); while (tempcolor<0.98) && (tempcolor>0.5), tempcolor = rand(1); end
                    if (intersect(lC, Identifiedcomponents))
                        handles.(sprintf('r%dc%dl%d',cR,cC,lC)).line = line(handles.(sprintf('r%dc%d',cR,cC)).x,matrixofICAiBlinks(lC,10:end-10), 'LineWidth',handles.lin.width2, 'Color', handles.lin.color1, 'Tag', sprintf('Component Number: %d',lC));
                    else
                        handles.(sprintf('r%dc%dl%d',cR,cC,lC)).line = line(handles.(sprintf('r%dc%d',cR,cC)).x,matrixofICAiBlinks(lC,10:end-10), 'LineWidth',handles.lin.width2, 'Color', [tempcolor, tempcolor, tempcolor], 'Tag', sprintf('Component Number: %d',lC));
                    end
                    uistack(handles.(sprintf('r%dc%dl%d',cR,cC,lC)).line, 'down', 1);
                end 
                ylabel(handles.(sprintf('r%dc%d',cR,cC)).axes,'Amplitude (arbitrary units)');
            end
            if (cC == 1) && (cR == 2)
                tempWindow = Window * 2;
                %handles.(sprintf('r%dc%d',cR,cC)).x = Window(1):((size(matrixofICAConvolution,2)-1)/(Window(2)-Window(1)))/4:Window(2);
                handles.(sprintf('r%dc%d',cR,cC)).x = tempWindow(1):((size(matrixofICAConvolution,2)-1)/(tempWindow(2)-tempWindow(1))):tempWindow(2);
                handles.(sprintf('r%dc%d',cR,cC)).x = handles.(sprintf('r%dc%d',cR,cC)).x(1,10:end-10);
                for lC = 1:size(matrixofICAConvolution,1)
                    tempcolor = rand(1); while (tempcolor<0.98) && (tempcolor>0.5), tempcolor = rand(1); end
                    if (intersect(lC, Identifiedcomponents))
                        handles.(sprintf('r%dc%dl%d',cR,cC,lC)).line = line(handles.(sprintf('r%dc%d',cR,cC)).x,matrixofICAConvolution(lC,10:end-10), 'LineWidth',handles.lin.width2, 'Color', handles.lin.color1, 'Tag', sprintf('Component Number: %d',lC));
                    else
                        handles.(sprintf('r%dc%dl%d',cR,cC,lC)).line = line(handles.(sprintf('r%dc%d',cR,cC)).x,matrixofICAConvolution(lC,10:end-10), 'LineWidth',handles.lin.width2, 'Color', [tempcolor, tempcolor, tempcolor], 'Tag', sprintf('Component Number: %d',lC));
                    end
                    uistack(handles.(sprintf('r%dc%dl%d',cR,cC,lC)).line, 'down', 1);
                end 
                ylabel(handles.(sprintf('r%dc%d',cR,cC)).axes,'Amplitude (arbitrary units)');
            end
            if (cC == 2) && (cR == 2)
                handles.(sprintf('r%dc%d',cR,cC)).x = Window(1):((size(matrixofEEGiBlinksafterICAremoval,2)-1)/(Window(2)-Window(1))):Window(2);
                handles.(sprintf('r%dc%d',cR,cC)).x = handles.(sprintf('r%dc%d',cR,cC)).x(1,10:end-10);
                for lC = 1:size(matrixofEEGiBlinksafterICAremoval,1)
                    tempcolor = rand(1); while (tempcolor<0.98) && (tempcolor>0.5), tempcolor = rand(1); end
                    if (intersect(lC, Identifiedcomponents))
                        handles.(sprintf('r%dc%dl%d',cR,cC,lC)).line = line(handles.(sprintf('r%dc%d',cR,cC)).x,matrixofEEGiBlinksafterICAremoval(lC,10:end-10), 'LineWidth',handles.lin.width2, 'Color', handles.lin.color1, 'Tag', sprintf('Component Number: %d',lC));
                    else
                        handles.(sprintf('r%dc%dl%d',cR,cC,lC)).line = line(handles.(sprintf('r%dc%d',cR,cC)).x,matrixofEEGiBlinksafterICAremoval(lC,10:end-10), 'LineWidth',handles.lin.width2, 'Color', [tempcolor, tempcolor, tempcolor], 'Tag', sprintf('Component Number: %d',lC));
                    end
                    uistack(handles.(sprintf('r%dc%dl%d',cR,cC,lC)).line, 'down', 1);
                end 
                if (sum(isnan(matrixofEEGiBlinksafterICAremoval(:,1))) ~= 0)
                    handles.(sprintf('r%dc%dartifact',cR,cC)).line = line(handles.(sprintf('r%dc%d',cR,cC)).x,meanofEEGiBlinks(1,10:end-10), 'LineWidth',handles.lin.width2, 'Color', [0, 0, 0], 'Tag', 'Original Artifact');
                end
                ylabel(handles.(sprintf('r%dc%d',cR,cC)).axes,'Amplitude');
            end
            box('off'); axis tight;
            set(handles.(sprintf('r%dc%d',cR,cC)).axes,'Color','None'); 
            axeslist(end+1) = handles.(sprintf('r%dc%d',cR,cC)).axes;
            if (strcmpi(Polarity, 'Positive Down') == 1)
                set(handles.(sprintf('r%dc%d',cR,cC)).axes,'YDir','reverse');    
            end
            set(handles.(sprintf('r%dc%d',cR,cC)).axes, 'FontSize', handles.size.fSz*0.7);
            xlabel(handles.(sprintf('r%dc%d',cR,cC)).axes,'Time (ms)');  
            
            % Adjust Bounding
            currentlimits = ylim;
            if (cC == 1) && (cR == 2) % Lower Left
                if (currentlimits(1) > 0)
                   currentlimits(1) = -5; 
                end
                if (currentlimits(2) < 15)
                   currentlimits(2) = 15; 
                end     
            elseif (cC == 2) && (cR == 1) % Upper Right
                if (abs(currentlimits(2)) > abs(currentlimits(1))) % Regular case
                    if (currentlimits(1) > -10)
                       currentlimits(1) = -10; 
                    end
                    if (currentlimits(2) < 50)
                       currentlimits(2) = 50; 
                    end 
                else % Could be the polarity is flipped
                    if (currentlimits(2) < 10)
                       currentlimits(2) = 10; 
                    end
                    if (currentlimits(1) > -50)
                       currentlimits(1) = -50; 
                    end 
                end
            elseif (cC == 2) && (cR == 2) % Lower Right
                if (currentlimits(1) > -5)
                   currentlimits(1) = -5; 
                end
                if (currentlimits(2) < 50)
                   currentlimits(2) = 50; 
                end         
            end
            set(handles.(sprintf('r%dc%d',cR,cC)).axes, 'YLim', currentlimits);
            celCount = celCount + 1;
            cspace = cspace + handles.size.xsizeScaled + handles.size.xpaddingScaled;
        end
        rspace = rspace - (handles.size.ysizeScaled + handles.size.ypaddingScaled);
    end
    
    dcm_obj = datacursormode(handles.fig1);
    %set(dcm_obj,'UpdateFcn',@myupdatefcn)
    function txt = myupdatefcn(empt,event_obj)
        % Customizes text of data tips
        component = '';
        info_struct = getCursorInfo(dcm_obj); bolfound = 0;
        %disp(info_struct);
        try
            component = dcm_obj.Target.get.Tag; % just extract the information from the Tag field
        catch 
            bolfound = 0;
        end
        try
            if isempty(component)
                % see if you can match the position information
                component = 'No Component Information Available';
                if (bolfound == 0)
                    tempmat = matrixofVEOGiBlinks(:,10:end-10);
                    try, tempvect = find(tempmat(:,info_struct.DataIndex)==info_struct.Position(2)); component = sprintf('Blink Number: %d', tempvect(1)); bolfound = 1; catch, bolfound = 0; end;
                end
                if (bolfound == 0)
                    tempmat = matrixofICAConvolution(:,10:end-10);
                    try, tempvect = find(tempmat(:,info_struct.DataIndex)==info_struct.Position(2)); component = sprintf('Component Number: %d', tempvect(1)); bolfound = 1;catch, bolfound = 0; end;
                end
                if (bolfound == 0)
                    tempmat = matrixofICAiBlinks(:,10:end-10);
                    try, tempvect = find(tempmat(:,info_struct.DataIndex)==info_struct.Position(2)); component = sprintf('Component Number: %d', tempvect(1)); bolfound = 1;catch, bolfound = 0; end;
                end
                if (bolfound == 0)
                    tempmat = matrixofEEGiBlinksafterICAremoval(:,10:end-10);
                    try, tempvect = find(tempmat(:,info_struct.DataIndex)==info_struct.Position(2)); component = sprintf('Component Number: %d', tempvect(1)); bolfound = 1;catch, bolfound = 0; end;
                end
                if (bolfound == 0)
                    try, tempmat = meanofEEGiBlinks(1,10:end-10); tempvect = find(tempmat(1,info_struct.DataIndex)==info_struct.Position(2)); component = sprintf('Original Artifact'); bolfound = 1;catch, bolfound = 0; end;
                end
            end
        catch
            bolfound = 0;
        end
        
        if ~isempty(component)
            txt = {sprintf('%s', component)};
        else
            txt = {sprintf('')};
        end
        
    end
end
    