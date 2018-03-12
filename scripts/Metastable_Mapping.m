% classdef Metastable_Mapping
%     %   METASTABLE_MAPPING Class to perform a pre-analysis on imported data
%     %   input : t, X, Y, ADCi
%     %   ouput : X, Y, counter, ADCi[range2,:,:,i]-ADCi[range1,:,:,i]
%     %   if sequence is repeated, data is cut and put in step2
%     
%     properties
%         seq_start
%         seq_length
%         seq_nb
%         input_LSD
%         raw_data
%         output_data
%         output_size
%         name_list
%         unit_list
%         LSD
%     end
%     
%     methods
%         function [obj] = Metastable_Mapping(input_LSD,seq_start,seq_length)
%             obj.input_LSD = input_LSD;
%             obj.raw_data = input_LSD.data;
%             obj.seq_start = seq_start;
%             obj.seq_length = seq_length;
%             obj.seq_nb = length(obj.seq_start:obj.seq_length:size(obj.raw_data,1));
%             obj.output_size = [size(obj.raw_data,2) size(obj.raw_data,3) obj.seq_nb 0];
%             obj.output_data = zeros(obj.output_size);
%             obj.name_list = {};
%             obj.unit_list = {};
%         end
%         
%         function add_diff(obj,range1,range2,channel,name)
%             temp_data = zeros(obj.output_size(1:3));
%             for i=1:obj.seq_nb
%                 r1 = range1 + (i-1)*obj.seq_length;
%                 r2 = range2 + (i-1)*obj.seq_length;
%                 display(size(mean(obj.raw_data(r1,:,:,channel),1)))
%                 display(size(mean(obj.raw_data(r2,:,:,channel),1)))
%                 temp_data(:,:,i) = squeeze(mean(obj.raw_data(r2,:,:,channel),1)...
%                                         - mean(obj.raw_data(r1,:,:,channel),1));
%             end
%             obj.output_data = cat(4,obj.output_data,temp_data);
%             obj.output_size = size(obj.output_data);
%             obj.name_list = [obj.name_list name];
%             obj.unit_list = [obj.unit_list obj.input_LSD.measure_dim.param_infos{channel}{4}];
%         end
%         
%         function [obj] = add_mean(obj,range,channel,name)
%             temp_data = zeros(obj.output_size(1:3));
%             for i=1:obj.seq_nb
%                 r1 = range + (i-1)*obj.seq_length;
%                 temp_data(:,:,i) = squeeze(mean(obj.raw_data(r1,:,:,channel),1));
%             end
%             obj.output_data = cat(4,obj.output_data,temp_data);
%             obj.output_size = size(obj.output_data);
%             obj.name_list = [obj.name_list name];
%             obj.unit_list = [obj.unit_list obj.input_LSD.measure_dim.param_infos{channel,4}];
%         end
%             
%         function [obj] = export(obj)
%             obj.LSD = Load_Manager();
%             obj.LSD.Abort_flag = obj.input_LSD.Abort_flag;
%             obj.LSD.Error_flag = obj.input_LSD.Error_flag;
%             obj.LSD.Warning_flag = obj.input_LSD.Warning_flag;
%             obj.LSD.load_err = obj.input_LSD.load_err;
%             obj.LSD.filepath = obj.input_LSD.filepath;
%             obj.LSD.filename = obj.input_LSD.filename;
%             obj.LSD.fileID = obj.input_LSD.fileID;
%             obj.LSD.fileversion = obj.input_LSD.fileversion;
%             obj.LSD.DAC_init_values = obj.input_LSD.DAC_init_values;
%             obj.LSD.B_field_value = obj.input_LSD.B_field_value;
% 
%             obj.LSD.data = obj.output_data;
%             obj.LSD.Nsweep = obj.output_size(1);
%             obj.LSD.Nstep = obj.output_size(2);
%             obj.LSD.Nstep2 = obj.output_size(3);
%             obj.LSD.Nmeasure = obj.output_size(4);
% 
%             obj.LSD.sweep_dim = scan_dimension();
%             obj.LSD.sweep_dim.used_param_number = obj.input_LSD.step_dim.used_param_number;
%             obj.LSD.sweep_dim.param_infos = obj.input_LSD.step_dim.param_infos;
%             obj.LSD.sweep_dim.param_values = obj.input_LSD.step_dim.param_values;
% 
%             obj.LSD.step_dim = scan_dimension();
%             obj.LSD.step_dim.used_param_number = obj.input_LSD.step2_dim.used_param_number;
%             obj.LSD.step_dim.param_infos = obj.input_LSD.step2_dim.param_infos;
%             obj.LSD.step_dim.param_values = obj.input_LSD.step2_dim.param_values;
% 
%             obj.LSD.step2_dim = scan_dimension();
%             obj.LSD.step2_dim.used_param_number = 1;
%             obj.LSD.step2_dim.param_infos={{'counter';'1';obj.LSD.Nstep2;''}}; %name,start value,end value,units
%             obj.LSD.step2_dim.param_values = linspace(1,obj.LSD.Nstep2,obj.LSD.Nstep2);
% 
%             obj.LSD.measure_dim = scan_dimension();
%             obj.LSD.measure_dim.used_param_number = obj.LSD.Nmeasure;
%             for i=1:obj.LSD.Nmeasure
%                 obj.LSD.measure_dim.param_infos{i} = {obj.name_list{i};'';'';obj.unit_list{i}};
%             end
%         end
%     end
% end

