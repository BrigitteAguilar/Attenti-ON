function varargout = VentanaSesion(varargin)
% VENTANASESION MATLAB code for VentanaSesion.fig
%      VENTANASESION, by itself, creates a new VENTANASESION or raises the existing
%      singleton*.
%
%      H = VENTANASESION returns the handle to a new VENTANASESION or the handle to
%      the existing singleton*.
%
%      VENTANASESION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VENTANASESION.M with the given input arguments.
%
%      VENTANASESION('Property','Value',...) creates a new VENTANASESION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VentanaSesion_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VentanaSesion_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VentanaSesion

% Last Modified by GUIDE v2.5 14-Dec-2020 10:25:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VentanaSesion_OpeningFcn, ...
                   'gui_OutputFcn',  @VentanaSesion_OutputFcn, ...
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


% --- Executes just before VentanaSesion is made visible.
function VentanaSesion_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VentanaSesion (see VARARGIN)

% Choose default command line output for VentanaSesion
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VentanaSesion wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.nombrepaciente,'String',getappdata(0,'nombre'));
set(handles.apellidopaciente,'String',getappdata(0,'apellido'));

% --- Outputs from this function are returned to the command line.
function varargout = VentanaSesion_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in iniciarentrenamiento.
function iniciarentrenamiento_Callback(hObject, eventdata, handles)
SESIONENTRENAMIENTO;
axes(handles.graficavelocidad);
handles.imagen=imread(pathfig);
imagesc(handles.imagen);
axis off;
minima = getappdata(0, 'min_vel');
maxima = getappdata(0, 'max_vel');
prom = getappdata(0, 'prom_vel');
tiem = getappdata(0, 'tiempotranscurrido');
set(handles.velmin, 'String', num2str (minima));
set(handles.velmax, 'String', num2str (maxima));
set(handles.velprom, 'String', num2str (round(prom,1)));
set(handles.tiempotrans, 'String', num2str(round(tiem)));


% --- Executes on button press in atras_4.
function atras_4_Callback(hObject, eventdata, handles)
% hObject    handle to atras_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close VentanaSesion;
VentanaCalibracion;


% --- Executes on button press in recalibrar.
function recalibrar_Callback(hObject, eventdata, handles)
% hObject    handle to recalibrar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(0,'recalibracion','si');
