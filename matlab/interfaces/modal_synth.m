function varargout = modal_synth(varargin)
% MODAL_SYNTH MATLAB code for modal_synth.fig
%      MODAL_SYNTH, by itself, creates a new MODAL_SYNTH or raises the existing
%      singleton*.
%
%      H = MODAL_SYNTH returns the handle to a new MODAL_SYNTH or the handle to
%      the existing singleton*.
%
%      MODAL_SYNTH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODAL_SYNTH.M with the given input arguments.
%
%      MODAL_SYNTH('Property','Value',...) creates a new MODAL_SYNTH or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before modal_synth_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to modal_synth_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help modal_synth

% Last Modified by GUIDE v2.5 01-Feb-2016 02:06:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @modal_synth_OpeningFcn, ...
                   'gui_OutputFcn',  @modal_synth_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

end

% --- Executes just before modal_synth is made visible.
function modal_synth_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to modal_synth (see VARARGIN)

project_path = genpath('../');
addpath(project_path);

% Choose default command line output for modal_synth
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes modal_synth wait for user response (see UIRESUME)
% uiwait(handles.figure1);

end

% --- Outputs from this function are returned to the command line.
function varargout = modal_synth_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

end

% --- Executes on button press in calculate_button.
function calculate_button_Callback(hObject, eventdata, handles)
% hObject    handle to calculate_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.string.params.x_excitation

[ modal_displacement_synthesis_v, modal_speed_synthesis_v, ...
    ~ ] = F_full_modal_synthesis( ...
        'string_name', handles.string.name, ...
        'duration_s', handles.synthesis.duration_s, ...
        'Fs_HZ', handles.synthesis.Fs_Hz, ...
        'string_parameters', handles.string.params, ...
        'string_modes_number', handles.string.modes_number, ...
        'body_modes_number', handles.body.modes_number, ...
        'body_measure_number', handles.body.measure, ...
        'excitation_type', handles.synthesis.excitation_type);
 
  handles.synthesis.displacement_v = modal_displacement_synthesis_v;
  handles.synthesis.speed_v = modal_speed_synthesis_v;
  
  plotted_v = modal_displacement_synthesis_v;
%   plotted_v = modal_speed_synthesis_v;
  
%   plotted_v = plotted_v/max(abs(plotted_v));  % Normalize plotted sample
    

  plot_Fs_Hz = handles.synthesis.Fs_Hz;
  
  axes(handles.temporal_fig)
    dt_s = 1/plot_Fs_Hz;
    time_s_v = (0:length(plotted_v)-1) * dt_s;
    plot(time_s_v, plotted_v);
    xlabel('Time (s)');
    ylabel('Amplitude');
    title('Time-domain signal');
  
  axes(handles.spectrum_fig)
  
    N_fft = 2^19;
    sample_duration_n = 1 * plot_Fs_Hz;
    sample_start_n = 0.1 * plot_Fs_Hz;
    sample_v = plotted_v(sample_start_n:sample_start_n+sample_duration_n);
    plotted_fft_v = fft(sample_v, N_fft);
    dF_Hz = plot_Fs_Hz/N_fft;
    fft_freqs_Hz_v = (0:N_fft-1)*dF_Hz;
    f_max_plot_Hz = 6000;
    f_max_plot_n = floor(f_max_plot_Hz / dF_Hz);
    plot(fft_freqs_Hz_v(1:f_max_plot_n), ...
        db(plotted_fft_v(1:f_max_plot_n)));
    xlabel('Frequency (Hz)');
    ylabel('Amplitude (dB)');
    title('Spectrum');
    
  guidata(hObject, handles);
end
  
% --- Executes on button press in reset_button.
function reset_button_Callback(hObject, eventdata, handles)
% hObject    handle to reset_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(gcbf, handles, true);
end

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset_button flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset_button the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

clear handles.temporal_fig;
clear handles.spectrum_fig;

string_name = 'E2';
string_modes_number = 80;
body_modes_number = 10;
body_measure_selection = 3;
string_params = F_compute_full_string_parameters(...
    string_name, string_modes_number);

Fs_Hz = 16000;
duration_s = 5;

excitation_type = 'finger';
excitation_position_ratio = 0.9;
excitation_width = 0.01;  % 1cm wide finger

handles.string.name = string_name;
handles.string.params = string_params;
handles.string.params.excitation_width = excitation_width;

excitation_position = excitation_position_ratio * string_params.length;
handles.string.params.excitation_position = excitation_position;

