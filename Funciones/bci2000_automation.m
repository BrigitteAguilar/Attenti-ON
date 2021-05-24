clear all; 
close all;
%%
% Instantiate a BCI2000Remote object
%Es necesario instalar el InstallAutomation.cmd que está en la carpeta prog
% de BCI2000.Después de la instalación hay que reiniciar la máquina
bci = actxserver( 'BCI2000Automation.BCI2000Remote' );
fila=1;%fila de la matriz de salida
tiempo=zeros(1,2);% vector auxiliar para registrar tiempo de adquisición
% Archivo para guardar los datos
ruta_datos = 'D:\Facultad\Proyecto final\Señales Stroop\Sujeto EH\Densidades_Espectrales_de_Potencia\';
ruta=strcat(ruta_datos,'Sesion7.txt');
fid=fopen(ruta,'w'); 

try
 bci.WindowVisible = 0;
 % Start the operator module, and connect to it
  ok1 = bci.Connect;
  if ~ok1
    error( bci.Result )
  end 
   % Startup modules
  modules = { 'FilePlayback', 'ARSignalProcessing', 'DummyApplication' };
  ok2 = bci.StartupModules( modules );
  if ~ok2
    error( bci.Result )
  end
  % Load a parameter file, and set subject information
  ok3 = bci.LoadParametersRemote( 'D:\Facultad\Proyecto final\Scripts\GeneraTXTs.prm' );
  if ~ok3
    error( bci.Result )
  end
  nom = getappdata(0,'nombre');
  ape = getappdata(0,'apellido');
  guion = '_';
  nombre_apellido = strcat(nom,guion,ape);
  bci.SubjectID = nombre_apellido;
  % Start a run
  ok4 = bci.GetSystemState();
  if ~ok4
    error( bci.Result )
  end
  bci.WindowVisible=1;
  % Display feedback signal
  state = 'Running';
  value = double( 0 );
  while( ok4 && strcmp( state, 'Running' ))      
   %Lee tiempo de adquisición de un nuevo segmento de datos
    [~, s_tiempo]=bci.GetStateVariable('SourceTime', value);
    tiempo(1,2)=s_tiempo;% tiempo actual
%     % For formal reasons, the 'value' output variable must be specified both
%     % for input and output.
    if tiempo(1,2)~= tiempo(1,1)
         tiempo(1,1)=tiempo(1,2);
         for i=1:20
         [~, value] = bci.GetControlSignal( i, 1,  value );
         sig(fila,i)=value;
         end
         fila=fila+1;          
    end
    % For formal reasons, the 'state' output variable must be specified both
    % for input and output.
    [ok, state] = bci.GetSystemState( state );
        
  end
catch exception % Make sure to delete the BCI2000Remote object
  bci.delete;
  throw(exception);
end
[m,n]=size(sig);
for f=1:m
    fprintf(fid,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f \r\n',sig(f,:))
end
fclose(fid);
% Deleting the BCI2000Remote object will shut down the operator module when it was started by the object
bci.delete;
