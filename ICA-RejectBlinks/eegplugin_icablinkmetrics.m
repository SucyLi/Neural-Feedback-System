function eegplugin_icablinkmetrics(fig,try_strings,catch_strings)

version = 1.0;
% create menu
toolsmenu1 = findobj(fig, 'tag', 'tools');

uimenu( toolsmenu1, 'label', 'Relocate Referential/Bipolar Channels', 'separator','on','callback', '[EEG LASTCOM]=pop_movechannels(EEG);  [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);');
uimenu( toolsmenu1, 'label', 'Compute icablinkmetrics', 'callback', '[EEG LASTCOM]=pop_icablinkmetrics(EEG); [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);');

