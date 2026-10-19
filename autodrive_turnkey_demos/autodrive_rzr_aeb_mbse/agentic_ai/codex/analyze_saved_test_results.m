%% Analyze saved AutoDRIVE RZR AEB test results
% This script imports TestResults.mldatx without running simulations,
% extracts iteration-level evidence, summarizes requirement and variant
% performance, and exports engineering visualizations and tabular results.

scriptPath = mfilename("fullpath");
projectFolder = fileparts(scriptPath);
resultsFile = fullfile(projectFolder,"TestResults.mldatx");
outputFolder = fullfile(projectFolder,"test_analysis_output");

assert(isfile(resultsFile), ...
    "Saved Test Manager results were not found: %s",resultsFile);

if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

%% Import the saved result set and locate iteration results
resultObjects = sltest.testmanager.importResults(resultsFile,UniqueImport=true);
assert(~isempty(resultObjects),"No result set was imported from %s.",resultsFile);
resultSet = resultObjects(end);

fileResults = resultSet.getTestFileResults;
assert(~isempty(fileResults),"The imported result set has no test-file results.");

iterationResults = [];
for fileIndex = 1:numel(fileResults)
    suiteResults = fileResults(fileIndex).getTestSuiteResults;
    for suiteIndex = 1:numel(suiteResults)
        caseResults = suiteResults(suiteIndex).getTestCaseResults;
        for caseIndex = 1:numel(caseResults)
            theseIterations = caseResults(caseIndex).getIterationResults;
            iterationResults = [iterationResults; theseIterations(:)]; %#ok<AGROW>
        end
    end
end

assert(~isempty(iterationResults), ...
    "The imported result set contains no iteration results.");

%% Extract iteration-level evidence
numberOfIterations = numel(iterationResults);
iterationNumber = (1:numberOfIterations)';
iterationName = strings(numberOfIterations,1);
outcome = strings(numberOfIterations,1);
passed = false(numberOfIterations,1);
variant = strings(numberOfIterations,1);
controller = strings(numberOfIterations,1);
perceiver = strings(numberOfIterations,1);
planner = strings(numberOfIterations,1);
parameterSet = strings(numberOfIterations,1);
timeOfDay = nan(numberOfIterations,1);
weatherID = nan(numberOfIterations,1);
durationSeconds = nan(numberOfIterations,1);
initializationSeconds = nan(numberOfIterations,1);
executionSeconds = nan(numberOfIterations,1);
criteriaSeconds = nan(numberOfIterations,1);
simulationError = false(numberOfIterations,1);
loggingOverrideWarning = false(numberOfIterations,1);
baselineNotEvaluated = false(numberOfIterations,1);

metricValues = nan(numberOfIterations,4);
criterionPassed = false(numberOfIterations,4);

modelName = "AutoDRIVE_RZR_AEB";
if ~bdIsLoaded(modelName)
    load_system(modelName);
end
configurationData = Simulink.VariantManager.getConfigurationData(modelName);

controllerNames = ["Bang-Bang Controller","PID Controller"];
perceiverNames = ["Tiny YOLO V2","Tiny YOLO V3","Tiny YOLO V4", ...
    "YOLO V2","YOLO V3","YOLO V4"];
plannerNames = ["Abrupt AEB","Smooth AEB"];

