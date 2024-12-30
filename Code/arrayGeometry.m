function arrayGeometry(app)

missing = warningFileName(app);
if missing == 1
    return
end

%% Array Geometry  
Name = NameGen(app);
elemNum = app.MSpinner.Value*app.NSpinner.Value;
arrayFigure = figure('Position',[900 250 500 500],'Name',Name);
viewArray(app.array,'ShowNormal',true,...
  'ShowTaper',false,'ShowIndex',[1, elemNum],...
  'ShowLocalCoordinates',false,'ShowAnnotation',true,...
  'Orientation',[0;0;0]); 
end