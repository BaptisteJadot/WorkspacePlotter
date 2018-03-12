function obj = abs_mean(obj,range1,channel,name)
    if obj.seq_rep == 1
        temp_data = zeros(obj.output_size(1),obj.output_size(2),1);
    else
        temp_data = zeros(obj.output_size(1:3));
    end
    for i=1:obj.seq_rep
        r1 = range1 + (i-1)*obj.seq_length;
        temp_data(:,:,i) = squeeze(mean(obj.raw_data(r1,:,:,channel),1));
    end
    obj.output_data = cat(4,obj.output_data,temp_data);
    obj.output_size = size(obj.output_data);
    obj.name_list = [obj.name_list name];
    obj.unit_list = [obj.unit_list obj.input_LSD.measure_dim.param_infos{channel}{4}];
end