for iterationIndex = 1:numberOfIterations
    iteration = iterationResults(iterationIndex);

    iterationName(iterationIndex) = string(iteration.Name);
    outcome(iterationIndex) = string(iteration.Outcome);
    passed(iterationIndex) = outcome(iterationIndex) == "Passed";
    variant(iterationIndex) = string(iteration.VariantConfiguration.Name);
    parameterSet(iterationIndex) = string( ...
        iteration.ParameterSet.ParameterSetName);
    durationSeconds(iterationIndex) = seconds(iteration.Duration);

    parameterOverrides = iteration.ParameterSet.ParameterOverrides;
    timeOfDay(iterationIndex) = getOverrideValue( ...
        parameterOverrides,"TimeOfDay");
    weatherID(iterationIndex) = getOverrideValue( ...
        parameterOverrides,"WeatherID");

    [controller(iterationIndex),perceiver(iterationIndex), ...
        planner(iterationIndex)] = getVariantSelections( ...
        configurationData,variant(iterationIndex),controllerNames, ...
        perceiverNames,plannerNames);

    customResult = iteration.getCustomCriteriaResult;
    diagnosticRecords = customResult.DiagnosticRecord;
    assert(numel(diagnosticRecords) == 4, ...
        "Iteration %s has %d custom-criteria records; expected 4.", ...
        iterationName(iterationIndex),numel(diagnosticRecords));

    for criterionIndex = 1:4
        criterionPassed(iterationIndex,criterionIndex) = ...
            string(diagnosticRecords(criterionIndex).Outcome) == "Passed";
        metricValues(iterationIndex,criterionIndex) = ...
            parseActualValue(diagnosticRecords(criterionIndex));
    end

    simulationMessages = iteration.ErrorMessages.Simulation.messages;
    simulationError(iterationIndex) = ~isempty(simulationMessages);

    simulationLogs = string(iteration.LogMessages.Simulation.messages);
    loggingOverrideWarning(iterationIndex) = any(contains( ...
        simulationLogs,"data logging override settings"));
    testCaseLogs = string(iteration.LogMessages.TestCase);
    baselineNotEvaluated(iterationIndex) = any(contains( ...
        testCaseLogs,"No baseline criteria evaluation performed"));

    timing = iteration.getTimingInfo;
    initializationSeconds(iterationIndex) = timing.SimulationInitialization;
    executionSeconds(iterationIndex) = timing.SimulationExecution;
    criteriaSeconds(iterationIndex) = timing.CustomCriteria;
end

variantOrder = unique(variant,"stable");
controllerOrder = controllerNames(ismember(controllerNames,controller));
perceiverOrder = perceiverNames(ismember(perceiverNames,perceiver));
plannerOrder = plannerNames(ismember(plannerNames,planner));

testData = table( ...
    iterationNumber,iterationName,categorical(outcome,["Passed","Failed"]), ...
    passed,categorical(variant,variantOrder,Ordinal=true), ...
    categorical(controller,controllerOrder,Ordinal=true), ...
    categorical(perceiver,perceiverOrder,Ordinal=true), ...
    categorical(planner,plannerOrder,Ordinal=true),parameterSet, ...
    timeOfDay,weatherID,metricValues(:,1),metricValues(:,2), ...
    metricValues(:,3),metricValues(:,4),criterionPassed(:,1), ...
    criterionPassed(:,2),criterionPassed(:,3),criterionPassed(:,4), ...
    durationSeconds,initializationSeconds,executionSeconds,criteriaSeconds, ...
    simulationError,loggingOverrideWarning,baselineNotEvaluated, ...
    VariableNames=[ ...
    "Iteration","IterationName","Outcome","Passed","Variant", ...
    "Controller","Perceiver","Planner","ParameterSet","TimeOfDay", ...
    "WeatherID","DetectionCount","MaxAbsJerk","AbsMeanTrackingError", ...
    "CollisionCount","DetectionPass","ComfortPass","TrackingPass", ...
    "SafetyPass","DurationSeconds","InitializationSeconds", ...
    "ExecutionSeconds","CriteriaSeconds","SimulationError", ...
    "LoggingOverrideWarning","BaselineNotEvaluated"]);

testData.FailedCriterionCount = sum(~testData{:, ...
    ["DetectionPass","ComfortPass","TrackingPass","SafetyPass"]},2);

testData.Properties.VariableUnits( ...
    ismember(testData.Properties.VariableNames, ...
    ["MaxAbsJerk","AbsMeanTrackingError"])) = ["m/s^3","m/s"];

%% Aggregate the test evidence using tables
criterionVariables = [ ...
    "DetectionPass","ComfortPass","TrackingPass","SafetyPass"];

configurationSummary = groupsummary(testData,"Variant","mean", ...
    ["Passed",criterionVariables]);
configurationSummary.PassRatePct = 100*configurationSummary.mean_Passed;
configurationSummary.DetectionPassRatePct = ...
    100*configurationSummary.mean_DetectionPass;
configurationSummary.ComfortPassRatePct = ...
    100*configurationSummary.mean_ComfortPass;
configurationSummary.TrackingPassRatePct = ...
    100*configurationSummary.mean_TrackingPass;
configurationSummary.SafetyPassRatePct = ...
    100*configurationSummary.mean_SafetyPass;

