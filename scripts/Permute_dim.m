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

new_order = [1 3 2];

% Readout 
for i=1:length(exp.readout_list)
    exp.readout(i).data = permute(exp.readout(i).data,new_order);
end
exp.data_size = exp.data_size(new_order(length(exp.data_size)));

% Sweep
for i=1:length(exp.sweep_list)
    exp.sweep(i).dim = new_order(exp.sweep(i).dim);
end