% % % Import batch (h5) files
% % % input :             filepath, if empty a dialog box opens
% % % output has fields : readout :  with fields 'name','unit' and 'data'
% % %                               (data is N-dimensional)
% % %                     sweep : , with fields 'name','unit','data' and 'dim'
% % %                               (data is 1-dimensional for now)
% % %                     data_size
% % %                     filepath
% % %                     filename
% % %                     readout_list
% % %                     sweep_list
% % %                     scan_info : Char array describing exp

function [obj] = h5_import(filepath)
    obj = [];
    if nargin==0 || ~exist(filepath,'file') 
        %% DISPLAY FILE SELECTION WINDOW
        [filename, pathname] = uigetfile({'*.lvm;*.mat;*exp*.h5;','Supported Files (*.lvm,*.mat,*.h5)';'*.lvm','LabView data (*.lvm)';'*.mat','MAT-files (*.mat)';'*.h5','Data from FPGA Batch (*.h5)';'*.*', 'All Files (*.*)'}, 'Please pick the file to load',pwd); %open browse window
        if isa(filename,'double')
            if filename==0 % if user canceled, return
               return
            end
        end
        filepath = [pathname filename];
    end
    exp_bool = h5readatt(filepath,'/configure/Meas_config','fast_mode');
    fast_mode = strcmp(exp_bool{1},'TRUE');
    ramp_mode = strcmp(exp_bool{2},'TRUE');
    readout_list = h5readatt(filepath,'/Param_list','readout_list');
    sweep_list = h5readatt(filepath,'/Param_list','sweep_list');
    
    %% READOUT DATA
    obj.readout = [];
    for i=1:length(readout_list)
        name = readout_list{i};
        dataset = strcat('/data/',name);
        unit = h5readatt(filepath,dataset,'unit');
        new_data = h5read(filepath,dataset);
        ndim = length(size(new_data));
        new_data = permute(new_data,ndim:-1:1);
        if i == 1
            data_size = size(new_data);
        elseif size(new_data) ~= data_size
            warning('Error importing h5 file : Data of different dimensions may not be supported')
        end
        obj.readout(i).name = name;
        obj.readout(i).unit = unit{1};
        obj.readout(i).data = new_data;
    end
   
    
    %% SWEEP PARAM
    obj.sweep = [];
    for i=1:length(sweep_list)
        name = sweep_list{i};
        dataset = strcat('/',name);
        unit = h5readatt(filepath,dataset,'unit');
        dim = h5readatt(filepath,dataset,'dimension');
        val_arr = h5read(filepath,dataset);
        if size(val_arr,2)>1
            ndim = length(size(val_arr));
            val_arr = permute(val_arr,ndim:-1:1);
            val_arr = shiftdim(val_arr,dim-1);  % Bring the varied dimension forward
        end
        val_list = val_arr(:,1);
        
        obj.sweep(i).name = name;
        obj.sweep(i).unit = unit{1};
        obj.sweep(i).data = val_list;
        if fast_mode 
            dim = dim + 1;
        end
        obj.sweep(i).dim = dim;
    end
    
    %% IF RAMP, BUILD THE FASTSWEEP VALUES
    fast_sweep_list = {};
    if fast_mode && ramp_mode
        fast_channels_names = h5readatt(filepath,'/configure/Meas_config','Fast_channel_name_list');
        uint64s = h5readatt(filepath,'/configure/fast_sequence','uint64s');
        start_at = uint64s(end);
        fast_seq = h5read(filepath,'/configure/fast_sequence');
%                 fast_seq = fast_seq(2:end-1,:); % removing trigger and jump
        fast_seq = fast_seq(2+start_at:end-1,:); % removing pre-ramp elements
        if size(fast_seq,1) ~= data_size(1)
            warning('Fast sequence not understood');
            display(strcat('fast sequence size is ',num2str(size(fast_seq,1)),', expected ',num2str(data_size(1))));
        else
            N_param_sweep = length(unique(fast_seq(:,1)));
            fast_channels_ids = uint64s(5:end-1);
            for i=1:N_param_sweep
                id = fast_seq(i,1);
                name = fast_channels_names{fast_channels_ids(id+1)+1};
                sub_arr = fast_seq(fast_seq(:,1)==id,2);
                val_list = linspace(sub_arr(1),sub_arr(end),data_size(1));
                
                index = length(obj.sweep)+1;
                fast_sweep_list = [fast_sweep_list name];
                obj.sweep(index).name = name;
                obj.sweep(index).unit = 'V';
                obj.sweep(index).data = val_list;
                obj.sweep(index).dim = 1;
                
                init_move = h5read(filepath,'/Initial_move');
                for j=1:length(init_move.value)
                    param = strcat(init_move.name(:,j)');
                    if strcmp(param,name)
                        offset = init_move.value(j);
                        val_list = val_list + offset;
                        
                        fast_sweep_list = [fast_sweep_list strcat('\delta ',name)];
                        obj.sweep(index+1).name = ['\delta ' name];
                        obj.sweep(index+1).unit = 'V';
                        obj.sweep(index+1).data = val_list;
                        obj.sweep(index+1).dim = 1;
                        
                    end
                end
            end
        end
    end
    
    %% SCAN INFOS
    obj.filepath = filepath;
    obj.data_size = data_size;
    [~,obj.filename,~] = fileparts(filepath);
    obj.readout_list = readout_list';
    obj.sweep_list = [sweep_list' fast_sweep_list];
    comment = (h5readatt(filepath,'/Param_list','comments'));
    obj.scan_info = comment{1};
end