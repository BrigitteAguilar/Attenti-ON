% PROBAR_ELECTRODOS name soon to change to CALIBRAR

% Abre BCI2000 y espera en estado 'Resting' para dar tiempo al chequeo de
% electrodos. Luego, al presionar 'calibrar' el estado cambia a 'Running' y
% construye un archivo txt con las densidades espectrales de potencia.
% Asimismo, obtiene el modelo de ajuste y el threshold de pestañeos.
%En el Avatar, la velocidad cambia sin interacción con el usuario

bci = actxserver( 'BCI2000Automation.BCI2000Remote' );
fila=1;%fila de la matriz de salida
tiempo=zeros(1,2);% vector auxiliar para registrar tiempo de adquisición
% Archivo para guardar los datos
ruta_datos = getappdata(0,'path_sesion');
nom = getappdata(0,'nombre');
ape = getappdata(0,'apellido');
guion = '_';
nombre_apellido = strcat(nom,guion,ape);

try
    bci.WindowVisible = 1;
    % Start the operator module, and connect to it
    ok1 = bci.Connect;
    if ~ok1
        error( bci.Result )
    end
    % Startup modules
    modules = { 'gNautilusSource', 'ARSignalProcessing', 'DummyApplication' }; %MODIFICAR EL PRIMER PARÁMETRO DE ACUERDO AL AMPLIFICADOR ESCOGIDO
    ok2 = bci.StartupModules( modules );
    if ~ok2
        error( bci.Result )
    end
    ok3 = bci.LoadParametersRemote( 'parametros_gNautilus_ATTENTION.prm' ); %MODIFICAR ESTE PARÁMETRO BCI2000 DE ACUERDO AL ARCHIVO .prm UTILIZADO
    if ~ok3
        error( bci.Result )
    end
    %Dónde guarda el .dat
    bci.DataDirectory = ruta_datos;
    bci.SubjectID = nombre_apellido;
    % Start a run
    %state = 'Resting';
    ok4 = bci.SetConfig();
    %[ok4, state] = bci.GetSystemState( state );
    if ~ok4
        error( bci.Result )
    end
    %bci.WindowVisible=0;
    % Display feedback signal
    state = 'Resting';
   
    while( ok4 && strcmp( state, 'Resting' ))
        [ok4, state] = bci.GetSystemState( state );
    end
    catch exception % Make sure to delete the BCI2000Remote object
  bci.delete;
  throw(exception);
end