controllerSummary = componentSummary(testData,"Controller",criterionVariables);
perceiverSummary = componentSummary(testData,"Perceiver",criterionVariables);
plannerSummary = componentSummary(testData,"Planner",criterionVariables);

scenarioSummary = groupsummary(testData,["TimeOfDay","WeatherID"], ...
    "mean",["Passed",criterionVariables]);
scenarioSummary.PassRatePct = 100*scenarioSummary.mean_Passed;

repeatabilitySummary = groupsummary(testData, ...
    ["Variant","TimeOfDay","WeatherID"],["min","max","std"], ...
    ["DetectionCount","MaxAbsJerk","AbsMeanTrackingError","CollisionCount"]);
repeatabilitySummary = repeatabilitySummary( ...
    repeatabilitySummary.GroupCount > 1,:);

%% Display concise numerical results
numberPassed = nnz(testData.Passed);
numberFailed = height(testData) - numberPassed;
criterionPassCounts = sum(testData{:,criterionVariables},1);
criterionFailureCounts = height(testData) - criterionPassCounts;
criterionLabels = ["Detection","Comfort","Tracking","Safety"];

fprintf("\nSaved Test Campaign: %s\n",string(resultSet.Name));
fprintf("Iterations: %d | Passed: %d (%.1f%%) | Failed: %d (%.1f%%)\n", ...
    height(testData),numberPassed,100*numberPassed/height(testData), ...
    numberFailed,100*numberFailed/height(testData));
fprintf("Simulation errors: %d | Logging warnings: %d\n", ...
    nnz(testData.SimulationError),nnz(testData.LoggingOverrideWarning));
fprintf("Mean iteration duration: %.1f s | Median: %.1f s\n\n", ...
    mean(testData.DurationSeconds,"omitmissing"), ...
    median(testData.DurationSeconds,"omitmissing"));

requirementSummary = table(criterionLabels',criterionPassCounts', ...
    criterionFailureCounts',100*criterionPassCounts'/height(testData), ...
    VariableNames=["Criterion","Passed","Failed","PassRatePct"]);
requirementSummary
configurationSummary(:,["Variant","GroupCount","PassRatePct", ...
    "DetectionPassRatePct","ComfortPassRatePct", ...
    "TrackingPassRatePct","SafetyPassRatePct"])

%% Visualization 1: campaign overview
passColor = [0.13 0.55 0.36];
failColor = [0.82 0.22 0.20];
accentColor = [0.12 0.43 0.70];
neutralColor = [0.62 0.67 0.72];

overviewFigure = figure(Name="AEB Test Campaign Overview", ...
    Color="w",Position=[80 70 1500 850]);
overviewLayout = tiledlayout(overviewFigure,2,3, ...
    TileSpacing="compact",Padding="compact");
title(overviewLayout,"AutoDRIVE RZR AEB — Saved Test Campaign Overview", ...
    FontWeight="bold");

axisHandle = nexttile(overviewLayout);
overallBars = bar(axisHandle,categorical(["Passed","Failed"], ...
    ["Passed","Failed"],Ordinal=true),[numberPassed numberFailed],0.65);
overallBars.FaceColor = "flat";
overallBars.CData = [passColor;failColor];
ylabel(axisHandle,"Iterations");
title(axisHandle,sprintf("Overall outcome: %.1f%% passed", ...
    100*numberPassed/height(testData)));
grid(axisHandle,"on");
addBarLabels(axisHandle,[numberPassed numberFailed],"%.0f");

axisHandle = nexttile(overviewLayout);
criterionCategories = categorical(criterionLabels,criterionLabels, ...
    Ordinal=true);
criterionBars = barh(axisHandle,criterionCategories, ...
    [criterionPassCounts' criterionFailureCounts'],"stacked");
criterionBars(1).FaceColor = passColor;
criterionBars(2).FaceColor = failColor;
xlabel(axisHandle,"Iterations");
title(axisHandle,"Requirement-criterion outcomes");
legend(axisHandle,["Passed","Failed"],Location="southoutside", ...
    Orientation="horizontal");
grid(axisHandle,"on");

axisHandle = nexttile(overviewLayout);
variantPassRate = configurationSummary.PassRatePct;
bar(axisHandle,configurationSummary.Variant,variantPassRate, ...
    FaceColor=accentColor);
