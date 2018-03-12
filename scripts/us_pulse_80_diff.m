%% IMPORT DATA
obj=[];
obj.input_LSD = app.LOADED_SCAN_DATA;
obj.raw_data = obj.input_LSD.data;
obj.seq_start = 1;
obj.seq_length = 80;
obj.seq_rep = length(obj.seq_start:obj.seq_length:size(obj.raw_data,1));
obj.name_list = {};
obj.unit_list = {};
obj.output_size = [size(obj.raw_data,2) size(obj.raw_data,3) obj.seq_rep 0];
obj.output_data = zeros(obj.output_size);

%% CALCULATE
range1 = 15:25;
range2 = 37:51;
range3 = 64:80;
obj = diff_mean(obj,range1,range2,1,'ADC0_2 - ADC0_1');
obj = diff_mean(obj,range1,range3,1,'ADC0_3 - ADC0_1');
obj = diff_mean(obj,range2,range3,1,'ADC0_3 - ADC0_2');
obj = diff_mean(obj,range1,range2,2,'ADC1_2 - ADC1_1');
obj = diff_mean(obj,range1,range3,2,'ADC1_3 - ADC1_1');
obj = diff_mean(obj,range2,range3,2,'ADC1_3 - ADC1_2');

%% EXPORT
obj.LSD = Load_Manager();
obj.LSD.Abort_flag = obj.input_LSD.Abort_flag;
obj.LSD.Error_flag = obj.input_LSD.Error_flag;
obj.LSD.Warning_flag = obj.input_LSD.Warning_flag;
obj.LSD.load_err = obj.input_LSD.load_err;
obj.LSD.filepath = obj.input_LSD.filepath;
obj.LSD.filename = obj.input_LSD.filename;
obj.LSD.fileID = obj.input_LSD.fileID;
obj.LSD.fileversion = obj.input_LSD.fileversion;
obj.LSD.DAC_init_values = obj.input_LSD.DAC_init_values;
obj.LSD.B_field_value = obj.input_LSD.B_field_value;

obj.LSD.data = obj.output_data;
obj.LSD.Nsweep = obj.output_size(1);
obj.LSD.Nstep = obj.output_size(2);
obj.LSD.Nstep2 = obj.output_size(3);
obj.LSD.Nmeasure = obj.output_size(4);

obj.LSD.sweep_dim = scan_dimension();
obj.LSD.sweep_dim.used_param_number = obj.input_LSD.step_dim.used_param_number;
obj.LSD.sweep_dim.param_infos = obj.input_LSD.step_dim.param_infos;
obj.LSD.sweep_dim.param_values = obj.input_LSD.step_dim.param_values;

obj.LSD.step_dim = scan_dimension();
obj.LSD.step_dim.used_param_number = obj.input_LSD.step2_dim.used_param_number;
obj.LSD.step_dim.param_infos = obj.input_LSD.step2_dim.param_infos;
obj.LSD.step_dim.param_values = obj.input_LSD.step2_dim.param_values;

obj.LSD.step2_dim = scan_dimension();
obj.LSD.step2_dim.used_param_number = 1;
obj.LSD.step2_dim.param_infos={{'counter';'1';obj.LSD.Nstep2;''}}; %name,start value,end value,units
obj.LSD.step2_dim.param_values = linspace(1,obj.LSD.Nstep2,obj.LSD.Nstep2);

obj.LSD.measure_dim = scan_dimension();
obj.LSD.measure_dim.used_param_number = obj.LSD.Nmeasure;
for i=1:obj.LSD.Nmeasure
    obj.LSD.measure_dim.param_infos{i} = {obj.name_list{i};'';'';obj.unit_list{i}};
end
app.LOADED_SCAN_DATA = obj.LSD;