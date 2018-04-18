function [data_out] = proba_raw(data_in,curves_to_show,method,sweep_window,threshold1,threshold2)
    data_size = size(data_in);
    indexes = randi(prod(data_size(2:end)),curves_to_show,1);
    figure(96);cla();hold on;
    plot(data_in(:,indexes));
    plot([sweep_window(1) sweep_window(1)],get(gca(),'YLim'),'k','LineWidth',2)
    plot([sweep_window(end) sweep_window(end)],get(gca(),'YLim'),'k','LineWidth',2)
    plot(get(gca(),'XLim'),[threshold1 threshold1],'k','LineWidth',2)
    if nargin == 6 && (strcmp(method,'inside') || strcmp(method,'outside'))
        plot(get(gca(),'XLim'),[threshold2 threshold2],'k','LineWidth',2)
    end
    
    switch method
        case 'above'
            event_detected = any(data_in(sweep_window,:)>threshold1,1);
        case 'below'
            event_detected = any(data_in(sweep_window,:)<threshold1,1);
        case 'inside'
            if threshold1 < threshold2
                event_detected = any(data_in(sweep_window,:)>threshold1 & data_in(sweep_window,:)<threshold2,1);
            else
                event_detected = any(data_in(sweep_window,:)<threshold1 & data_in(sweep_window,:)>threshold2,1);
            end
        case 'outside'
            if threshold1 < threshold2
                event_detected = any(data_in(sweep_window,:)>threshold2 | data_in(sweep_window,:)<threshold1,1);
            else
                event_detected = any(data_in(sweep_window,:)>threshold1 | data_in(sweep_window,:)>threshold2,1);
            end
    end
    data_out = reshape(event_detected,data_size(2:end));
end