function obj = add_diff(obj,range1,range2,channel,name)
    temp_data = zeros(obj.output_size(1:3));
    for i=1:obj.seq_rep
        r1 = range1 + (i-1)*obj.seq_length;
        r2 = range2 + (i-1)*obj.seq_length;
        temp_data(:,:,i) = squeeze(mean(obj.raw_data(r2,:,:,channel),1)...
                                - mean(obj.raw_data(r1,:,:,channel),1));
    end
    obj.output_data = cat(4,obj.output_data,temp_data);
    obj.output_size = size(obj.output_data);
    obj.name_list = [obj.name_list name];
    obj.unit_list = [obj.unit_list obj.input_LSD.measure_dim.param_infos{channel}{4}];
end

% function [obj] = export_LSD(obj)
%     obj.LSD = Load_Manager();
%     obj.LSD.Abort_flag = obj.input_LSD.Abort_flag;
%     obj.LSD.Error_flag = obj.input_LSD.Error_flag;
%     obj.LSD.Warning_flag = obj.input_LSD.Warning_flag;
%     obj.LSD.load_err = obj.input_LSD.load_err;
%     obj.LSD.filepath = obj.input_LSD.filepath;
%     obj.LSD.filename = obj.input_LSD.filename;
%     obj.LSD.fileID = obj.input_LSD.fileID;
%     obj.LSD.fileversion = obj.input_LSD.fileversion;
%     obj.LSD.DAC_init_values = obj.input_LSD.DAC_init_values;
%     obj.LSD.B_field_value = obj.input_LSD.B_field_value;
% 
%     obj.LSD.data = obj.output_data;
%     obj.LSD.Nsweep = obj.output_size(1);
%     obj.LSD.Nstep = obj.output_size(2);
%     obj.LSD.Nstep2 = obj.output_size(3);
%     obj.LSD.Nmeasure = obj.output_size(4);
% 
%     obj.LSD.sweep_dim = scan_dimension();
%     obj.LSD.sweep_dim.used_param_number = obj.input_LSD.step_dim.used_param_number;
%     obj.LSD.sweep_dim.param_infos = obj.input_LSD.step_dim.param_infos;
%     obj.LSD.sweep_dim.param_values = obj.input_LSD.step_dim.param_values;
% 
%     obj.LSD.step_dim = scan_dimension();
%     obj.LSD.step_dim.used_param_number = obj.input_LSD.step2_dim.used_param_number;
%     obj.LSD.step_dim.param_infos = obj.input_LSD.step2_dim.param_infos;
%     obj.LSD.step_dim.param_values = obj.input_LSD.step2_dim.param_values;
% 
%     obj.LSD.step2_dim = scan_dimension();
%     obj.LSD.step2_dim.used_param_number = 1;
%     obj.LSD.step2_dim.param_infos={{'counter';'1';obj.LSD.Nstep2;''}}; %name,start value,end value,units
%     obj.LSD.step2_dim.param_values = linspace(1,obj.LSD.Nstep2,obj.LSD.Nstep2);
% 
%     obj.LSD.measure_dim = scan_dimension();
%     obj.LSD.measure_dim.used_param_number = obj.LSD.Nmeasure;
%     for i=1:obj.LSD.Nmeasure
%         obj.LSD.measure_dim.param_infos{i} = {obj.name_list{i};'';'';obj.unit_list{i}};
%     end
% end
%         
% function seq_rep = calc_seq_rep(obj)
%     seq_rep = length(obj.seq_start:obj.seq_length:size(obj.raw_data,1));
% end