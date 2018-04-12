function obj = abs_mean(readout,range,channel,name)
    obj.name = name;
    obj.unit = readout(channel).unit;
    data_size = size(readout(channel).data);
    obj.data = mean(readout(channel).data(range,:),1);
    obj.data = reshape(obj.data,data_size(2:end));
end