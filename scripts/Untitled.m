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

t = (0:exp.data_size(1)-1)*0.2;
data = exp.readout(2).data;
X_to_plot = 1:4:exp.data_size(2);
Y_to_plot = 1:1:exp.data_size(3);
avg_to_plot = 1:10:exp.data_size(4);
Spin_2Dmap_plot_raw_data(t,data,X_to_plot,Y_to_plot,avg_to_plot,'');

deriv = Spin_2Dmap_derivate(data);
threshold_unload = 0.15;
sweep_window_unload = 4:100;
threshold_load = -0.15;
sweep_window_load = 4:100;
Spin_2Dmap_plot_deriv(t,deriv,X_to_plot,Y_to_plot,avg_to_plot,'',threshold_unload,sweep_window_unload,threshold_load,sweep_window_load)

exp.data_size = exp.data_size(2:3);
load_rising_edge = True;
[N_loading_events,N_unloading_events] = Spin_2Dmap_count_events(deriv,threshold_unload,sweep_window_unload,threshold_load,sweep_window_load,load_rising_edge);
