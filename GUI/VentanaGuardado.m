function varargout = VentanaGuardado(varargin)
% VENTANAGUARDADO MATLAB code for VentanaGuardado.fig
%      VENTANAGUARDADO, by itself, creates a new VENTANAGUARDADO or raises the existing
%      singleton*.
%
%      H = VENTANAGUARDADO returns the handle to a new VENTANAGUARDADO or the handle to
%      the existing singleton*.
%
%      VENTANAGUARDADO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VENTANAGUARDADO.M with the given input arguments.
%
%      VENTANAGUARDADO('Property','Value',...) creates a new VENTANAGUARDADO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VentanaGuardado_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VentanaGuardado_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VentanaGuardado

% Last Modified by GUIDE v2.5 04-Jun-2020 10:50:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VentanaGuardado_OpeningFcn, ...
                   'gui_OutputFcn',  @VentanaGuardado_OutputFcn, ...
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


% --- Executes just before VentanaGuardado is made visible.
function VentanaGuardado_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VentanaGuardado (see VARARGIN)

set(handles.pathparaguardar,'String','C:\');
% Choose default command line output for VentanaGuardado
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VentanaGuardado wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VentanaGuardado_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = findobj('tag','VentanaNuevoPaciente');
% Get default command line output from handles structure
varargout{1} = handles.output;



function VentanaGuardado_Callback(hObject, eventdata, handles)
% hObject    handle to VentanaGuardado (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VentanaGuardado as text
%        str2double(get(hObject,'String')) returns contents of VentanaGuardado as a double


% --- Executes during object creation, after setting all properties.
function pathparaguardar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VentanaGuardado (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in examinarguardar.
function examinarguardar_Callback(hObject, eventdata, handles)
path_nuevo_paciente = uigetdir('C:\');
nombre = getappdata(0,'nombre');
apellido = getappdata(0,'apellido');
char1 = '\';
char2 = '_';
path_carpeta_paciente = strcat(path_nuevo_paciente,char1,nombre,char2,apellido);
set(handles.pathparaguardar,'String',path_carpeta_paciente);




% --- Executes on button press in listo2.
function listo2_Callback(hObject, eventdata, handles)
path = [get(handles.pathparaguardar,'String') '\Sesión del ' date];
mkdir(path);
setappdata(0,'path_sesion',path);
setappdata(0,'de_donde_viene_el_callback','viene_de_nuevo_paciente');
close VentanaGuardado
VentanaCalibracion;



% hObject    handle to listo2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in atras2.
function atras2_Callback(hObject, eventdata, handles)
set(VentanaGuardado,'visible','off');
VentanaNuevoPaciente;
% hObject    handle to atras2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
