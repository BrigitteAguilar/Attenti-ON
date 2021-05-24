function varargout = VentanaCalibracion(varargin)
% VENTANACALIBRACION MATLAB code for VentanaCalibracion.fig
%      VENTANACALIBRACION, by itself, creates a new VENTANACALIBRACION or raises the existing
%      singleton*.
%
%      H = VENTANACALIBRACION returns the handle to a new VENTANACALIBRACION or the handle to
%      the existing singleton*.
%
%      VENTANACALIBRACION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VENTANACALIBRACION.M with the given input arguments.
%
%      VENTANACALIBRACION('Property','Value',...) creates a new VENTANACALIBRACION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VentanaCalibracion_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VentanaCalibracion_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VentanaCalibracion

% Last Modified by GUIDE v2.5 02-Aug-2020 16:45:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VentanaCalibracion_OpeningFcn, ...
                   'gui_OutputFcn',  @VentanaCalibracion_OutputFcn, ...
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


% --- Executes just before VentanaCalibracion is made visible.
function VentanaCalibracion_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VentanaCalibracion (see VARARGIN)

% Choose default command line output for VentanaCalibracion
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VentanaCalibracion wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.nombre_en_la_ventana_calibracion_1,'String',getappdata(0,'nombre'));
set(handles.apellido_en_la_ventana_calibracion_1,'String',getappdata(0,'apellido'));
axes(handles.eeg);
handles.imagen=imread('eeggranderojo.png');
imagesc(handles.imagen);
axis off;

% --- Outputs from this function are returned to the command line.
function varargout = VentanaCalibracion_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n = findobj('tag','VentanaNuevoPaciente');
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in atras_3.
function atras_3_Callback(hObject, eventdata, handles)
%set(VentanaCalibracion,'visible','off');
close VentanaCalibracion;
switch (getappdata(0,'de_donde_viene_el_callback'))
    case 'viene_de_nuevo_paciente'
        VentanaGuardado;
    case 'viene_de_paciente_existente'
        AttentiON;
end
% hObject    handle to atras_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function nombre_en_la_ventana_calibracion_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nombre_en_la_ventana_calibracion_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function apellido_en_la_ventana_calibracion_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to apellido_en_la_ventana_calibracion_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in probar_electrodos.
function probar_electrodos_Callback(hObject, eventdata, handles)
% hObject    handle to probar_electrodos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%close VentanaCalibracion;
%VentanaCalibracion_2;

axes(handles.eeg);
handles.imagen=imread('eeggrandeverde.png');
imagesc(handles.imagen);
axis off;
PROBAR_ELECTRODOS;


% --- Executes on button press in iniciar_calibracion.
function iniciar_calibracion_Callback(hObject, eventdata, handles)
close VentanaCalibracion;
CALIBRAR;
setappdata(0,'recalibracion','no');
VentanaSesion;



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text10.
function text10_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
