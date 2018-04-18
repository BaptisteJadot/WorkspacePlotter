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

curves_to_show = 100;   % show only N random curves
mode = 'above';
threshold1 = 6.1;
threshold2 = -0.1;
sweep_window = 7:50;

[data_out] = proba_raw(exp.readout(1).data,curves_to_show,mode,sweep_window,threshold1,threshold2);

exp.readout = [];
exp.readout(1).name = 'Event count';
exp.readout(1).unit = '';
exp.readout(1).data = data_out;

exp.data_size = size(data_out);
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


% new_order = [3 2 1];
% % Readout 
% for i=1:length(exp.readout_list)
%     exp.readout(i).data = permute(exp.readout(i).data,new_order);
% end
% exp.data_size = exp.data_size(new_order(length(exp.data_size)));
% 
% % Sweep
% for i=1:length(exp.sweep_list)
%     exp.sweep(i).dim = new_order(exp.sweep(i).dim);
% end