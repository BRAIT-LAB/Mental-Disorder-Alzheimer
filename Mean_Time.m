clear ;clc;
path = ['D:\Data_analysis\EEG_data\Work\test'];         
inpath=[path,'\Pre'];
cd(inpath);
AllFile = dir('**/*.*set');
for i=1:length(AllFile)
	file{i,1}=AllFile(i).name;
end
Cond={'1','2'};                                         %实验条件（marker）
site=25;                                                %波形图电极点序号      

%% plot the waveforms for different conditions
inpath=[path,'\Pre'];
mkdir(path,'\Mean');
outpath=[path '\Mean'];
cd(outpath);
for i=1:length(AllFile)
    EEG = pop_loadset('filename',file{i,1},'filepath',inpath);
    EEG = eeg_checkset( EEG );
    for j=1:length(Cond)
        EEG_new = pop_epoch(EEG,Cond(j),[-0.2 0.8]);
        EEG_new = eeg_checkset( EEG_new );
        EEG_new = pop_rmbase( EEG_new, [-200 0] ,[]);
        EEG_new = eeg_checkset( EEG_new );
        EEG_avg(i,j,:,:) = squeeze(mean(EEG_new.data,3)); %data  电极X时间点X试次
    end
end
mean_data = squeeze(mean(EEG_avg(:,:,site,:),1));
times=EEG_new.times;
chanlocs=EEG.chanlocs;
%%  波形图
cd(outpath);
figure;
set(gca,'XAxisLocation','origin');
set(gca,'YAxisLocation','origin');hold on;
plot(EEG_new.times,mean_data(1,:),'b','linewidth',1);
hold on;
plot(EEG_new.times,mean_data(2,:),'r','linewidth',1);
hold on;
legend('条件1','条件2');
%axis([-200 600 -3 3]);
title('Group-level at Cz','fontsize',12);       %电极电名称
xlabel('Latency(ms)','fontsize',12);
ylabel('Amplitude(uV)','fontsize',12);
saveas(gcf, 'waveform', 'png');
save([ 'data.mat'],'EEG_avg','mean_data','times','chanlocs');
