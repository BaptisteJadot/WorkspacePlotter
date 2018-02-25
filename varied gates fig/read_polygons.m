function fig=read_polygons(filename,gatenames,GateValues)
% Function that reads an ascii polygon file and a gate conversion table
% (also ascii) and paints the Polygons. Standard filenames are
% 'exported_arrays.txt' for the polygon coordinates and 'gate_names.txt'
% for the gate number to gate name conversion table. If no conversion table
% is given, the function will call the polygons by their gate number (1,2,3..)
if ~exist('filename', 'var')
    filename = 'exported_arrays.txt';
end
Polys=read_exported_file(filename);
gate_names=read_gate_names(length(Polys));
Polygons_colors=zeros(length(Polys),1);

%% Finding varied gate/polygon pairs
sweeps=gatenames{1};
for i=1:length(sweeps(:,1))
    out=regexp(sweeps(i,:),'\d:\d','match');
    if ~isempty(out)
        k=find(strcmp(out, gate_names(1,:)));
        Polygons_colors(k)=1;
    end
end

steps=gatenames{2};
for i=1:length(steps(:,1))
    out=regexp(steps(i,:),'\d:\d','match');
    if ~isempty(out)
        k=find(strcmp(out, gate_names(1,:)));
        Polygons_colors(k)=2;
    end
end

steps2=gatenames{3};
for i=1:length(steps2(:,1))
    out=regexp(steps2(i,:),'\d:\d','match');
    if ~isempty(out)
        k=find(strcmp(out, gate_names(1,:)));
        Polygons_colors(k)=3;
    end    
end

%% Paint the Polygons and undock the figure for resizing
fig=paint_polygons(Polys,Polygons_colors,gate_names,GateValues);
set(fig,'windowstyle','modal');
set(fig,'windowstyle','normal');

end


function polygons=read_exported_file(filename)
if ~exist('filename', 'var')
    filename = 'exported_arrays.txt';
end
fid = fopen(filename);
tline='o';
i=0;
while ischar(tline)
    tline = fgetl(fid);
    if strfind(tline,'array')
        if i~=0 
            polygons{i}=polygon;
        end
        i=i+1;
        polygon=[];
        j=1;
        k = strfind(tline,' array([[') ;
        a=sscanf(tline(k+9:end),'%e , %e');
    elseif ischar(tline)
        j=j+1;
        a=sscanf(tline,'       [ %e , %e ]');
    end
    polygon(j,1)=a(1);
    polygon(j,2)=a(2);    
end
polygons{i}=polygon;
fclose(fid);
end

function gate_names=read_gate_names(length_needed, filename)
if ~exist('filename', 'var')
    filename = 'gate_names.txt';
end
for i=1:length_needed
    gate_names(i)=cellstr(num2str(i));
end
fid = fopen(filename);
tline = fgetl(fid);
while ischar(tline)    
    str=sscanf(tline,'%d = %s');
    position=str(1);
    name=strcat(char(str(2:end))');
    gate_names(position) =cellstr(name(2:end-1));
    tline = fgetl(fid);
end
if length(gate_names)>length_needed
    gate_names=gate_names(1:length_needed);
    disp('Too many gate names in file')
end
fclose(fid);
end

function fig=paint_polygons(polygons,Polygons_colors,gate_names,GateValues)
if ~exist('Painted_Polygons', 'var')
    Polygons_colors = zeros(length(polygons),1);
end
if ~exist('gate_names', 'var')
    for i=1:length(polygons)
        gate_names(i)=cellstr(num2str(i));
    end
end

fig=figure(51);
clf
hold on
polygons{1}(:,1);
polygons{1}(:,2);

for k=1:length(polygons)
    if Polygons_colors(k)==0
        clr='white';
    elseif Polygons_colors(k)==1
        clr='blue';
    elseif Polygons_colors(k)==2
        clr='red';
    elseif Polygons_colors(k)==3
        clr='green';
    elseif Polygons_colors(k)==4
        clr='magenta';
    else
        clr='yellow';
    end
    
    fill(polygons{k}(:,1)',polygons{k}(:,2)',clr)
    [x,y,~]=centroid(polygons{k}(:,1)',polygons{k}(:,2)');
    pos=sscanf(char(gate_names(k)),'%i:%i');   
    scaling = 1.15;  %Pushes names and values outward from the center
    text(scaling*x,scaling*y,[gate_names(k) num2str(GateValues(pos(1)+1,pos(2)+1),3)], 'Fontsize', 12, ...
        'FontName', 'Times New Roman', 'FontWeight', 'bold',...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
end
axis equal
hold off

end

function [x0,y0,a] = centroid(x,y)

% x and y must be non-scalar vectors of equal sizes
% defining a polygonal region in counterclockwise
% sequence. a is returned with the polygon's area, and
% (x0,y0) with the coordinates of the polygon's centroid.
% Note: with clockwise order, x0 and y0 are still
% correct but a is the negative of the area.
% RAS - 1/17/05

[m1,n1] = size(x); [m2,n2] = size(y);
n = max(m1,n1);
if m1 ~= m2 ||n1 ~= n2 || min(m1,n1) ~= 1 || n <= 1
 error('Args must be equal-sized non-scalar vectors')
end
x = x(:); y = y(:);
x2 = [x(2:n);x(1)];
y2 = [y(2:n);y(1)];
a = 1/2*sum (x.*y2-x2.*y);
x0 = 1/6*sum((x.*y2-x2.*y).*(x+x2))/a;
y0 = 1/6*sum((x.*y2-x2.*y).*(y+y2))/a;
end