function varargout = Attentive(varargin)
% ATTENTIVE MATLAB code for Attentive.fig
%      ATTENTIVE, by itself, creates a new ATTENTIVE or raises the existing
%      singleton*.
%
%      H = ATTENTIVE returns the handle to a new ATTENTIVE or the handle to
%      the existing singleton*.
%
%      ATTENTIVE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ATTENTIVE.M with the given input arguments.
%
%      ATTENTIVE('Property','Value',...) creates a new ATTENTIVE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Attentive_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Attentive_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Attentive

% Last Modified by GUIDE v2.5 06-Jun-2020 10:27:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Attentive_OpeningFcn, ...
                   'gui_OutputFcn',  @Attentive_OutputFcn, ...
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


% --- Executes just before Attentive is made visible.
function Attentive_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Attentive (see VARARGIN)

% Choose default command line output for Attentive
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
axes(handles.logoprincipal);
handles.imagen=imread('D:\Facultad\Proyecto final\Attentive\Scripts\GUI\Attenti-On logo.png');
imagesc(handles.imagen);
axis off;
axes(handles.logouner);
handles.imagen=imread('D:\Facultad\Proyecto final\Attentive\Scripts\GUI\logouner.jpg');
imagesc(handles.imagen);
axis off;

% UIWAIT makes Attentive wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Attentive_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in nuevopaciente.
function nuevopaciente_Callback(hObject, eventdata, handles)
VentanaNuevoPaciente();

% hObject    handle to nuevopaciente (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in buscar_paciente.
function buscar_paciente_Callback(hObject, eventdata, handles)
% hObject    handle to buscar_paciente (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns buscar_paciente contents as cell array
%        contents{get(hObject,'Value')} returns selected item from buscar_paciente


% --- Executes during object creation, after setting all properties.
function buscar_paciente_CreateFcn(hObject, eventdata, handles)
% hObject    handle to buscar_paciente (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buscar_paciente_existente.
function buscar_paciente_existente_Callback(hObject, eventdata, handles)
path_paciente_existente = uigetdir('C:\');
set(VentanaGuardado,'visible','off');
setappdata(0,'de_donde_viene_el_callback','viene_de_paciente_existente');
barra = max(strfind(path_paciente_existente,'\'));
guionbajo = max(strfind(path_paciente_existente,'_'));
nombre = path_paciente_existente(barra+1:guionbajo-1);
apellido = path_paciente_existente(guionbajo+1:size(path_paciente_existente,2));
setappdata(0,'nombre',nombre);
setappdata(0,'apellido',apellido);
VentanaCalibracion_1;
% hObject    handle to buscar_paciente_existente (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