handles.string.modes_number = string_modes_number;
handles.body.modes_number = body_modes_number;
handles.body.measure = body_measure_selection;

handles.synthesis.duration_s = duration_s;
handles.synthesis.Fs_Hz = Fs_Hz;
handles.synthesis.excitation_type = excitation_type;

set(handles.length_edit, 'String', ...
    num2str(handles.string.params.length, 4));
set(handles.tension_edit, 'String', ...
    num2str(handles.string.params.tension, 4));
set(handles.bending_stiffness_edit, 'String', ...
    num2str(handles.string.params.bending_stiffness, 4));
set(handles.linear_mass_edit, 'String', ...
    num2str(handles.string.params.linear_mass, 4));

set(handles.excitation_width_edit, 'String', ...
    num2str(handles.string.params.excitation_width, 4));

set(handles.string_modes_number_edit, 'String', ...
    int2str(handles.string.modes_number));
set(handles.body_modes_number_edit, 'String', ...
    int2str(handles.body.modes_number));

[ ~, name_index ] = ismember(handles.string.name, ...
    cellstr(get(handles.string_name_popup, 'String')));
set(handles.string_name_popup, 'Value', name_index);

set(handles.excitation_position_edit, 'String', ...
    num2str(excitation_position,4));
set(handles.excitation_position_slide, 'Value', ...
    excitation_position_ratio);
[ ~, excitation_type_index ] = ismember(...
    handles.synthesis.excitation_type, ...
    cellstr(get(handles.excitation_type_popup, 'String')));
set(handles.excitation_type_popup, 'Value', excitation_type_index);

set(handles.Fs_Hz_edit, 'String', int2str(handles.synthesis.Fs_Hz));
set(handles.duration_s_edit, 'String', ...
    int2str(handles.synthesis.duration_s));

% Choose default command line output for modal_synth
handles.output = fig_handle;

% Update handles structure
guidata(handles.figure1, handles);

end

% --- Executes on button press in play_displacement_button.
function play_displacement_button_Callback(hObject, eventdata, handles)
% hObject    handle to play_displacement_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

displacement_v = handles.synthesis.displacement_v;
Fs_Hz = handles.synthesis.Fs_Hz;

soundsc(displacement_v, Fs_Hz);

end

% --- Executes on selection change in measure_select_list.
function measure_select_list_Callback(hObject, eventdata, handles)
% hObject    handle to measure_select_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns measure_select_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from measure_select_list

contents = cellstr(get(hObject,'String'));
handles.body.measure = str2double(contents{get(hObject,'Value')}(end));

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function measure_select_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to measure_select_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function string_modes_number_edit_Callback(hObject, eventdata, handles)
% hObject    handle to string_modes_number_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of string_modes_number_edit as text
%        str2double(get(hObject,'String')) returns contents of string_modes_number_edit as a double

string_modes_number = str2double(get(hObject, 'String'));

handles.string.modes_number = string_modes_number;

%% Update modes-number related string parameters
string_natural_frequencies_rad_v = ...
    F_compute_string_natural_frequencies_rad_v( handles.string.params, ...
    string_modes_number ); 

handles.string.params.natural_frequencies_rad_v = ...
    string_natural_frequencies_rad_v;

string_loss_factors_v = F_compute_string_loss_factors_v( ...
    handles.string.params, string_modes_number ); 
    
handles.string.params.loss_factors_v = string_loss_factors_v ;

guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function string_modes_number_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to string_modes_number_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function body_modes_number_edit_Callback(hObject, eventdata, handles)
% hObject    handle to body_modes_number_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of body_modes_number_edit as text
%        str2double(get(hObject,'String')) returns contents of body_modes_number_edit as a double

body_modes_number = str2double(get(hObject, 'String'));

handles.body.modes_number = body_modes_number;

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function body_modes_number_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to body_modes_number_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- Executes on slider movement.
function excitation_position_slide_Callback(hObject, eventdata, handles)
% hObject    handle to excitation_position_slide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

excitation_position_ratio = get(hObject, 'Value');

excitation_position = excitation_position_ratio * ...
    handles.string.params.length;

handles.string.params.x_excitation = excitation_position;

set(handles.excitation_position_edit, 'String', ...
    num2str(excitation_position,4));

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function excitation_position_slide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to excitation_position_slide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

end

function Fs_Hz_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Fs_Hz_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Fs_Hz_edit as text
%        str2double(get(hObject,'String')) returns contents of Fs_Hz_edit as a double

Fs_Hz = str2double(get(hObject, 'String'));

handles.synthesis.Fs_Hz = Fs_Hz;

guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function Fs_Hz_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fs_Hz_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function duration_s_edit_Callback(hObject, eventdata, handles)
% hObject    handle to duration_s_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of duration_s_edit as text
%        str2double(get(hObject,'String')) returns contents of duration_s_edit as a double

duration_s = str2double(get(hObject, 'String'));

handles.synthesis.duration_s = duration_s;

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function duration_s_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duration_s_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- Executes on selection change in excitation_type_popup.
function excitation_type_popup_Callback(hObject, eventdata, handles)
% hObject    handle to excitation_type_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns excitation_type_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from excitation_type_popup

contents = cellstr(get(hObject,'String'));
excitation_type = contents{get(hObject,'Value')};

handles.synthesis.excitation_type = excitation_type;

if strcmp(excitation_type, 'dirac')
    set(handles.excitation_width_edit, 'Enable', 'off');
else
    set(handles.excitation_width_edit, 'Enable', 'on');
end

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function excitation_type_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to excitation_type_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- Executes on selection change in string_name_popup.
function string_name_popup_Callback(hObject, eventdata, handles)
% hObject    handle to string_name_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns string_name_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from string_name_popup

contents = cellstr(get(hObject,'String'));
string_name = contents{get(hObject,'Value')};

handles.string.name = string_name;

guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function string_name_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to string_name_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function length_edit_Callback(hObject, eventdata, handles)
% hObject    handle to length_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of length_edit as text
%        str2double(get(hObject,'String')) returns contents of length_edit as a double

string_length = str2double(get(hObject,'String'));

handles.string.params.length = string_length;

guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function length_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to length_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function tension_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tension_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tension_edit as text
%        str2double(get(hObject,'String')) returns contents of tension_edit as a double

string_tension = str2double(get(hObject,'String'));

handles.string.params.tension = string_tension;

guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function tension_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tension_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function linear_mass_edit_Callback(hObject, eventdata, handles)
% hObject    handle to linear_mass_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of linear_mass_edit as text
%        str2double(get(hObject,'String')) returns contents of linear_mass_edit as a double

linear_mass = str2double(get(hObject,'String'));

handles.string.params.linear_mass = linear_mass;

guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function linear_mass_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linear_mass_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function bending_stiffness_edit_Callback(hObject, eventdata, handles)
% hObject    handle to bending_stiffness_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bending_stiffness_edit as text
%        str2double(get(hObject,'String')) returns contents of bending_stiffness_edit as a double

bending_stiffness = str2double(get(hObject,'String'));

handles.string.params.bending_stiffness = bending_stiffness;

guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function bending_stiffness_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bending_stiffness_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- Executes on button press in load_string_defaults_button.
function load_string_defaults_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_string_defaults_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[ string_params ] = F_compute_full_string_parameters(...
    handles.string.name, handles.string.modes_number);

handles.string.params = string_params;

set(handles.length_edit, 'String', ...
    num2str(handles.string.params.length, 4));
set(handles.tension_edit, 'String', ...
    num2str(handles.string.params.tension, 4));
set(handles.bending_stiffness_edit, 'String', ...
    num2str(handles.string.params.bending_stiffness, 4));
set(handles.linear_mass_edit, 'String', ...
    num2str(handles.string.params.linear_mass, 4));

guidata(hObject, handles);
end


% --- Executes on button press in play_speed_button.
function play_speed_button_Callback(hObject, eventdata, handles)
% hObject    handle to play_speed_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

speed_v = handles.synthesis.speed_v;
Fs_Hz = handles.synthesis.Fs_Hz;

soundsc(speed_v, Fs_Hz);
end



function excitation_position_edit_Callback(hObject, eventdata, handles)
% hObject    handle to excitation_position_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of excitation_position_edit as text
%        str2double(get(hObject,'String')) returns contents of excitation_position_edit as a double

excitation_position = str2double(get(hObject, 'String'));

handles.string.params.x_excitation = excitation_position;

excitation_position_ratio = excitation_position ./ ...
    handles.string.params.length
set(handles.excitation_position_slide, 'Value', excitation_position_ratio);

guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function excitation_position_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to excitation_position_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function excitation_width_edit_Callback(hObject, eventdata, handles)
% hObject    handle to excitation_width_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of excitation_width_edit as text
%        str2double(get(hObject,'String')) returns contents of excitation_width_edit as a double

excitation_width = str2double(get(hObject, 'String'));

handles.string.params.excitation_width = excitation_width;

guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function excitation_width_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to excitation_width_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
