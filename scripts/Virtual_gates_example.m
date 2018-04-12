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

i1 = find(strcmp(exp.sweep_list,'Gate1'));
i2 = find(strcmp(exp.sweep_list,'Gate2'));

new_sweep.name = 'Gate1+Gate2';
new_sweep.unit = 'V';
new_sweep.data = exp.sweep(i1).data + exp.sweep(i2).data;
exp.sweep = [exp.sweep new_sweep];
exp.sweep_list = [exp.sweep_list new_sweep.name];

new_sweep.name = 'Gate1-Gate2';
new_sweep.unit = 'V';
new_sweep.data = exp.sweep(i1).data - exp.sweep(i2).data;
exp.sweep = [exp.sweep new_sweep];
exp.sweep_list = [exp.sweep_list new_sweep.name];