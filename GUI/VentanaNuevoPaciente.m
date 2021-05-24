function varargout = VentanaNuevoPaciente(varargin)
% VENTANANUEVOPACIENTE MATLAB code for VentanaNuevoPaciente.fig
%      VENTANANUEVOPACIENTE, by itself, creates a new VENTANANUEVOPACIENTE or raises the existing
%      singleton*.
%
%      H = VENTANANUEVOPACIENTE returns the handle to a new VENTANANUEVOPACIENTE or the handle to
%      the existing singleton*.
%
%      VENTANANUEVOPACIENTE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VENTANANUEVOPACIENTE.M with the given input arguments.
%
%      VENTANANUEVOPACIENTE('Property','Value',...) creates a new VENTANANUEVOPACIENTE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VentanaNuevoPaciente_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VentanaNuevoPaciente_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VentanaNuevoPaciente

% Last Modified by GUIDE v2.5 07-Jun-2020 13:58:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @VentanaNuevoPaciente_OpeningFcn, ...
    'gui_OutputFcn',  @VentanaNuevoPaciente_OutputFcn, ...
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


% --- Executes just before VentanaNuevoPaciente is made visible.
function VentanaNuevoPaciente_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VentanaNuevoPaciente (see VARARGIN)

% Choose default command line output for VentanaNuevoPaciente
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VentanaNuevoPaciente wait for user response (see UIRESUME)
% uiwait(handles.VentanaNuevoPaciente);


% --- Outputs from this function are returned to the command line.
function varargout = VentanaNuevoPaciente_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function nombre_Callback(hObject, eventdata, handles)
% hObject    handle to nombre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nombre as text
nombre = get(hObject,'String');
setappdata(0,'nombre',nombre);


% --- Executes during object creation, after setting all properties.
function nombre_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nombre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function apellido_Callback(hObject, eventdata, handles)
% hObject    handle to apellido (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of apellido as text
apellido = get(hObject,'String');
setappdata(0,'apellido',apellido);



% --- Executes during object creation, after setting all properties.
function apellido_CreateFcn(hObject, eventdata, handles)
% hObject    handle to apellido (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in atras1.
function atras1_Callback(hObject, eventdata, handles)
%set(VentanaNuevoPaciente,'visible','off');
close VentanaNuevoPaciente
AttentiON;
% hObject    handle to atras1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in listo1.
function listo1_Callback(hObject, eventdata, handles)
nomb = get(handles.nombre,'String');
apell = get(handles.apellido,'String');
if isempty(nomb)||isempty(apell)
    mensaje = 'Ingrese el nombre y apellido de un nuevo paciente';
    set(handles.mensaje_de_error_nombre_no_ingresado,'String',mensaje);
else
    close VentanaNuevoPaciente;
    VentanaGuardado;
end
