function varargout = frf_gui(varargin)
% FRF_GUI MATLAB code for frf_gui.fig
%      FRF_GUI, by itself, creates a new FRF_GUI or raises the existing
%      singleton*.
%
%      H = FRF_GUI returns the handle to a new FRF_GUI or the handle to
%      the existing singleton*.
%
%      FRF_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FRF_GUI.M with the given input arguments.
%
%      FRF_GUI('Property','Value',...) creates a new FRF_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before frf_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to frf_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help frf_gui

% Last Modified by GUIDE v2.5 01-Feb-2016 05:08:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @frf_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @frf_gui_OutputFcn, ...
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


% --- Executes just before frf_gui is made visible.
function frf_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to frf_gui (see VARARGIN)

% Choose default command line output for frf_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%initialize_gui(handles);

% UIWAIT makes frf_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = frf_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in play1.
function play1_Callback(hObject, eventdata, handles)
% hObject    handle to play1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
soundsc(handles.frfdata.sound_frf,25600);

% --- Executes on button press in compute1.
function compute1_Callback(hObject, eventdata, handles)
% hObject    handle to compute1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear handles.axes5

handles.frfdata = refresh_frf_data(handles);
%disp(handles.frfdata);
[handles.frfdata.sound_frf ,G,Y11_b,H,Z] = F_FRF_synthesis(handles.frfdata, 0);
guidata(handles.figure1, handles);

% Plotting
Fs = 25600; Nfft = 2^19;
f = [0:Nfft-1]*Fs/Nfft;
f = f(1:Nfft/2+1);
axes(handles.axes5);
clear handles.axes5
plot(f,db(G)), xlim([0 Fs/2]);
%hold on
%plot(f,db(1./(Z+eps))), xlim([0 Fs/2]);
%plot(f,(Z)), xlim([f1 f2]), 
%plot(f,db(Y11_b)), xlim([0 Fs/2])
%legend('H', 'Y_{string}', 'Y_{body}')
legend('G')
%legend('H', 'Y_{string}', 'Y_{body}')
title(['FRF used for synthesis']), xlabel('Frequency(Hz)'), ylabel('Amplitude') %Gain(dB)')
%hold off

% axes(handles.axes6);
% plot([0:Nfft-1]*Fs/Nfft, db(fft( handles.frfdata.sound_frf, Nfft )));
% title(['Spectrum of the synthesized sound']), xlabel('Frequency(Hz)'), ylabel('Gain(dB)')
% xlim([0 Fs/2]);
% 
axes(handles.axes6);
plot([0:length(handles.frfdata.sound_frf)-1]/Fs, handles.frfdata.sound_frf);
title(['Synthesized sound']), xlabel('Time(s)'), ylabel('Amplitude')

% --- Executes on selection change in selectmeasure.
function selectmeasure_Callback(hObject, eventdata, handles)
% hObject    handle to selectmeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp(hObject);

% Hints: contents = cellstr(get(hObject,'String')) returns selectmeasure contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectmeasure
%s.path_measure_mat_str = F_select_measure(contents{get(hObject,'Value')});

% --- Executes during object creation, after setting all properties.
function selectmeasure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectmeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in selectlisteningmode.
function selectlisteningmode_Callback(hObject, eventdata, handles)
% hObject    handle to selectlisteningmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectlisteningmode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectlisteningmode
%s.listening_mode = contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function selectlisteningmode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectlisteningmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in stringnote.
function stringnote_Callback(hObject, eventdata, handles)
% hObject    handle to stringnote (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns stringnote contents as cell array
%        contents{get(hObject,'Value')} returns selected item from stringnote

% --- Executes during object creation, after setting all properties.
function stringnote_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stringnote (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in excitationtype.
function excitationtype_Callback(hObject, eventdata, handles)
% hObject    handle to excitationtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns excitationtype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from excitationtype
%s.excitation_type = contents(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function excitationtype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to excitationtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function modesnumber_Callback(hObject, eventdata, handles)
% hObject    handle to modesnumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of modesnumber as text
%        str2double(get(hObject,'String')) returns contents of modesnumber as a double
%s.string_modes_number = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function modesnumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modesnumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function excitation_x_Callback(hObject, eventdata, handles)
% hObject    handle to excitation_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of excitation_x as text
%        str2double(get(hObject,'String')) returns contents of excitation_x as a double
%s.excitation_bridge_dist = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function excitation_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to excitation_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function excitation_length_Callback(hObject, eventdata, handles)
% hObject    handle to excitation_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of excitation_length as text
%        str2double(get(hObject,'String')) returns contents of excitation_length as a double
%s.excitation_length = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function excitation_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to excitation_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
handles.frfdata.path_measure_mat_str      = 'matlab/measures/yamaha-c40_1/body-no_string_E2/mesure_z2.mat';
handles.frfdata.string_modes_number       = 24;
handles.frfdata.note_str                  = 'E2';
handles.frfdata.excitation_type           = 'point';
handles.frfdata.excitation_length         = 36;
handles.frfdata.excitation_bridge_dist    = 0.17; %m
handles.frfdata.listening_mode            = 'position'; % 'acceleration', 'speed' or 'position'

% Edit boxes
set(handles.excitation_length, 'String', handles.frfdata.excitation_length);
set(handles.excitation_x, 'String', handles.frfdata.excitation_bridge_dist);
set(handles.modes_number, 'String', handles.frfdata.string_modes_number);

% Lists
set(handles.excitationtype, 'Value', 2);
set(handles.stringnote, 'Value', 2);
set(handles.selectmeasure, 'Value', 2);
set(handles.selectlisteningmode, 'Value', 2);

guidata(handles.figure1, handles);
% Update handles structure
%guidata(handles.figure1, handles);

function res = refresh_frf_data(handles)

res = {};

gui_str = handles.selectmeasure.String{handles.selectmeasure.Value};
res.path_measure_mat_str      = F_select_measure(gui_str);

nb_modes = str2double(handles.modesnumber.String);
res.string_modes_number       = nb_modes;

str_note = handles.stringnote.String{handles.stringnote.Value};
res.note_str                  = str_note;

exc_type = handles.excitationtype.String{handles.excitationtype.Value};
res.excitation_type           = exc_type;

l_exc = str2double(handles.excitation_length.String);
res.excitation_length         = l_exc;

x_exc = str2double(handles.excitation_x.String);
res.excitation_bridge_dist    = x_exc;

l_mode = handles.selectlisteningmode.String{handles.selectlisteningmode.Value};
res.listening_mode            = l_mode; % 'Acceleration', 'Speed' or 'Position'