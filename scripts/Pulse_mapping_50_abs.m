% % % Modify data before sending to the GUI
% % % exp has fields :   readout :  with fields 'name','unit' and 'data'
% % %                               (data is N-dimensional)
% % %                     sweep : , with fields 'name','unit','data' and 'dim'
% % %                               (data is 1-dimensional for now)
% % %                     data_size
% % %                     filepath
% % %                     filename
% % %                     readout_list
% % %                     sweep_list
% % %                     scan_info : Char array describing exp


%% Parameters
range1 = 10:25;
range2 = 40:51;
% range3 = 73:80;

%% Creating virtual readouts
new_r = [];
new_r = [new_r abs_mean(exp.readout,range1,1,'ADC0_1')];
new_r = [new_r abs_mean(exp.readout,range2,1,'ADC0_2')];
% new_r = [new_r abs_mean(exp.readout,range3,1,'ADC0_3')];
new_r = [new_r abs_mean(exp.readout,range1,2,'ADC1_1')];
new_r = [new_r abs_mean(exp.readout,range2,2,'ADC1_2')];
% new_r = [new_r abs_mean(exp.readout,range3,2,'ADC1_3')];

exp.readout = new_r;
exp.data_size = exp.data_size(2:end);
exp.readout_list = {exp.readout(:).name};

% Removing first dim of sweep
for i=1:length(exp.sweep_list)
    if exp.sweep(i).dim == 1
        obj.sweep(i)=[];
    else
        exp.sweep(i).dim = exp.sweep(i).dim - 1;
    end
end
exp.sweep_list = {exp.sweep(:).name}; 