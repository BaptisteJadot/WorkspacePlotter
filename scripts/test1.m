display('toto')
display(LSD.filename)
% save('temp.mat','LSD','-v6');
% newLSD=load('temp.mat','LSD');

% newLSD = LSD;
newLSD = Load_Manager();
newLSD.filename='tata';

display([LSD.filename newLSD.filename])
