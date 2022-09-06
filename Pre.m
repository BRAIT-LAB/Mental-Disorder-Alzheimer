clear ;clc;
path = ['F:\sleepdata\set'];           %改成你的路径，路径下放有需要分析的所有.set文件
cd(path);
AllFile = dir('**/*.*set');
for i=1:length(AllFile)
	file{i,1}=AllFile(i).name;
end          
%%
mkdir(path,'\Pre');
outpath=[path '\Pre'];
for n = 1:length(AllFile)  
EEG = pop_loadset('filename',file{n,1},'filepath',path);
EEG = eeg_checkset( EEG );
EEG = pop_chanedit(EEG, 'lookup','D:\\Matlab\\toolbox\\eeglab_current\\plugins\\dipfit\\standard_BESA\\standard-10-5-cap385.elp');%模板路径改成自己电脑EEGlab里的
EEG = eeg_checkset( EEG );
EEG = pop_reref( EEG, []);
EEG = eeg_checkset( EEG );
EEG = pop_eegfiltnew(EEG, 'locutoff',0.1,'hicutoff',30,'plotfreqz',1);
EEG = eeg_checkset( EEG );
EEG = pop_epoch( EEG, {  '1'  '2'  }, [-1  2], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-1000 0] ,[]);
EEG = eeg_checkset( EEG );
EEG = pop_select( EEG, 'nochannel',{'CB2','VEO','HEO','EKG','R-Dia-X-(mm)','R-Dia-Y-(mm)'});
EEG = eeg_checkset( EEG );

setname=strcat(num2str(n),'.set');
EEG = pop_saveset( EEG, 'filename',setname,'filepath',outpath);
EEG = eeg_checkset( EEG );


end