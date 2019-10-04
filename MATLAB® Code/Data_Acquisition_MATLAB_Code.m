classdef Data_Acquisition_MATLAB_Code < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        MainGridLayout                 matlab.ui.container.GridLayout
        StatusPanel                    matlab.ui.control.Label
        ServoMotorOrientationGaugeLabel  matlab.ui.control.Label
        ServoMotorOrientationGauge     matlab.ui.control.SemicircularGauge
        SamplingRateKnobLabel          matlab.ui.control.Label
        SamplingRateKnob               matlab.ui.control.Knob
        StatusLabel                    matlab.ui.control.Label
        StatusIndicator                matlab.ui.control.StateButton
        TabGroup                       matlab.ui.container.TabGroup
        AutomaticControlTab            matlab.ui.container.Tab
        ProcessedDataTabGridLayout     matlab.ui.container.GridLayout
        LightIntensityGraph            matlab.ui.control.UIAxes
        TemperatureGraph               matlab.ui.control.UIAxes
        LightIntensityGaugeLabel       matlab.ui.control.Label
        LightIntensityGauge            matlab.ui.control.SemicircularGauge
        TemperatureCLabel              matlab.ui.control.Label
        TemperatureGauge               matlab.ui.control.SemicircularGauge
        ProcessedDataLabel             matlab.ui.control.Label
        LightstatusLampLabel           matlab.ui.control.Label
        LightstatusLamp                matlab.ui.control.Lamp
        PanelsareopenLampLabel         matlab.ui.control.Label
        PanelsareopenLamp              matlab.ui.control.Lamp
        LightIntensityTresholdKnobLabel  matlab.ui.control.Label
        LightIntensityTresholdKnob     matlab.ui.control.Knob
        TemperatureTresholdLabel       matlab.ui.control.Label
        TempTresholdKnob               matlab.ui.control.Knob
        LightIntensityTresholdLabel    matlab.ui.control.Label
        TempTresholdLabel              matlab.ui.control.Label
        MonitorSensorDataTab           matlab.ui.container.Tab
        RawInputAnalysisTabGridLayout  matlab.ui.container.GridLayout
        LDRRawGraph                    matlab.ui.control.UIAxes
        LDRVoltageGauge_2Label         matlab.ui.control.Label
        LDRVoltageGauge                matlab.ui.control.SemicircularGauge
        TemperatureCLabel_2            matlab.ui.control.Label
        TempVoltageGauge               matlab.ui.control.SemicircularGauge
        RawInputAnalysisLabel          matlab.ui.control.Label
        PinNoKnob_2Label               matlab.ui.control.Label
        LDRRawDataPinNoKnob            matlab.ui.control.DiscreteKnob
        PinNoKnob_3Label               matlab.ui.control.Label
        TemperatureSensorRawDataPinNoKnob  matlab.ui.control.DiscreteKnob
        TempRawGraph                   matlab.ui.control.UIAxes
        TestDebugTab                   matlab.ui.container.Tab
        TestDebugTabGridLayout         matlab.ui.container.GridLayout
        TestDebugLabel                 matlab.ui.control.Label
        TestAnalogPinsBlock            matlab.ui.control.Label
        PinNoKnobLabel                 matlab.ui.control.Label
        PinNoKnob                      matlab.ui.control.DiscreteKnob
        VoltageGaugeLabel              matlab.ui.control.Label
        TestAnalogVoltageGauge         matlab.ui.control.Gauge
        TestAnalogPinsSwitch           matlab.ui.control.Switch
        TestAnalogPinsLabel            matlab.ui.control.Label
        TestStepMotorBlock             matlab.ui.control.Label
        TestStepMotorLabel             matlab.ui.control.Label
        RotateStepMotor                matlab.ui.control.Knob
        RotateStepMotorLabel           matlab.ui.control.Label
        ControlPWMVoltageBlock         matlab.ui.control.Label
        TestLEDsLabel                  matlab.ui.control.Label
        TestBuiltinLedBlock            matlab.ui.control.Label
        TestBuiltinLedLabel            matlab.ui.control.Label
        TestBuiltinLedStatusIndicator  matlab.ui.control.Button
        TestBuiltinLedSwitch           matlab.ui.control.Switch
        TestBuiltinLed_StatusLabel     matlab.ui.control.Label
        BuzzerButton                   matlab.ui.control.Button
        ControltheLEDLabel             matlab.ui.control.Label
        LightStatusSwitch              matlab.ui.control.RockerSwitch
        LightStatusButton              matlab.ui.control.Button
        PanelsOpenButton               matlab.ui.control.Button
        PanelsOpenSwitch               matlab.ui.control.RockerSwitch
        PanelsMovingSwitch             matlab.ui.control.RockerSwitch
        PanelsMovingButton             matlab.ui.control.Button
        ModeOneTwo                     matlab.ui.control.ToggleSwitch
        OnOffSwitch                    matlab.ui.control.ToggleSwitch
        ModeThreeFour                  matlab.ui.control.ToggleSwitch
    end

    
    properties (Access = private)
        s
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: TestBuiltinLedSwitch
        function TestBuiltinLedSwitchValueChanged(app, event)
            value = app.TestBuiltinLedSwitch.Value;
            % Turn on/off the built-in LED
            if value == "On"
                fwrite(app.s, 10);
                app.TestBuiltinLedStatusIndicator.BackgroundColor = [0.96,0.73,0.19];
            else
                fwrite(app.s, 11);
                app.TestBuiltinLedStatusIndicator.BackgroundColor = [0.80,0.80,0.80];
            end
        end

        % Value changed function: PinNoKnob
        function PinNoKnobValueChanged(app, event)
            value = app.PinNoKnob.Value;
        end

        % Value changed function: TestAnalogPinsSwitch
        function TestAnalogPinsSwitchValueChanged(app, event)
            % Test the analog pins
            value = app.TestAnalogPinsSwitch.Value;
            if value == "On"
                fwrite(app.s, 12);
                fwrite(app.s, str2double(app.PinNoKnob.Value));
                pause(0.05);
                while (app.TestAnalogPinsSwitch.Value == "On")
                    voltage = str2double(fgetl(app.s));
                    app.TestAnalogVoltageGauge.Value = voltage;
                    pause(0.01);
                end
                fclose(app.s);
                app.TestAnalogVoltageGauge.Value = 0;
                pause(0.01);
                fopen(app.s);
                % Turn on the power LED
                pause(2);
                fwrite(app.s, 31);
            end
        end

        % Value changed function: OnOffSwitch
        function OnOffSwitchValueChanged(app, event)
            % SYSTEM ON/OFF
            value = app.OnOffSwitch.Value;
            if value == "On"
                app.s = serial("COM6");
                fopen(app.s);
                pause(2);
                app.StatusIndicator.BackgroundColor = [0.39,0.83,0.07];
                % Turn on the power LED
                fwrite(app.s, 31);
            else
                fclose(app.s);
                app.s = [];
                delete(instrfind);
                app.StatusIndicator.BackgroundColor = [0.84,0.05,0.20];
            end
        end

        % Value changed function: ModeOneTwo
        function ModeOneTwoValueChanged(app, event)
            value = app.ModeOneTwo.Value;
            if value == "1"
                % AUTOMATIC CONTROL
                fwrite(app.s, 1);
                % Set the tresholds
                x1 = zeros(1,20);
                x2 = zeros(1,20);
                while (app.ModeOneTwo.Value == "1")
                    
                    % GRAPHING %
                        % Graph the light density
                        lightIntensity = (100/1023) * str2double(fgetl(app.s));
                        x1 = [x1([2:20]) lightIntensity];
                        plot(app.LightIntensityGraph, x1, 'LineWidth', 2);
                        app.LightIntensityGauge.Value = lightIntensity;
                        pause(0.05);
                        % Graph the Temp Value
                        temperature = str2double(fgetl(app.s));
                        x2 = [x2([2:20]) temperature];
                        plot(app.TemperatureGraph, x2, 'r', 'LineWidth', 2);
                        app.TemperatureGauge.Value = temperature;
                        pause(0.05);
                    % DECISION MAKING %
                        if lightIntensity < app.LightIntensityTresholdKnob.Value
                            % Turn off the light status LED
                            fwrite (app.s, 103);
                            app.LightstatusLamp.Color = [0.80,0.80,0.80];
                            % Close the panels - no light
                            if app.ServoMotorOrientationGauge.Value ~= 0
                                fwrite(app.s, 100);
                                app.ServoMotorOrientationGauge.Value = 0;
                                app.PanelsareopenLamp.Color = [0.80,0.80,0.80];
                            end
                        else
                            %Turn on the light status LED
                            fwrite (app.s, 104);
                            app.LightstatusLamp.Color = [0.39,0.83,0.07];
                            % Check the temperature
                            if temperature < app.TempTresholdKnob.Value - 1
                                % Open the panels - too cold
                                if app.ServoMotorOrientationGauge.Value ~= 90
                                    fwrite(app.s, 101);
                                    app.ServoMotorOrientationGauge.Value = 90;
                                    app.PanelsareopenLamp.Color = [0.00,0.45,0.74];
                                end
                            elseif temperature > app.TempTresholdKnob.Value + 1
                                % Close the panels - too hot
                                if app.ServoMotorOrientationGauge.Value ~= 0
                                    fwrite(app.s, 102);
                                    app.ServoMotorOrientationGauge.Value = 0;
                                    app.PanelsareopenLamp.Color = [0.80,0.80,0.80];
                                end
                            end
                        end
                        
                end
                fclose(app.s);
                pause(0.05);
                fopen(app.s);
                % Turn on the power LED
                pause(2);
                fwrite(app.s, 31);
                app.LightstatusLamp.Color = [0.80,0.80,0.80];
                app.PanelsareopenLamp.Color = [0.80,0.80,0.80];
            end
        end

        % Value changing function: SamplingRateKnob
        function SamplingRateKnobValueChanging(app, event)
            changingValue = event.Value;
            % Change the sampling rate
            fwrite(app.s, 0);
            fwrite(app.s, changingValue);
        end

        % Value changed function: LDRRawDataPinNoKnob
        function LDRRawDataPinNoKnobValueChanged(app, event)
            value = app.LDRRawDataPinNoKnob.Value;
            app.LDRRawDataPinNo = value;
        end

        % Value changed function: TemperatureSensorRawDataPinNoKnob
        function TemperatureSensorRawDataPinNoKnobValueChanged(app, event)
            value = app.TemperatureSensorRawDataPinNoKnob.Value;
            app.TemperatureSensorRawDataPinNo = value;
        end

        % Value changing function: RotateStepMotor
        function RotateStepMotorValueChanging(app, event)
            % Test the servo motor
            changingValue = event.Value;
            fwrite(app.s, 13);
            fwrite(app.s, changingValue);
            app.ServoMotorOrientationGauge.Value = changingValue;
        end

        % Value changed function: ModeThreeFour
        function ModeThreeFourValueChanged(app, event)
            value = app.ModeThreeFour.Value;
            if value == "2"
                % MONITOR SENSOR DATA
                fwrite(app.s, 2);
                x1 = zeros(1,50);
                x2 = zeros(1,50);
                while (app.ModeThreeFour.Value == "2")
                    
                    % Graph the raw LDR voltage
                    y1 = str2double(fgetl(app.s));
                    x1 = [x1([2:50]) y1];
                    plot(app.LDRRawGraph, x1, 'LineWidth', 2);
                    app.LDRVoltageGauge.Value = (5/1023) * y1;
                    pause(0.01);
                    
                    % Graph the Temp Value
                    y2 = str2double(fgetl(app.s));
                    x2 = [x2([2:50]) y2];
                    plot(app.TempRawGraph, x2, 'r', 'LineWidth', 2);
                    app.TempVoltageGauge.Value = y2;
                    pause(0.01);
                    
                end
                app.StatusIndicator.BackgroundColor = [0.96,0.73,0.19];
                fclose(app.s);
                % Clear values from gauges
                app.LDRVoltageGauge.Value = 0;
                app.TempVoltageGauge.Value = 0;
                fopen(app.s);
                app.StatusIndicator.BackgroundColor = [0.39,0.83,0.07];
                % Turn on the power LED
                pause(2);
                fwrite(app.s, 31);
            end
        end

        % Button pushed function: BuzzerButton
        function BuzzerButtonPushed(app, event)
            % Test the buzzer
            fwrite(app.s, 14);
        end

        % Value changed function: LightStatusSwitch
        function LightStatusSwitchValueChanged(app, event)
            value = app.LightStatusSwitch.Value;
            if value == "On"
                fwrite(app.s, 15);
                app.LightStatusButton.BackgroundColor = [0.39,0.83,0.07];
                app.LightStatusButton.FontColor = [1.00,1.00,1.00];
            else
                fwrite(app.s, 16);
                app.LightStatusButton.BackgroundColor = [0.80,0.80,0.80];
                app.LightStatusButton.FontColor = [0.50,0.50,0.50];
            end
        end

        % Value changed function: PanelsOpenSwitch
        function PanelsOpenSwitchValueChanged(app, event)
            value = app.PanelsOpenSwitch.Value;
            if value == "On"
                fwrite(app.s, 17);
                app.PanelsOpenButton.BackgroundColor = [0.00,0.45,0.74];
                app.PanelsOpenButton.FontColor = [1.00,1.00,1.00];
            else
                fwrite(app.s, 18);
                app.PanelsOpenButton.BackgroundColor = [0.80,0.80,0.80];
                app.PanelsOpenButton.FontColor = [0.50,0.50,0.50];
            end
        end

        % Value changed function: PanelsMovingSwitch
        function PanelsMovingSwitchValueChanged(app, event)
            value = app.PanelsMovingSwitch.Value;
            if value == "On"
                fwrite(app.s, 19);
                app.PanelsMovingButton.BackgroundColor = [1.00,0.00,0.00];
                app.PanelsMovingButton.FontColor = [1.00,1.00,1.00];
            else
                fwrite(app.s, 20);
                app.PanelsMovingButton.BackgroundColor = [0.80,0.80,0.80];
                app.PanelsMovingButton.FontColor = [0.50,0.50,0.50];
            end
        end

        % Value changing function: LightIntensityTresholdKnob
        function LightIntensityTresholdKnobValueChanging(app, event)
            changingValue = event.Value;
            app.LightIntensityTresholdLabel.Text = changingValue + "%";
        end

        % Value changing function: TempTresholdKnob
        function TempTresholdKnobValueChanging(app, event)
            changingValue = event.Value;
            app.TempTresholdLabel.Text = changingValue + "°C";
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1251 751];
            app.UIFigure.Name = 'UI Figure';

            % Create MainGridLayout
            app.MainGridLayout = uigridlayout(app.UIFigure);
            app.MainGridLayout.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.MainGridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create StatusPanel
            app.StatusPanel = uilabel(app.MainGridLayout);
            app.StatusPanel.BackgroundColor = [0.8 0.8 0.8];
            app.StatusPanel.Layout.Row = [1 15];
            app.StatusPanel.Layout.Column = [27 29];
            app.StatusPanel.Text = '';

            % Create ServoMotorOrientationGaugeLabel
            app.ServoMotorOrientationGaugeLabel = uilabel(app.MainGridLayout);
            app.ServoMotorOrientationGaugeLabel.HandleVisibility = 'callback';
            app.ServoMotorOrientationGaugeLabel.HorizontalAlignment = 'center';
            app.ServoMotorOrientationGaugeLabel.FontSize = 15;
            app.ServoMotorOrientationGaugeLabel.FontColor = [0.502 0.502 0.502];
            app.ServoMotorOrientationGaugeLabel.Layout.Row = 10;
            app.ServoMotorOrientationGaugeLabel.Layout.Column = [27 29];
            app.ServoMotorOrientationGaugeLabel.Text = {'Servo Motor'; 'Orientation'};

            % Create ServoMotorOrientationGauge
            app.ServoMotorOrientationGauge = uigauge(app.MainGridLayout, 'semicircular');
            app.ServoMotorOrientationGauge.Limits = [0 180];
            app.ServoMotorOrientationGauge.Orientation = 'west';
            app.ServoMotorOrientationGauge.ScaleDirection = 'counterclockwise';
            app.ServoMotorOrientationGauge.HandleVisibility = 'callback';
            app.ServoMotorOrientationGauge.BackgroundColor = [0.7216 0.7216 0.7216];
            app.ServoMotorOrientationGauge.FontColor = [0.9412 0.9412 0.9412];
            app.ServoMotorOrientationGauge.Layout.Row = [11 15];
            app.ServoMotorOrientationGauge.Layout.Column = [27 29];

            % Create SamplingRateKnobLabel
            app.SamplingRateKnobLabel = uilabel(app.MainGridLayout);
            app.SamplingRateKnobLabel.HandleVisibility = 'callback';
            app.SamplingRateKnobLabel.HorizontalAlignment = 'center';
            app.SamplingRateKnobLabel.VerticalAlignment = 'bottom';
            app.SamplingRateKnobLabel.FontSize = 15;
            app.SamplingRateKnobLabel.FontColor = [0.502 0.502 0.502];
            app.SamplingRateKnobLabel.Layout.Row = 6;
            app.SamplingRateKnobLabel.Layout.Column = [27 29];
            app.SamplingRateKnobLabel.Text = {'Sampling'; 'Rate'};

            % Create SamplingRateKnob
            app.SamplingRateKnob = uiknob(app.MainGridLayout, 'continuous');
            app.SamplingRateKnob.Limits = [150 2000];
            app.SamplingRateKnob.ValueChangingFcn = createCallbackFcn(app, @SamplingRateKnobValueChanging, true);
            app.SamplingRateKnob.HandleVisibility = 'callback';
            app.SamplingRateKnob.FontColor = [0.502 0.502 0.502];
            app.SamplingRateKnob.Layout.Row = [7 9];
            app.SamplingRateKnob.Layout.Column = [27 29];
            app.SamplingRateKnob.Value = 150;

            % Create StatusLabel
            app.StatusLabel = uilabel(app.MainGridLayout);
            app.StatusLabel.HorizontalAlignment = 'center';
            app.StatusLabel.VerticalAlignment = 'bottom';
            app.StatusLabel.FontSize = 15;
            app.StatusLabel.FontColor = [0.502 0.502 0.502];
            app.StatusLabel.Layout.Row = 1;
            app.StatusLabel.Layout.Column = [27 29];
            app.StatusLabel.Text = 'Status';

            % Create StatusIndicator
            app.StatusIndicator = uibutton(app.MainGridLayout, 'state');
            app.StatusIndicator.Text = '';
            app.StatusIndicator.BackgroundColor = [0.8392 0.051 0.2];
            app.StatusIndicator.Layout.Row = 2;
            app.StatusIndicator.Layout.Column = 28;

            % Create TabGroup
            app.TabGroup = uitabgroup(app.MainGridLayout);
            app.TabGroup.Layout.Row = [1 15];
            app.TabGroup.Layout.Column = [1 26];

            % Create AutomaticControlTab
            app.AutomaticControlTab = uitab(app.TabGroup);
            app.AutomaticControlTab.Title = 'Automatic Control';

            % Create ProcessedDataTabGridLayout
            app.ProcessedDataTabGridLayout = uigridlayout(app.AutomaticControlTab);
            app.ProcessedDataTabGridLayout.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.ProcessedDataTabGridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create LightIntensityGraph
            app.LightIntensityGraph = uiaxes(app.ProcessedDataTabGridLayout);
            title(app.LightIntensityGraph, 'Light Intensity - Time')
            xlabel(app.LightIntensityGraph, 'Time Interval')
            ylabel(app.LightIntensityGraph, 'Light Intensity')
            app.LightIntensityGraph.PlotBoxAspectRatio = [1.20863309352518 1 1];
            app.LightIntensityGraph.FontSize = 14;
            app.LightIntensityGraph.XLim = [0 20];
            app.LightIntensityGraph.YLim = [0 100];
            app.LightIntensityGraph.GridColor = [0.4941 0.1843 0.5569];
            app.LightIntensityGraph.GridAlpha = 0.15;
            app.LightIntensityGraph.MinorGridColor = [0.7176 0.2745 1];
            app.LightIntensityGraph.XColor = [0.502 0.502 0.502];
            app.LightIntensityGraph.YColor = [0.502 0.502 0.502];
            app.LightIntensityGraph.ZColor = [0.502 0.502 0.502];
            app.LightIntensityGraph.XGrid = 'on';
            app.LightIntensityGraph.XMinorGrid = 'on';
            app.LightIntensityGraph.YGrid = 'on';
            app.LightIntensityGraph.YMinorGrid = 'on';
            app.LightIntensityGraph.TitleFontWeight = 'normal';
            app.LightIntensityGraph.Layout.Row = [2 9];
            app.LightIntensityGraph.Layout.Column = [2 10];

            % Create TemperatureGraph
            app.TemperatureGraph = uiaxes(app.ProcessedDataTabGridLayout);
            title(app.TemperatureGraph, 'Temperature - Time')
            xlabel(app.TemperatureGraph, 'Time Interval')
            ylabel(app.TemperatureGraph, 'Temperature (C°)')
            app.TemperatureGraph.PlotBoxAspectRatio = [1.20863309352518 1 1];
            app.TemperatureGraph.FontSize = 14;
            app.TemperatureGraph.XLim = [0 20];
            app.TemperatureGraph.YLim = [0 50];
            app.TemperatureGraph.ColorOrder = [0 0.4471 0.7412;0.851 0.3255 0.098;0.9294 0.6941 0.1255;0.4941 0.1843 0.5569;0.4667 0.6745 0.1882;0.302 0.7451 0.9333;0.6353 0.0784 0.1843];
            app.TemperatureGraph.GridColor = [0.4941 0.1843 0.5569];
            app.TemperatureGraph.GridAlpha = 0.15;
            app.TemperatureGraph.MinorGridColor = [0.7176 0.2745 1];
            app.TemperatureGraph.XColor = [0.502 0.502 0.502];
            app.TemperatureGraph.YColor = [0.502 0.502 0.502];
            app.TemperatureGraph.ZColor = [0.502 0.502 0.502];
            app.TemperatureGraph.XGrid = 'on';
            app.TemperatureGraph.XMinorGrid = 'on';
            app.TemperatureGraph.YGrid = 'on';
            app.TemperatureGraph.YMinorGrid = 'on';
            app.TemperatureGraph.TitleFontWeight = 'normal';
            app.TemperatureGraph.Layout.Row = [2 9];
            app.TemperatureGraph.Layout.Column = [12 20];

            % Create LightIntensityGaugeLabel
            app.LightIntensityGaugeLabel = uilabel(app.ProcessedDataTabGridLayout);
            app.LightIntensityGaugeLabel.HorizontalAlignment = 'center';
            app.LightIntensityGaugeLabel.VerticalAlignment = 'top';
            app.LightIntensityGaugeLabel.FontSize = 14;
            app.LightIntensityGaugeLabel.FontColor = [0.502 0.502 0.502];
            app.LightIntensityGaugeLabel.Layout.Row = 13;
            app.LightIntensityGaugeLabel.Layout.Column = [4 8];
            app.LightIntensityGaugeLabel.Text = 'Light Intensity';

            % Create LightIntensityGauge
            app.LightIntensityGauge = uigauge(app.ProcessedDataTabGridLayout, 'semicircular');
            app.LightIntensityGauge.Orientation = 'south';
            app.LightIntensityGauge.ScaleDirection = 'counterclockwise';
            app.LightIntensityGauge.BackgroundColor = [0.902 0.902 0.902];
            app.LightIntensityGauge.FontSize = 14;
            app.LightIntensityGauge.FontColor = [0.502 0.502 0.502];
            app.LightIntensityGauge.Layout.Row = [10 12];
            app.LightIntensityGauge.Layout.Column = [4 8];

            % Create TemperatureCLabel
            app.TemperatureCLabel = uilabel(app.ProcessedDataTabGridLayout);
            app.TemperatureCLabel.HorizontalAlignment = 'center';
            app.TemperatureCLabel.VerticalAlignment = 'top';
            app.TemperatureCLabel.FontSize = 14;
            app.TemperatureCLabel.FontColor = [0.502 0.502 0.502];
            app.TemperatureCLabel.Layout.Row = 13;
            app.TemperatureCLabel.Layout.Column = [14 18];
            app.TemperatureCLabel.Text = 'Temperature (C°)';

            % Create TemperatureGauge
            app.TemperatureGauge = uigauge(app.ProcessedDataTabGridLayout, 'semicircular');
            app.TemperatureGauge.Limits = [0 50];
            app.TemperatureGauge.Orientation = 'south';
            app.TemperatureGauge.ScaleDirection = 'counterclockwise';
            app.TemperatureGauge.BackgroundColor = [0.902 0.902 0.902];
            app.TemperatureGauge.FontSize = 14;
            app.TemperatureGauge.FontColor = [0.502 0.502 0.502];
            app.TemperatureGauge.Layout.Row = [10 12];
            app.TemperatureGauge.Layout.Column = [14 18];

            % Create ProcessedDataLabel
            app.ProcessedDataLabel = uilabel(app.ProcessedDataTabGridLayout);
            app.ProcessedDataLabel.BackgroundColor = [0.9412 0.7294 0.2353];
            app.ProcessedDataLabel.HorizontalAlignment = 'center';
            app.ProcessedDataLabel.FontSize = 17;
            app.ProcessedDataLabel.FontColor = [1 1 1];
            app.ProcessedDataLabel.Layout.Row = 1;
            app.ProcessedDataLabel.Layout.Column = [1 21];
            app.ProcessedDataLabel.Text = 'AUTOMATIC CONTROL';

            % Create LightstatusLampLabel
            app.LightstatusLampLabel = uilabel(app.ProcessedDataTabGridLayout);
            app.LightstatusLampLabel.FontSize = 13;
            app.LightstatusLampLabel.FontColor = [0.502 0.502 0.502];
            app.LightstatusLampLabel.Layout.Row = 12;
            app.LightstatusLampLabel.Layout.Column = [2 3];
            app.LightstatusLampLabel.Text = 'Light status';

            % Create LightstatusLamp
            app.LightstatusLamp = uilamp(app.ProcessedDataTabGridLayout);
            app.LightstatusLamp.Layout.Row = 12;
            app.LightstatusLamp.Layout.Column = 1;
            app.LightstatusLamp.Color = [0.8 0.8 0.8];

            % Create PanelsareopenLampLabel
            app.PanelsareopenLampLabel = uilabel(app.ProcessedDataTabGridLayout);
            app.PanelsareopenLampLabel.FontSize = 13;
            app.PanelsareopenLampLabel.FontColor = [0.502 0.502 0.502];
            app.PanelsareopenLampLabel.Layout.Row = 13;
            app.PanelsareopenLampLabel.Layout.Column = [2 4];
            app.PanelsareopenLampLabel.Text = 'Panels are open';

            % Create PanelsareopenLamp
            app.PanelsareopenLamp = uilamp(app.ProcessedDataTabGridLayout);
            app.PanelsareopenLamp.Layout.Row = 13;
            app.PanelsareopenLamp.Layout.Column = 1;
            app.PanelsareopenLamp.Color = [0.8 0.8 0.8];

            % Create LightIntensityTresholdKnobLabel
            app.LightIntensityTresholdKnobLabel = uilabel(app.ProcessedDataTabGridLayout);
            app.LightIntensityTresholdKnobLabel.HorizontalAlignment = 'center';
            app.LightIntensityTresholdKnobLabel.VerticalAlignment = 'top';
            app.LightIntensityTresholdKnobLabel.FontSize = 15;
            app.LightIntensityTresholdKnobLabel.FontColor = [0.502 0.502 0.502];
            app.LightIntensityTresholdKnobLabel.Layout.Row = 13;
            app.LightIntensityTresholdKnobLabel.Layout.Column = [9 11];
            app.LightIntensityTresholdKnobLabel.Text = {'Light Intensity'; 'Treshold'};

            % Create LightIntensityTresholdKnob
            app.LightIntensityTresholdKnob = uiknob(app.ProcessedDataTabGridLayout, 'continuous');
            app.LightIntensityTresholdKnob.ValueChangingFcn = createCallbackFcn(app, @LightIntensityTresholdKnobValueChanging, true);
            app.LightIntensityTresholdKnob.FontColor = [0.502 0.502 0.502];
            app.LightIntensityTresholdKnob.Layout.Row = [10 12];
            app.LightIntensityTresholdKnob.Layout.Column = [9 11];
            app.LightIntensityTresholdKnob.Value = 15;

            % Create TemperatureTresholdLabel
            app.TemperatureTresholdLabel = uilabel(app.ProcessedDataTabGridLayout);
            app.TemperatureTresholdLabel.HorizontalAlignment = 'center';
            app.TemperatureTresholdLabel.VerticalAlignment = 'top';
            app.TemperatureTresholdLabel.FontSize = 15;
            app.TemperatureTresholdLabel.FontColor = [0.502 0.502 0.502];
            app.TemperatureTresholdLabel.Layout.Row = 13;
            app.TemperatureTresholdLabel.Layout.Column = [19 21];
            app.TemperatureTresholdLabel.Text = {'Temperature'; 'Treshold'};

            % Create TempTresholdKnob
            app.TempTresholdKnob = uiknob(app.ProcessedDataTabGridLayout, 'continuous');
            app.TempTresholdKnob.ValueChangingFcn = createCallbackFcn(app, @TempTresholdKnobValueChanging, true);
            app.TempTresholdKnob.FontColor = [0.502 0.502 0.502];
            app.TempTresholdKnob.Layout.Row = [10 12];
            app.TempTresholdKnob.Layout.Column = [19 21];
            app.TempTresholdKnob.Value = 27;

            % Create LightIntensityTresholdLabel
            app.LightIntensityTresholdLabel = uilabel(app.ProcessedDataTabGridLayout);
            app.LightIntensityTresholdLabel.HorizontalAlignment = 'center';
            app.LightIntensityTresholdLabel.VerticalAlignment = 'bottom';
            app.LightIntensityTresholdLabel.FontSize = 13;
            app.LightIntensityTresholdLabel.FontColor = [0.502 0.502 0.502];
            app.LightIntensityTresholdLabel.Layout.Row = 9;
            app.LightIntensityTresholdLabel.Layout.Column = [9 11];
            app.LightIntensityTresholdLabel.Text = '15%';

            % Create TempTresholdLabel
            app.TempTresholdLabel = uilabel(app.ProcessedDataTabGridLayout);
            app.TempTresholdLabel.HorizontalAlignment = 'center';
            app.TempTresholdLabel.VerticalAlignment = 'bottom';
            app.TempTresholdLabel.FontSize = 13;
            app.TempTresholdLabel.FontColor = [0.502 0.502 0.502];
            app.TempTresholdLabel.Layout.Row = 9;
            app.TempTresholdLabel.Layout.Column = [19 21];
            app.TempTresholdLabel.Text = '27°C';

            % Create MonitorSensorDataTab
            app.MonitorSensorDataTab = uitab(app.TabGroup);
            app.MonitorSensorDataTab.Title = 'Monitor Sensor Data';

            % Create RawInputAnalysisTabGridLayout
            app.RawInputAnalysisTabGridLayout = uigridlayout(app.MonitorSensorDataTab);
            app.RawInputAnalysisTabGridLayout.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.RawInputAnalysisTabGridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create LDRRawGraph
            app.LDRRawGraph = uiaxes(app.RawInputAnalysisTabGridLayout);
            title(app.LDRRawGraph, 'LDR Raw Data')
            xlabel(app.LDRRawGraph, 'Time Interval')
            ylabel(app.LDRRawGraph, 'Raw Data')
            app.LDRRawGraph.PlotBoxAspectRatio = [1.20863309352518 1 1];
            app.LDRRawGraph.FontSize = 14;
            app.LDRRawGraph.XLim = [0 50];
            app.LDRRawGraph.YLim = [0 1050];
            app.LDRRawGraph.GridColor = [0.4941 0.1843 0.5569];
            app.LDRRawGraph.GridAlpha = 0.15;
            app.LDRRawGraph.MinorGridColor = [0.7176 0.2745 1];
            app.LDRRawGraph.XColor = [0.502 0.502 0.502];
            app.LDRRawGraph.YColor = [0.502 0.502 0.502];
            app.LDRRawGraph.ZColor = [0.502 0.502 0.502];
            app.LDRRawGraph.XGrid = 'on';
            app.LDRRawGraph.XMinorGrid = 'on';
            app.LDRRawGraph.YGrid = 'on';
            app.LDRRawGraph.YMinorGrid = 'on';
            app.LDRRawGraph.TitleFontWeight = 'normal';
            app.LDRRawGraph.Layout.Row = [2 9];
            app.LDRRawGraph.Layout.Column = [2 10];

            % Create LDRVoltageGauge_2Label
            app.LDRVoltageGauge_2Label = uilabel(app.RawInputAnalysisTabGridLayout);
            app.LDRVoltageGauge_2Label.HorizontalAlignment = 'center';
            app.LDRVoltageGauge_2Label.VerticalAlignment = 'top';
            app.LDRVoltageGauge_2Label.FontSize = 14;
            app.LDRVoltageGauge_2Label.FontColor = [0.502 0.502 0.502];
            app.LDRVoltageGauge_2Label.Layout.Row = 13;
            app.LDRVoltageGauge_2Label.Layout.Column = [3 7];
            app.LDRVoltageGauge_2Label.Text = 'LDR Voltage';

            % Create LDRVoltageGauge
            app.LDRVoltageGauge = uigauge(app.RawInputAnalysisTabGridLayout, 'semicircular');
            app.LDRVoltageGauge.Limits = [0 5];
            app.LDRVoltageGauge.Orientation = 'south';
            app.LDRVoltageGauge.ScaleDirection = 'counterclockwise';
            app.LDRVoltageGauge.BackgroundColor = [0.902 0.902 0.902];
            app.LDRVoltageGauge.FontSize = 14;
            app.LDRVoltageGauge.FontColor = [0.502 0.502 0.502];
            app.LDRVoltageGauge.Layout.Row = [10 12];
            app.LDRVoltageGauge.Layout.Column = [3 7];

            % Create TemperatureCLabel_2
            app.TemperatureCLabel_2 = uilabel(app.RawInputAnalysisTabGridLayout);
            app.TemperatureCLabel_2.HorizontalAlignment = 'center';
            app.TemperatureCLabel_2.VerticalAlignment = 'top';
            app.TemperatureCLabel_2.FontSize = 14;
            app.TemperatureCLabel_2.FontColor = [0.502 0.502 0.502];
            app.TemperatureCLabel_2.Layout.Row = 13;
            app.TemperatureCLabel_2.Layout.Column = [13 17];
            app.TemperatureCLabel_2.Text = 'Temperature (C°)';

            % Create TempVoltageGauge
            app.TempVoltageGauge = uigauge(app.RawInputAnalysisTabGridLayout, 'semicircular');
            app.TempVoltageGauge.Limits = [0 50];
            app.TempVoltageGauge.Orientation = 'south';
            app.TempVoltageGauge.ScaleDirection = 'counterclockwise';
            app.TempVoltageGauge.BackgroundColor = [0.902 0.902 0.902];
            app.TempVoltageGauge.FontSize = 14;
            app.TempVoltageGauge.FontColor = [0.502 0.502 0.502];
            app.TempVoltageGauge.Layout.Row = [10 12];
            app.TempVoltageGauge.Layout.Column = [13 17];

            % Create RawInputAnalysisLabel
            app.RawInputAnalysisLabel = uilabel(app.RawInputAnalysisTabGridLayout);
            app.RawInputAnalysisLabel.BackgroundColor = [0.9412 0.7294 0.2353];
            app.RawInputAnalysisLabel.HorizontalAlignment = 'center';
            app.RawInputAnalysisLabel.FontSize = 17;
            app.RawInputAnalysisLabel.FontColor = [1 1 1];
            app.RawInputAnalysisLabel.Layout.Row = 1;
            app.RawInputAnalysisLabel.Layout.Column = [1 21];
            app.RawInputAnalysisLabel.Text = 'MONITOR SENSOR DATA';

            % Create PinNoKnob_2Label
            app.PinNoKnob_2Label = uilabel(app.RawInputAnalysisTabGridLayout);
            app.PinNoKnob_2Label.HorizontalAlignment = 'center';
            app.PinNoKnob_2Label.VerticalAlignment = 'top';
            app.PinNoKnob_2Label.FontSize = 14;
            app.PinNoKnob_2Label.FontColor = [0.502 0.502 0.502];
            app.PinNoKnob_2Label.Enable = 'off';
            app.PinNoKnob_2Label.Layout.Row = 13;
            app.PinNoKnob_2Label.Layout.Column = [8 10];
            app.PinNoKnob_2Label.Text = 'Pin No';

            % Create LDRRawDataPinNoKnob
            app.LDRRawDataPinNoKnob = uiknob(app.RawInputAnalysisTabGridLayout, 'discrete');
            app.LDRRawDataPinNoKnob.Items = {'A0', 'A1', 'A2', 'A3', 'A4', 'A5'};
            app.LDRRawDataPinNoKnob.ValueChangedFcn = createCallbackFcn(app, @LDRRawDataPinNoKnobValueChanged, true);
            app.LDRRawDataPinNoKnob.Enable = 'off';
            app.LDRRawDataPinNoKnob.FontSize = 14;
            app.LDRRawDataPinNoKnob.FontColor = [0.502 0.502 0.502];
            app.LDRRawDataPinNoKnob.Layout.Row = [10 12];
            app.LDRRawDataPinNoKnob.Layout.Column = [7 11];
            app.LDRRawDataPinNoKnob.Value = 'A0';

            % Create PinNoKnob_3Label
            app.PinNoKnob_3Label = uilabel(app.RawInputAnalysisTabGridLayout);
            app.PinNoKnob_3Label.HorizontalAlignment = 'center';
            app.PinNoKnob_3Label.VerticalAlignment = 'top';
            app.PinNoKnob_3Label.FontSize = 14;
            app.PinNoKnob_3Label.FontColor = [0.502 0.502 0.502];
            app.PinNoKnob_3Label.Enable = 'off';
            app.PinNoKnob_3Label.Layout.Row = 13;
            app.PinNoKnob_3Label.Layout.Column = [18 20];
            app.PinNoKnob_3Label.Text = 'Pin No';

            % Create TemperatureSensorRawDataPinNoKnob
            app.TemperatureSensorRawDataPinNoKnob = uiknob(app.RawInputAnalysisTabGridLayout, 'discrete');
            app.TemperatureSensorRawDataPinNoKnob.Items = {'D2', 'D3', 'D4', 'D5', 'D6', 'D7'};
            app.TemperatureSensorRawDataPinNoKnob.ValueChangedFcn = createCallbackFcn(app, @TemperatureSensorRawDataPinNoKnobValueChanged, true);
            app.TemperatureSensorRawDataPinNoKnob.Enable = 'off';
            app.TemperatureSensorRawDataPinNoKnob.FontSize = 14;
            app.TemperatureSensorRawDataPinNoKnob.FontColor = [0.502 0.502 0.502];
            app.TemperatureSensorRawDataPinNoKnob.Layout.Row = [10 12];
            app.TemperatureSensorRawDataPinNoKnob.Layout.Column = [17 21];
            app.TemperatureSensorRawDataPinNoKnob.Value = 'D2';

            % Create TempRawGraph
            app.TempRawGraph = uiaxes(app.RawInputAnalysisTabGridLayout);
            title(app.TempRawGraph, 'Temperature - Time')
            xlabel(app.TempRawGraph, 'Time Interval')
            ylabel(app.TempRawGraph, 'Temperature (C°)')
            app.TempRawGraph.PlotBoxAspectRatio = [1.20863309352518 1 1];
            app.TempRawGraph.FontSize = 14;
            app.TempRawGraph.XLim = [0 50];
            app.TempRawGraph.YLim = [0 50];
            app.TempRawGraph.ColorOrder = [0 0.4471 0.7412;0.851 0.3255 0.098;0.9294 0.6941 0.1255;0.4941 0.1843 0.5569;0.4667 0.6745 0.1882;0.302 0.7451 0.9333;0.6353 0.0784 0.1843];
            app.TempRawGraph.GridColor = [0.4941 0.1843 0.5569];
            app.TempRawGraph.GridAlpha = 0.15;
            app.TempRawGraph.MinorGridColor = [0.7176 0.2745 1];
            app.TempRawGraph.XColor = [0.502 0.502 0.502];
            app.TempRawGraph.YColor = [0.502 0.502 0.502];
            app.TempRawGraph.ZColor = [0.502 0.502 0.502];
            app.TempRawGraph.XGrid = 'on';
            app.TempRawGraph.XMinorGrid = 'on';
            app.TempRawGraph.YGrid = 'on';
            app.TempRawGraph.YMinorGrid = 'on';
            app.TempRawGraph.TitleFontWeight = 'normal';
            app.TempRawGraph.Layout.Row = [2 9];
            app.TempRawGraph.Layout.Column = [12 20];

            % Create TestDebugTab
            app.TestDebugTab = uitab(app.TabGroup);
            app.TestDebugTab.Title = 'Test & Debug';

            % Create TestDebugTabGridLayout
            app.TestDebugTabGridLayout = uigridlayout(app.TestDebugTab);
            app.TestDebugTabGridLayout.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.TestDebugTabGridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create TestDebugLabel
            app.TestDebugLabel = uilabel(app.TestDebugTabGridLayout);
            app.TestDebugLabel.BackgroundColor = [0.9412 0.7294 0.2353];
            app.TestDebugLabel.HorizontalAlignment = 'center';
            app.TestDebugLabel.FontSize = 17;
            app.TestDebugLabel.FontColor = [1 1 1];
            app.TestDebugLabel.Layout.Row = 1;
            app.TestDebugLabel.Layout.Column = [1 22];
            app.TestDebugLabel.Text = 'TEST & DEBUG';

            % Create TestAnalogPinsBlock
            app.TestAnalogPinsBlock = uilabel(app.TestDebugTabGridLayout);
            app.TestAnalogPinsBlock.BackgroundColor = [0.8 0.8 0.8];
            app.TestAnalogPinsBlock.FontColor = [0.8 0.8 0.8];
            app.TestAnalogPinsBlock.Layout.Row = [3 8];
            app.TestAnalogPinsBlock.Layout.Column = [1 11];
            app.TestAnalogPinsBlock.Text = '';

            % Create PinNoKnobLabel
            app.PinNoKnobLabel = uilabel(app.TestDebugTabGridLayout);
            app.PinNoKnobLabel.HorizontalAlignment = 'center';
            app.PinNoKnobLabel.VerticalAlignment = 'bottom';
            app.PinNoKnobLabel.FontSize = 15;
            app.PinNoKnobLabel.FontColor = [0.502 0.502 0.502];
            app.PinNoKnobLabel.Layout.Row = 3;
            app.PinNoKnobLabel.Layout.Column = [2 6];
            app.PinNoKnobLabel.Text = 'Pin No';

            % Create PinNoKnob
            app.PinNoKnob = uiknob(app.TestDebugTabGridLayout, 'discrete');
            app.PinNoKnob.Items = {'0', '1', '2', '3', '4', '5'};
            app.PinNoKnob.ValueChangedFcn = createCallbackFcn(app, @PinNoKnobValueChanged, true);
            app.PinNoKnob.FontColor = [0.502 0.502 0.502];
            app.PinNoKnob.Layout.Row = [4 6];
            app.PinNoKnob.Layout.Column = [2 6];
            app.PinNoKnob.Value = '0';

            % Create VoltageGaugeLabel
            app.VoltageGaugeLabel = uilabel(app.TestDebugTabGridLayout);
            app.VoltageGaugeLabel.HorizontalAlignment = 'center';
            app.VoltageGaugeLabel.VerticalAlignment = 'bottom';
            app.VoltageGaugeLabel.FontSize = 15;
            app.VoltageGaugeLabel.FontColor = [0.502 0.502 0.502];
            app.VoltageGaugeLabel.Layout.Row = 3;
            app.VoltageGaugeLabel.Layout.Column = [7 10];
            app.VoltageGaugeLabel.Text = 'Voltage';

            % Create TestAnalogVoltageGauge
            app.TestAnalogVoltageGauge = uigauge(app.TestDebugTabGridLayout, 'circular');
            app.TestAnalogVoltageGauge.Limits = [0 1000];
            app.TestAnalogVoltageGauge.BackgroundColor = [0.902 0.902 0.902];
            app.TestAnalogVoltageGauge.FontColor = [0.502 0.502 0.502];
            app.TestAnalogVoltageGauge.Layout.Row = [4 7];
            app.TestAnalogVoltageGauge.Layout.Column = [7 10];

            % Create TestAnalogPinsSwitch
            app.TestAnalogPinsSwitch = uiswitch(app.TestDebugTabGridLayout, 'slider');
            app.TestAnalogPinsSwitch.ValueChangedFcn = createCallbackFcn(app, @TestAnalogPinsSwitchValueChanged, true);
            app.TestAnalogPinsSwitch.FontColor = [0.502 0.502 0.502];
            app.TestAnalogPinsSwitch.Layout.Row = 7;
            app.TestAnalogPinsSwitch.Layout.Column = [3 5];

            % Create TestAnalogPinsLabel
            app.TestAnalogPinsLabel = uilabel(app.TestDebugTabGridLayout);
            app.TestAnalogPinsLabel.BackgroundColor = [0.651 0.651 0.651];
            app.TestAnalogPinsLabel.HorizontalAlignment = 'center';
            app.TestAnalogPinsLabel.FontSize = 17;
            app.TestAnalogPinsLabel.FontColor = [0.9412 0.9412 0.9412];
            app.TestAnalogPinsLabel.Layout.Row = 2;
            app.TestAnalogPinsLabel.Layout.Column = [1 11];
            app.TestAnalogPinsLabel.Text = 'Test the Analog Pins';

            % Create TestStepMotorBlock
            app.TestStepMotorBlock = uilabel(app.TestDebugTabGridLayout);
            app.TestStepMotorBlock.BackgroundColor = [0.8 0.8 0.8];
            app.TestStepMotorBlock.FontColor = [0.8 0.8 0.8];
            app.TestStepMotorBlock.Layout.Row = [3 8];
            app.TestStepMotorBlock.Layout.Column = [12 22];
            app.TestStepMotorBlock.Text = '';

            % Create TestStepMotorLabel
            app.TestStepMotorLabel = uilabel(app.TestDebugTabGridLayout);
            app.TestStepMotorLabel.BackgroundColor = [0.651 0.651 0.651];
            app.TestStepMotorLabel.HorizontalAlignment = 'center';
            app.TestStepMotorLabel.FontSize = 17;
            app.TestStepMotorLabel.FontColor = [0.9412 0.9412 0.9412];
            app.TestStepMotorLabel.Layout.Row = 2;
            app.TestStepMotorLabel.Layout.Column = [12 22];
            app.TestStepMotorLabel.Text = 'Test the Servo Motor';

            % Create RotateStepMotor
            app.RotateStepMotor = uiknob(app.TestDebugTabGridLayout, 'continuous');
            app.RotateStepMotor.Limits = [0 180];
            app.RotateStepMotor.ValueChangingFcn = createCallbackFcn(app, @RotateStepMotorValueChanging, true);
            app.RotateStepMotor.FontColor = [0.502 0.502 0.502];
            app.RotateStepMotor.Layout.Row = [4 8];
            app.RotateStepMotor.Layout.Column = [15 19];

            % Create RotateStepMotorLabel
            app.RotateStepMotorLabel = uilabel(app.TestDebugTabGridLayout);
            app.RotateStepMotorLabel.HorizontalAlignment = 'center';
            app.RotateStepMotorLabel.VerticalAlignment = 'bottom';
            app.RotateStepMotorLabel.FontSize = 15;
            app.RotateStepMotorLabel.FontColor = [0.502 0.502 0.502];
            app.RotateStepMotorLabel.Layout.Row = 3;
            app.RotateStepMotorLabel.Layout.Column = [15 19];
            app.RotateStepMotorLabel.Text = 'Rotate the Servo Motor';

            % Create ControlPWMVoltageBlock
            app.ControlPWMVoltageBlock = uilabel(app.TestDebugTabGridLayout);
            app.ControlPWMVoltageBlock.BackgroundColor = [0.902 0.902 0.902];
            app.ControlPWMVoltageBlock.HorizontalAlignment = 'center';
            app.ControlPWMVoltageBlock.FontSize = 17;
            app.ControlPWMVoltageBlock.FontColor = [0.9412 0.9412 0.9412];
            app.ControlPWMVoltageBlock.Layout.Row = [9 13];
            app.ControlPWMVoltageBlock.Layout.Column = [1 11];
            app.ControlPWMVoltageBlock.Text = '';

            % Create TestLEDsLabel
            app.TestLEDsLabel = uilabel(app.TestDebugTabGridLayout);
            app.TestLEDsLabel.BackgroundColor = [0.851 0.851 0.851];
            app.TestLEDsLabel.HorizontalAlignment = 'center';
            app.TestLEDsLabel.FontSize = 17;
            app.TestLEDsLabel.FontColor = [0.502 0.502 0.502];
            app.TestLEDsLabel.Layout.Row = 9;
            app.TestLEDsLabel.Layout.Column = [1 11];
            app.TestLEDsLabel.Text = 'Test LEDs';

            % Create TestBuiltinLedBlock
            app.TestBuiltinLedBlock = uilabel(app.TestDebugTabGridLayout);
            app.TestBuiltinLedBlock.BackgroundColor = [0.902 0.902 0.902];
            app.TestBuiltinLedBlock.HorizontalAlignment = 'center';
            app.TestBuiltinLedBlock.FontSize = 17;
            app.TestBuiltinLedBlock.FontColor = [0.9412 0.9412 0.9412];
            app.TestBuiltinLedBlock.Layout.Row = [9 13];
            app.TestBuiltinLedBlock.Layout.Column = [12 22];
            app.TestBuiltinLedBlock.Text = '';

            % Create TestBuiltinLedLabel
            app.TestBuiltinLedLabel = uilabel(app.TestDebugTabGridLayout);
            app.TestBuiltinLedLabel.BackgroundColor = [0.851 0.851 0.851];
            app.TestBuiltinLedLabel.HorizontalAlignment = 'center';
            app.TestBuiltinLedLabel.FontSize = 17;
            app.TestBuiltinLedLabel.FontColor = [0.502 0.502 0.502];
            app.TestBuiltinLedLabel.Layout.Row = 9;
            app.TestBuiltinLedLabel.Layout.Column = [12 22];
            app.TestBuiltinLedLabel.Text = 'Test the Built-in Led & Buzzer';

            % Create TestBuiltinLedStatusIndicator
            app.TestBuiltinLedStatusIndicator = uibutton(app.TestDebugTabGridLayout, 'push');
            app.TestBuiltinLedStatusIndicator.BackgroundColor = [0.8 0.8 0.8];
            app.TestBuiltinLedStatusIndicator.Layout.Row = 11;
            app.TestBuiltinLedStatusIndicator.Layout.Column = 21;
            app.TestBuiltinLedStatusIndicator.Text = '';

            % Create TestBuiltinLedSwitch
            app.TestBuiltinLedSwitch = uiswitch(app.TestDebugTabGridLayout, 'slider');
            app.TestBuiltinLedSwitch.ValueChangedFcn = createCallbackFcn(app, @TestBuiltinLedSwitchValueChanged, true);
            app.TestBuiltinLedSwitch.FontColor = [0.502 0.502 0.502];
            app.TestBuiltinLedSwitch.Layout.Row = 11;
            app.TestBuiltinLedSwitch.Layout.Column = [16 18];

            % Create TestBuiltinLed_StatusLabel
            app.TestBuiltinLed_StatusLabel = uilabel(app.TestDebugTabGridLayout);
            app.TestBuiltinLed_StatusLabel.HorizontalAlignment = 'right';
            app.TestBuiltinLed_StatusLabel.FontSize = 15;
            app.TestBuiltinLed_StatusLabel.FontColor = [0.502 0.502 0.502];
            app.TestBuiltinLed_StatusLabel.Layout.Row = 11;
            app.TestBuiltinLed_StatusLabel.Layout.Column = [19 20];
            app.TestBuiltinLed_StatusLabel.Text = 'Status';

            % Create BuzzerButton
            app.BuzzerButton = uibutton(app.TestDebugTabGridLayout, 'push');
            app.BuzzerButton.ButtonPushedFcn = createCallbackFcn(app, @BuzzerButtonPushed, true);
            app.BuzzerButton.BackgroundColor = [0.8 0.8 0.8];
            app.BuzzerButton.FontSize = 15;
            app.BuzzerButton.FontColor = [0.502 0.502 0.502];
            app.BuzzerButton.Layout.Row = 11;
            app.BuzzerButton.Layout.Column = [13 14];
            app.BuzzerButton.Text = 'Buzzer';

            % Create ControltheLEDLabel
            app.ControltheLEDLabel = uilabel(app.TestDebugTabGridLayout);
            app.ControltheLEDLabel.HorizontalAlignment = 'center';
            app.ControltheLEDLabel.VerticalAlignment = 'bottom';
            app.ControltheLEDLabel.FontSize = 14;
            app.ControltheLEDLabel.FontColor = [0.502 0.502 0.502];
            app.ControltheLEDLabel.Layout.Row = 10;
            app.ControltheLEDLabel.Layout.Column = [16 18];
            app.ControltheLEDLabel.Text = 'Control the LED';

            % Create LightStatusSwitch
            app.LightStatusSwitch = uiswitch(app.TestDebugTabGridLayout, 'rocker');
            app.LightStatusSwitch.ValueChangedFcn = createCallbackFcn(app, @LightStatusSwitchValueChanged, true);
            app.LightStatusSwitch.FontColor = [0.502 0.502 0.502];
            app.LightStatusSwitch.Layout.Row = [11 13];
            app.LightStatusSwitch.Layout.Column = 3;

            % Create LightStatusButton
            app.LightStatusButton = uibutton(app.TestDebugTabGridLayout, 'push');
            app.LightStatusButton.BackgroundColor = [0.8 0.8 0.8];
            app.LightStatusButton.FontSize = 15;
            app.LightStatusButton.FontColor = [0.502 0.502 0.502];
            app.LightStatusButton.Layout.Row = 10;
            app.LightStatusButton.Layout.Column = [2 4];
            app.LightStatusButton.Text = 'Light Status';

            % Create PanelsOpenButton
            app.PanelsOpenButton = uibutton(app.TestDebugTabGridLayout, 'push');
            app.PanelsOpenButton.BackgroundColor = [0.8 0.8 0.8];
            app.PanelsOpenButton.FontSize = 15;
            app.PanelsOpenButton.FontColor = [0.502 0.502 0.502];
            app.PanelsOpenButton.Layout.Row = 10;
            app.PanelsOpenButton.Layout.Column = [5 7];
            app.PanelsOpenButton.Text = 'Panels Open';

            % Create PanelsOpenSwitch
            app.PanelsOpenSwitch = uiswitch(app.TestDebugTabGridLayout, 'rocker');
            app.PanelsOpenSwitch.ValueChangedFcn = createCallbackFcn(app, @PanelsOpenSwitchValueChanged, true);
            app.PanelsOpenSwitch.FontColor = [0.502 0.502 0.502];
            app.PanelsOpenSwitch.Layout.Row = [11 13];
            app.PanelsOpenSwitch.Layout.Column = 6;

            % Create PanelsMovingSwitch
            app.PanelsMovingSwitch = uiswitch(app.TestDebugTabGridLayout, 'rocker');
            app.PanelsMovingSwitch.ValueChangedFcn = createCallbackFcn(app, @PanelsMovingSwitchValueChanged, true);
            app.PanelsMovingSwitch.FontColor = [0.502 0.502 0.502];
            app.PanelsMovingSwitch.Layout.Row = [11 13];
            app.PanelsMovingSwitch.Layout.Column = 9;

            % Create PanelsMovingButton
            app.PanelsMovingButton = uibutton(app.TestDebugTabGridLayout, 'push');
            app.PanelsMovingButton.BackgroundColor = [0.8 0.8 0.8];
            app.PanelsMovingButton.FontSize = 15;
            app.PanelsMovingButton.FontColor = [0.502 0.502 0.502];
            app.PanelsMovingButton.Layout.Row = 10;
            app.PanelsMovingButton.Layout.Column = [8 10];
            app.PanelsMovingButton.Text = 'Panels Moving';

            % Create ModeOneTwo
            app.ModeOneTwo = uiswitch(app.MainGridLayout, 'toggle');
            app.ModeOneTwo.Items = {'Off', '1'};
            app.ModeOneTwo.ValueChangedFcn = createCallbackFcn(app, @ModeOneTwoValueChanged, true);
            app.ModeOneTwo.FontSize = 15;
            app.ModeOneTwo.FontColor = [0.502 0.502 0.502];
            app.ModeOneTwo.Layout.Row = [3 5];
            app.ModeOneTwo.Layout.Column = 28;

            % Create OnOffSwitch
            app.OnOffSwitch = uiswitch(app.MainGridLayout, 'toggle');
            app.OnOffSwitch.ValueChangedFcn = createCallbackFcn(app, @OnOffSwitchValueChanged, true);
            app.OnOffSwitch.FontSize = 15;
            app.OnOffSwitch.FontColor = [0.502 0.502 0.502];
            app.OnOffSwitch.Layout.Row = [3 5];
            app.OnOffSwitch.Layout.Column = 27;

            % Create ModeThreeFour
            app.ModeThreeFour = uiswitch(app.MainGridLayout, 'toggle');
            app.ModeThreeFour.Items = {'Off', '2'};
            app.ModeThreeFour.ValueChangedFcn = createCallbackFcn(app, @ModeThreeFourValueChanged, true);
            app.ModeThreeFour.FontSize = 15;
            app.ModeThreeFour.FontColor = [0.502 0.502 0.502];
            app.ModeThreeFour.Layout.Row = [3 5];
            app.ModeThreeFour.Layout.Column = 29;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Data_Acquisition_MATLAB_Code

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end