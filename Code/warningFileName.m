function missing = warningFileName(app)

missing = 0;

%% Warning Dialog
if isempty(app.FileLocationEditField.Value)
    warndlg('Please enter a file location of antenna data...Returning')
    missing = 1;
    return
end
if ~isfile(app.FileLocationEditField.Value)
    warndlg('Please enter a valid file location of antenna data...Returning')
    missing = 1;
    return
end

end