ylabel(axisHandle,"Overall pass rate (%)");
ylim(axisHandle,[0 max(30,ceil(max(variantPassRate)/5)*5+5)]);
title(axisHandle,"System configuration performance");
grid(axisHandle,"on");
addBarLabels(axisHandle,variantPassRate,"%.0f%%");

axisHandle = nexttile(overviewLayout);
failureMultiplicity = groupcounts(testData,"FailedCriterionCount");
bar(axisHandle,failureMultiplicity.FailedCriterionCount, ...
    failureMultiplicity.GroupCount,FaceColor=neutralColor);
xlabel(axisHandle,"Failed criteria per iteration");
ylabel(axisHandle,"Iterations");
title(axisHandle,"Failure multiplicity");
xticks(axisHandle,0:4);
grid(axisHandle,"on");
addBarLabels(axisHandle,failureMultiplicity.GroupCount,"%.0f");

axisHandle = nexttile(overviewLayout);
timeSummary = groupsummary(testData,"TimeOfDay","mean","Passed");
timeRates = 100*timeSummary.mean_Passed;
bar(axisHandle,categorical(string(timeSummary.TimeOfDay)),timeRates, ...
    FaceColor=accentColor);
xlabel(axisHandle,"Recorded TimeOfDay value");
ylabel(axisHandle,"Overall pass rate (%)");
title(axisHandle,"Performance by recorded time setting");
ylim(axisHandle,[0 max(35,ceil(max(timeRates)/5)*5+5)]);
grid(axisHandle,"on");
addBarLabels(axisHandle,timeRates,"%.0f%%");

axisHandle = nexttile(overviewLayout);
histogram(axisHandle,testData.DurationSeconds,12, ...
    FaceColor=neutralColor,EdgeColor="w");
xlabel(axisHandle,"Iteration duration (s)");
ylabel(axisHandle,"Iterations");
title(axisHandle,sprintf("Runtime distribution — median %.1f s", ...
    median(testData.DurationSeconds,"omitmissing")));
grid(axisHandle,"on");

%% Visualization 2: component-selection evidence
componentFigure = figure(Name="AEB Component Selection Analysis", ...
    Color="w",Position=[110 90 1500 850]);
componentLayout = tiledlayout(componentFigure,2,2, ...
    TileSpacing="compact",Padding="compact");
title(componentLayout, ...
    "Component selections and recorded scenario performance", ...
    FontWeight="bold");

plotComponentRates(nexttile(componentLayout),controllerSummary, ...
    "Controller","Controller selection");
plotComponentRates(nexttile(componentLayout),perceiverSummary, ...
    "Perceiver","Perception selection");
plotComponentRates(nexttile(componentLayout),plannerSummary, ...
    "Planner","Planner selection");

axisHandle = nexttile(componentLayout);
plotScenarioHeatmap(axisHandle,scenarioSummary);

%% Visualization 3: measured values against acceptance limits
metricFigure = figure(Name="AEB Requirement Measurements", ...
    Color="w",Position=[140 110 1500 850]);
metricLayout = tiledlayout(metricFigure,2,2, ...
    TileSpacing="compact",Padding="compact");
title(metricLayout,"Measured values and requirement thresholds", ...
    FontWeight="bold");

plotMetricEvidence(nexttile(metricLayout),testData.Iteration, ...
    testData.DetectionCount,testData.DetectionPass,1, ...
    "Detection count","Must be > 1",false);
plotMetricEvidence(nexttile(metricLayout),testData.Iteration, ...
    testData.MaxAbsJerk,testData.ComfortPass,6, ...
    "Maximum absolute jerk (m/s^3)","Must be < 6",true);
plotMetricEvidence(nexttile(metricLayout),testData.Iteration, ...
    testData.AbsMeanTrackingError,testData.TrackingPass,1, ...
    "Absolute mean tracking error (m/s)","Must be < 1",false);
plotMetricEvidence(nexttile(metricLayout),testData.Iteration, ...
    testData.CollisionCount,testData.SafetyPass,0, ...
    "Collision count","Must equal 0",true);

%% Export reproducible analysis artifacts
writetable(testData,fullfile(outputFolder,"iteration_data.csv"));
writetable(requirementSummary, ...
    fullfile(outputFolder,"requirement_summary.csv"));
