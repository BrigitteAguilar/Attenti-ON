%----------------------------------------------------------------------
% senal_sin_pestaneo = test_epochextract(data, threshold, epoch_duration, epoch_overlaptime, artifact_process_mode)
%
% sample program to use test_epochextract
% DEVUELVE UNA MATRIZ DE EPOCAS, donde cada epoca es un vector con datos limpios 
%
% This function epoch sample data, and remove/substitude the contaminated
% epochs, after detecting contaminated epochs by using MSDW methods
%
%	    epoch_duration: duration of epoch
%	    epoch_overlaptime: duration of overlapping time for adjusted epochs
%           artifact_process_mode:  0: ignore artifacts (default) 
%                                   1: substitute adjusted epochs for contaminated epochs artifact
%                                   2: remove contaminated epochs (assign null)
%
% Version 2014.7.14
% Codes & Method by Dr. Won-Du Chang
%
%----------------------------------------------------------------------
% All rights are reserved by Won-Du Chang, ph.D, 
% CoNE Lab, Department of Biomedical Engineering, Hanyang University
% 12cross@gmail.com
%---------------------------------------------------------------------
function datolimpio = test_epochextract(data, threshold, epoch_duration, epoch_overlaptime, artifact_process_mode)

samplingrate = 32; % frecuencia de muestreo del txt

% Preprocessing (median filter)
      
   % data = Preprocessing(data);

% EOG Detection
   
    min_window_width = 3;  %3 = 3/32  = about 93.8 ms
    max_window_width = 40;  %7 = 7/32  = about 1250 ms

    [artifact_range, window_acc_v] = eogdetection_accdiff(data, min_window_width, max_window_width, threshold); % window_acc_v´Â distance listÀÎµ¥ reference ¿ëÀ¸·Î returnÇÏµµ·Ï ÇÏ¿´À½
    
% Epoch Extract
    if artifact_process_mode==0  %extract epoch without artifact detection
        [epochs, nSubstituted, bSubstituted] = epochextract(data, samplingrate ,epoch_duration, epoch_overlaptime, artifact_process_mode);
    else  %reject contaminated epoch
        [epochs, nSubstituted, bSubstituted] = epochextract(data, samplingrate ,epoch_duration, epoch_overlaptime, artifact_process_mode, artifact_range);
    end
    
% Concatenamos las épocas para que devuelva un sólo vector limpio
    for i=1:size(epochs,1)
        datolimpio = vertcat(epochs(i));
    end
%printing Information
    nEpochs = size(epochs,1);
    fprintf(' - Total %d epochs were extracted including the last epoch, which may have no enough data in it\n', nEpochs);
    fprintf(' - %d epochs were subtituted/removed by previous ones because of the artifact\n', nSubstituted);
    tmp = 1:nEpochs;
    list = tmp(1,logical(bSubstituted));
    fprintf(' - ID Lists of contaminated epochs are : ');
    fprintf('%d ',list);
    fprintf('\n');

%     for i=2:nEpochs
%  epochs = [epochs(i-1) epochs(i)];
%  
    
 % Display in Graphs
    figure('Name','Signal in Epochs');
    nEpochs = size(epochs,1);
    nPlotRow = 5;
    nPlotColumn = ceil(nEpochs/nPlotRow);
    for i = 1:nEpochs
        subplot(nPlotRow,nPlotColumn,i);

        if isempty(epochs{i})
            plot(0);
        elseif bSubstituted(i) == 1
            plot(epochs{i}(:,1),'Color','r');
        else
            plot(epochs{i}(:,1));
        end
        if(mod(i-1, nPlotColumn)~=0)
            set(gca, 'YTickLabel', []);
        end
        set(gca, 'XTickLabel', []);
        if ~isempty(epochs{i})
            xlim([0,size(epochs{i},1)]);
        end
        ylim([-300,400]);
    end
end

function data = Preprocessing(sourcedata)
     median_width = 5;
     data = medfilt1(data,median_width); 
end

