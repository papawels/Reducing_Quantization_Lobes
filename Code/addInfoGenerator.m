function addInfo = addInfoGenerator(app)

value = app.TabSelectionListBox.Value;
switch value
    case '1. Array Geometry'
        addInfo = "";
    case '2. Single Element Directivity Pattern'
        addInfo = "";
    case '3. Array Directivity Pattern'
        start = string(app.StartEditField.Value);
        last = string(app.EndEditField.Value);
        cut = string(app.CutAngleEditField.Value);
        addInfo = "st" + start + "ed" + last + "ct" + cut;
    case '4. Azmith Cut'
        start = string(app.StartEditField.Value);
        last = string(app.EndEditField.Value);
        cut = string(app.CutAngleEditField.Value);
        addInfo = "st" + start + "ed" + last + "ct" + cut;
    case '5. Elevation Cut'
        start = string(app.StartEditField_2.Value);
        last = string(app.EndEditField_2.Value);
        cut = string(app.CutAngleEditField_2.Value);
        addInfo = "st" + start + "ed" + last + "ct" + cut;
    case '6. UV Space'
        start = string(app.StartEditField_3.Value);
        last = string(app.EndEditField_3.Value);
        cut = string(app.CutEditField.Value);
        if app.UCheckBox.Value == 1
            space = "U";
        elseif app.VCheckBox.Value == 1
            space = "V";
        else
            cut = "NONE";
            space = "";
        end
        addInfo = "st" + start + "ed" + last + "ct" + cut + space;
    case '7. Grating Lobes'
        addInfo = "";
    case '8. Quantization Lobe Graph'
        addInfo = "QLobes";
    otherwise
        addInfo = "Unknown";
end


end