writetable(configurationSummary, ...
    fullfile(outputFolder,"configuration_summary.csv"));
writetable(controllerSummary, ...
    fullfile(outputFolder,"controller_summary.csv"));
writetable(perceiverSummary, ...
    fullfile(outputFolder,"perceiver_summary.csv"));
writetable(plannerSummary, ...
    fullfile(outputFolder,"planner_summary.csv"));
writetable(scenarioSummary, ...
    fullfile(outputFolder,"scenario_summary.csv"));
writetable(repeatabilitySummary, ...
    fullfile(outputFolder,"repeatability_summary.csv"));

exportgraphics(overviewFigure, ...
    fullfile(outputFolder,"campaign_overview.png"),Resolution=180);
exportgraphics(componentFigure, ...
    fullfile(outputFolder,"component_analysis.png"),Resolution=180);
exportgraphics(metricFigure, ...
    fullfile(outputFolder,"requirement_measurements.png"),Resolution=180);

save(fullfile(outputFolder,"analysis_workspace.mat"), ...
    "testData","requirementSummary","configurationSummary", ...
    "controllerSummary","perceiverSummary","plannerSummary", ...
    "scenarioSummary","repeatabilitySummary");

fprintf("\nAnalysis outputs saved to:\n%s\n",outputFolder);

%% Local functions
function value = getOverrideValue(parameterOverrides,variableName)
value = NaN;
for overrideIndex = 1:numel(parameterOverrides)
    if string(parameterOverrides(overrideIndex).Variable) == variableName
        value = str2double(string(parameterOverrides(overrideIndex).Value));
        return
    end
end
end

function value = parseActualValue(diagnosticRecord)
diagnosticText = string( ...
    diagnosticRecord.FrameworkDiagnosticResult{1});
token = regexp(diagnosticText, ...
    "Actual Value:\s*(?:uint16\s*)?([+-]?[0-9]+(?:\.[0-9]+)?" + ...
    "(?:[eE][+-]?[0-9]+)?)","tokens","once");
assert(~isempty(token), ...
    "Could not parse the actual value from a diagnostic record.");
value = str2double(token{1});
end

function [controller,perceiver,planner] = getVariantSelections( ...
    configurationData,configurationName,controllerNames, ...
    perceiverNames,plannerNames)
configuration = configurationData.getConfiguration( ...
    char(configurationName));
controlVariables = configuration.ControlVariables;

controllerIndex = NaN;
perceiverIndex = NaN;
plannerIndex = NaN;
for controlIndex = 1:numel(controlVariables)
    controlName = string(controlVariables(controlIndex).Name);
    controlValue = controlVariables(controlIndex).Value.Value;
    switch controlName
        case "CONTROLLER"
            controllerIndex = controlValue;
        case "PERCEIVER"
            perceiverIndex = controlValue;
        case "PLANNER"
            plannerIndex = controlValue;
    end
end

assert(isbetween(controllerIndex,1,numel(controllerNames)) && ...
    isbetween(perceiverIndex,1,numel(perceiverNames)) && ...
    isbetween(plannerIndex,1,numel(plannerNames)), ...
    "Variant configuration %s contains an unsupported selection.", ...
    configurationName);

controller = controllerNames(controllerIndex);
perceiver = perceiverNames(perceiverIndex);
planner = plannerNames(plannerIndex);
end

function summaryTable = componentSummary(testData,groupVariable, ...
    criterionVariables)
summaryTable = groupsummary(testData,groupVariable,"mean", ...
    ["Passed",criterionVariables]);
summaryTable.Overall = 100*summaryTable.mean_Passed;
summaryTable.Detection = 100*summaryTable.mean_DetectionPass;
summaryTable.Comfort = 100*summaryTable.mean_ComfortPass;
summaryTable.Tracking = 100*summaryTable.mean_TrackingPass;
summaryTable.Safety = 100*summaryTable.mean_SafetyPass;
end

function plotComponentRates(axisHandle,summaryTable, ...
    groupVariable,plotTitle)
