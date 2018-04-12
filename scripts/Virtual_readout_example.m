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

i1 = find(strcmp(exp.readout_list,'ADC0'));
i2 = find(strcmp(exp.readout_list,'ADC1'));

new_readout.name = 'ADC0+ADC1';
new_readout.unit = 'nA';
new_readout.data = exp.readout(i1).data + exp.readout(i2).data;
exp.readout = [exp.readout new_readout];
exp.readout_list = [exp.readout_list new_readout.name];

new_readout.name = 'ADC0-ADC1';
new_readout.unit = 'nA';
new_readout.data = exp.readout(i1).data - exp.readout(i2).data;
exp.readout = [exp.readout new_readout];
exp.readout_list = [exp.readout_list new_readout.name];