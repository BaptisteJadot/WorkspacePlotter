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

smooth_order = 3;

for i=1:length(exp.readout_list)
    exp.readout(i).data = smooth(exp.readout(i).data(:,:),smooth_order);
    exp.readout(i).data = reshape(exp.readout(i).data,exp.data_size);
end
