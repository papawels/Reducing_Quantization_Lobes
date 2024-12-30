function name = NameGen(app)

tag = tagGenerator(app);

dimM = app.MSpinner.Value;
dimN = app.NSpinner.Value;
freq = app.FrequencyGHzEditField.Value;

if contains(string(freq),'.')
    freq = strrep(string(freq),'.','p');
end

theta = app.DegEditField.Value;
phi = app.DegEditField_2.Value;

specs = string(dimM) + "x" + string(dimN) + ...
    "-" + freq + "-TH" + string(theta) + "PHI" + string(phi);
specs = char(specs);

addInfo = addInfoGenerator(app);

name = [char(tag) '_' specs '_' char(addInfo) '_' datestr(now,'mmmdd-HHMM')];

end