
% %% INCREASING EXP
% fh = @(x,p) p(1)*(1-exp(-x./p(3)))+p(2);
% errfh = @(p,x,y) sum((y(:)-fh(x(:),p)).^2);
% 
% 
% fig = figure(1);
% obj = fig.Children.Children;
% x = obj.XData;
% y = obj.YData;
% err = obj.LData;
% 
% 
% p0 = [0.6 0.3 1.];
% P = fminsearch(errfh,p0,[],x,y);
% copyfig(fig);
% hold on
% plot(x,fh(x(:),P),'k','LineWidth',2);
% str = sprintf('P=A_1(1-exp(-t/T))+A_0\nA_0 = %.2f \nA_1 = %.2f \nT = %.2f ms',P(2),P(1),P(3));
% annotation('textbox',[0.5,0.5,0.1,0.1],'String',str,'FontSize',16,'FitBoxToText','on');

%% DECREASING EXP
fh = @(x,p) p(1)*exp(-x./p(3))+p(2);
errfh = @(p,x,y) sum((y(:)-fh(x(:),p)).^2);


fig = figure(5);
obj = fig.Children.Children;
x = obj.XData;
y = obj.YData;
err = obj.LData;


p0 = [0.6 0.3 1.];
P = fminsearch(errfh,p0,[],x,y);
copyfig(fig);
hold on
plot(x,fh(x(:),P),'k','LineWidth',2);
str = sprintf('P=A_1exp(-t/T)+A_0\nA_0 = %.2f \nA_1 = %.2f \nT = %.2f ms',P(2),P(1),P(3));
annotation('textbox',[0.5,0.5,0.1,0.1],'String',str,'FontSize',16,'FitBoxToText','on');