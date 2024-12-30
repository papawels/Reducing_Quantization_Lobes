function saveButton(app)

app.FinishedLamp.Color = [1 0 0];
pause(2);

tag = tagGenerator(app);

h1 = findall(groot,'type','Figure');

masterList ={};
list = {};

listIdx = 1;
for i = 1:length(h1)
    masterList{i} = h1(i).Name;
    if strcmp(h1(i).Name,'Phased Array App')
        appIdx = i;
    end
    if contains(string(h1(i).Name),tag)
        list{listIdx} = h1(i).Name;
        listIdx = listIdx + 1;
    end
end

if isempty(list)
    warndlg('No figures are present...Returning')
    return
end

promt = 'Please select all figures on the list that you would like to save';
dlgTitle = [char(tag) ' Figure Selection'];
[indx,tf] = listdlg('PromptString',[{promt} {''}],...
    'Name',dlgTitle,'ListString',list,'ListSize',[400,250]);

[~, ia, ~] = intersect(masterList, list);

currentPath = [pwd '\Figures\'];

if isempty(indx)
    warndlg('No figure was selected...Returning')
    return
else
    for i = 1:length(ia)
        saveas(h1(ia(i)),[currentPath h1(ia(i)).Name])
        if app.SaveAsCheckBox.Value == 1
            saveas(h1(ia(i)),[currentPath h1(ia(i)).Name],app.DropDown.Value)
        end
    end
end

figure(h1(appIdx));

app.FinishedLamp.Color = [0 1 0];