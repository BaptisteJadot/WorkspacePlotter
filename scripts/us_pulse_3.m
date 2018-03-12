seq_start = 1;
seq_length = 80;
obj = Metastable_Mapping(app.LOADED_SCAN_DATA,seq_start,seq_length);
range1 = 15:25;
range2 = 37:51;
range3 = 64:80;

obj.add_diff(range1,range2,1,'ADC0_2 - ADC0_1');
% obj = obj.add_diff(range1,range3,1,'ADC0_3 - ADC0_1');
% obj = obj.add_diff(range2,range3,1,'ADC0_3 - ADC0_2');
% obj = obj.add_diff(range1,range2,2,'ADC1_2 - ADC1_1');
% obj = obj.add_diff(range1,range3,2,'ADC1_3 - ADC1_1');
% obj = obj.add_diff(range2,range3,2,'ADC1_3 - ADC1_2');

obj = obj.export();
app.LOADED_SCAN_DATA = obj.LSD;