oldLSD = app.LOADED_SCAN_DATA;
newLSD = Load_Manager();
newLSD.Abort_flag = oldLSD.Abort_flag;
newLSD.Error_flag = oldLSD.Error_flag;
newLSD.Warning_flag = oldLSD.Warning_flag;
newLSD.load_err = oldLSD.load_err;
newLSD.filepath = oldLSD.filepath;
newLSD.filename = oldLSD.filename;
newLSD.fileID = oldLSD.fileID;
newLSD.fileversion = oldLSD.fileversion;
newLSD.data = oldLSD.data;
newLSD.Nsweep = oldLSD.Nsweep;
newLSD.Nstep = oldLSD.Nstep;
newLSD.Nstep2 = oldLSD.Nstep2;
newLSD.Nmeasure = oldLSD.Nmeasure;
% newLSD.sweep_dim = oldLSD.sweep_dim;
% newLSD.step_dim = oldLSD.step_dim;
% newLSD.step2_dim = oldLSD.step2_dim;
% newLSD.measure_dim = oldLSD.measure_dim;
newLSD.DAC_init_values = oldLSD.DAC_init_values;
newLSD.B_field_value = oldLSD.B_field_value;

range1 = 15:25;
range2 = 37:51;
range3 = 64:80;

newLSD.Nsweep = size(oldLSD.data,2);
newLSD.Nstep = size(oldLSD.data,3);
newLSD.Nstep2 = 1;
newLSD.Nmeasure = 6;
data_size = [newLSD.Nsweep,newLSD.Nstep,newLSD.Nstep2,newLSD.Nmeasure];

newLSD.data = zeros(data_size);
newLSD.data(:,:,1,1) = squeeze(mean(oldLSD.data(range2,:,:,1),1)-mean(oldLSD.data(range1,:,:,1),1));
newLSD.data(:,:,1,2) = squeeze(mean(oldLSD.data(range3,:,:,1),1)-mean(oldLSD.data(range1,:,:,1),1));
newLSD.data(:,:,1,3) = squeeze(mean(oldLSD.data(range3,:,:,1),1)-mean(oldLSD.data(range2,:,:,1),1));
newLSD.data(:,:,1,4) = squeeze(mean(oldLSD.data(range2,:,:,2),1)-mean(oldLSD.data(range1,:,:,2),1));
newLSD.data(:,:,1,5) = squeeze(mean(oldLSD.data(range3,:,:,2),1)-mean(oldLSD.data(range1,:,:,2),1));
newLSD.data(:,:,1,6) = squeeze(mean(oldLSD.data(range3,:,:,2),1)-mean(oldLSD.data(range2,:,:,2),1));

newLSD.sweep_dim = scan_dimension();
newLSD.sweep_dim.used_param_number = oldLSD.step_dim.used_param_number;
newLSD.sweep_dim.param_infos = oldLSD.step_dim.param_infos;
newLSD.sweep_dim.param_values = oldLSD.step_dim.param_values;

newLSD.step_dim = scan_dimension();
newLSD.step_dim.used_param_number = oldLSD.step2_dim.used_param_number;
newLSD.step_dim.param_infos = oldLSD.step2_dim.param_infos;
newLSD.step_dim.param_values = oldLSD.step2_dim.param_values;

newLSD.step2_dim = scan_dimension();
newLSD.step2_dim.used_param_number = 1;
newLSD.step2_dim.param_infos={{'counter';'1';num2str(data_size(3));''}}; %name,start value,end value,units
newLSD.step2_dim.param_values = linspace(1,data_size(3),data_size(3));

newLSD.measure_dim = scan_dimension();
newLSD.measure_dim.used_param_number = 6;
for i=1:6
    name = ['diff' num2str(i)];
    newLSD.measure_dim.param_infos{i} = {name;'';'';'nA'};
end

app.LOADED_SCAN_DATA = newLSD;