// ActionScript file

import melt.metalanalysis.MetalAnalysisModelLocator;

import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:MetalAnalysisModelLocator = (MetalAnalysisModelLocator)(__genModel.activeModelLocator);