rateVariables = ["Overall","Detection","Comfort","Tracking","Safety"];
bar(axisHandle,summaryTable{:,rateVariables},"grouped");
xticks(axisHandle,1:height(summaryTable));
xticklabels(axisHandle,string(summaryTable.(groupVariable)));
xtickangle(axisHandle,12);
ylabel(axisHandle,"Pass rate (%)");
ylim(axisHandle,[0 105]);
title(axisHandle,plotTitle);
legend(axisHandle,rateVariables,Location="southoutside", ...
    Orientation="horizontal",NumColumns=3);
grid(axisHandle,"on");
end

function plotScenarioHeatmap(axisHandle,scenarioSummary)
timeValues = sort(unique(scenarioSummary.TimeOfDay));
weatherValues = sort(unique(scenarioSummary.WeatherID));
passRate = nan(numel(timeValues),numel(weatherValues));
sampleCount = zeros(size(passRate));

for rowIndex = 1:height(scenarioSummary)
    timeIndex = find(timeValues == scenarioSummary.TimeOfDay(rowIndex),1);
    weatherIndex = find( ...
        weatherValues == scenarioSummary.WeatherID(rowIndex),1);
    passRate(timeIndex,weatherIndex) = ...
        scenarioSummary.PassRatePct(rowIndex);
    sampleCount(timeIndex,weatherIndex) = ...
        scenarioSummary.GroupCount(rowIndex);
end

imageHandle = imagesc(axisHandle,passRate,[0 100]);
imageHandle.AlphaData = ~isnan(passRate);
axisHandle.Color = [0.92 0.92 0.92];
colormap(axisHandle,turbo);
colorbar(axisHandle);
xticks(axisHandle,1:numel(weatherValues));
xticklabels(axisHandle,string(weatherValues));
yticks(axisHandle,1:numel(timeValues));
yticklabels(axisHandle,string(timeValues));
xlabel(axisHandle,"WeatherID");
ylabel(axisHandle,"TimeOfDay");
title(axisHandle,"Overall pass rate by recorded scenario (%)");

for rowIndex = 1:numel(timeValues)
    for columnIndex = 1:numel(weatherValues)
        if ~isnan(passRate(rowIndex,columnIndex))
            text(axisHandle,columnIndex,rowIndex, ...
                sprintf("%.0f%%\n(n=%d)", ...
                passRate(rowIndex,columnIndex), ...
                sampleCount(rowIndex,columnIndex)), ...
                HorizontalAlignment="center",FontWeight="bold", ...
                Color=contrastTextColor( ...
                passRate(rowIndex,columnIndex)));
        end
    end
end
end

function plotMetricEvidence(axisHandle,iteration,value,isPassing, ...
    threshold,yLabelText,thresholdText,useLogScale)
metricTitle = yLabelText;
plotValue = value;
plotThreshold = threshold;
if useLogScale
    if any(plotValue <= 0)
        plotValue = plotValue + 1;
        plotThreshold = plotThreshold + 1;
        yLabelText = yLabelText + " + 1";
    end
    yLabelText = yLabelText + " (log scale)";
end

hold(axisHandle,"on");
scatter(axisHandle,iteration(isPassing),plotValue(isPassing),24, ...
    [0.13 0.55 0.36],"filled",DisplayName="Pass");
scatter(axisHandle,iteration(~isPassing),plotValue(~isPassing),24, ...
    [0.82 0.22 0.20],"filled",DisplayName="Fail");
thresholdLine = yline(axisHandle,plotThreshold,"--k",thresholdText, ...
    LabelHorizontalAlignment="left",LineWidth=1.4);
thresholdLine.HandleVisibility = "off";
xlabel(axisHandle,"Iteration");
ylabel(axisHandle,yLabelText);
title(axisHandle,sprintf("%s — %d/%d passed", ...
    metricTitle,nnz(isPassing),numel(isPassing)));
grid(axisHandle,"on");
legend(axisHandle,Location="best");
if useLogScale
    axisHandle.YScale = "log";
end
hold(axisHandle,"off");
end

function addBarLabels(axisHandle,values,formatText)
for valueIndex = 1:numel(values)
    text(axisHandle,valueIndex,values(valueIndex), ...
        sprintf(formatText,values(valueIndex)), ...
        HorizontalAlignment="center",VerticalAlignment="bottom", ...
        FontWeight="bold");
end
end

function color = contrastTextColor(value)
if value > 55
    color = [0 0 0];
else
    color = [1 1 1];
end
end
