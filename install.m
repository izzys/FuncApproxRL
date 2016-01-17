disp('Installing RL toolbox ... ')

currentFolder = pwd;

addpath(currentFolder)
addpath([currentFolder, '\Methods']);
addpath([currentFolder, '\Models']);

savepath 

disp('Done! type RLgui in comand window to start toolbox.');