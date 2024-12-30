function tag = tagGenerator(app)

value = app.TabSelectionListBox.Value;
switch value
    case '1. Array Geometry'
        tag = "ArrayGeometry";
    case '2. Single Element Directivity Pattern'
        tag = "SingleElemPatt";
    case '3. Array Directivity Pattern'
        tag = "ArrayPatt";
    case '4. Azmith Cut'
        tag = "AzCut";
    case '5. Elevation Cut'
        tag = "ElCut";
    case '6. UV Space'
        tag = "UVspace";
    case '7. Grating Lobes'
        tag = "GratingLobes";
    case '8. Quantization Lobes'
        tag = "QLobes";
    otherwise
        tag = "Unknown";
end


end