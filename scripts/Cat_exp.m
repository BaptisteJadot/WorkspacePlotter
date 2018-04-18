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

prefix = 'RT_spin_exp_';
start_index = 359;
stop_index = 363;

if strcmp(exp.filename,[prefix num2str(start_index)])
    cat_exp = exp;
else
    fpath = strrep(exp.filepath,exp.filename,[prefix num2str(start_index)]);
    cat_exp = h5_import(fpath);
end

% cat_dim = length(cat_exp.data_size)+1;
cat_dim = length(cat_exp.data_size);

for i=start_index+1:stop_index
    fpath = strrep(exp.filepath,exp.filename,[prefix num2str(i)]);
    exp_i = h5_import(fpath);
    for j=1:length(cat_exp.readout)
        cat_exp.readout(j).data = cat(cat_dim,cat_exp.readout(j).data,exp_i.readout(j).data);
    end
end
cat_exp.data_size = size(cat_exp.readout(1).data);
exp = cat_exp;