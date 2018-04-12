function obj = diff_mean(readout,range1,range2,channel,name)
    obj.name = name;
    obj.unit = readout(channel).unit;
    data_size = size(readout(channel).data);
    obj.data = mean(readout(channel).data(range2,:),1)...
                        -mean(readout(channel).data(range1,:),1);
    obj.data = reshape(obj.data,data_size(2:end));
end