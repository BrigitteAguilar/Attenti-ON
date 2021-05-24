% CALIBRAR

% Función que se llama al presionar 'CALIBRAR' en la GUI

%Esta función genera un archivo de texto con las densidades espectrales de
%potencia llamado Calibración.txt

%%
bci = actxserver( 'BCI2000Automation.BCI2000Remote' );
fila=1;%fila de la matriz de salida
tiempo=zeros(1,2);% vector auxiliar para registrar tiempo de adquisición
% Archivo para guardar los datos
ruta_datos = getappdata(0,'path_sesion');
calibracion = '\Calibracion';

nom = getappdata(0,'nombre');
ape = getappdata(0,'apellido');
guion = '_';
nombre_apellido = strcat(nom,guion,ape);
contador = 1;
velocidad = 1;


try
    bci.WindowVisible = 0;
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
    
    % Cargar parámetros
    ok3 = bci.LoadParametersRemote( 'parametros_gNautilus_ATTENTION.prm' ); %MODIFICAR ESTE PARÁMETRO BCI2000 DE ACUERDO AL ARCHIVO .prm UTILIZADO
    if ~ok3
        error( bci.Result )
    end
    
    %Dónde guarda la señal cruda
    bci.DataDirectory = strcat(ruta_datos,calibracion);
    bci.SubjectID = nombre_apellido;
    
    % Start a run
    ok4 = bci.Start();
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
                DATA(fila,i)=value;
            end
            fila=fila+1;
            
            %Actualizamos velocidad avatar
            if mod(fila,32)==0
                tcpipClient = tcpip('127.0.0.1',55001);
                set(tcpipClient,'Timeout',30);
                fopen(tcpipClient);
                a=int2str(velocidad);
                fwrite(tcpipClient,a);
                fclose(tcpipClient);
                contador = contador+1;
                if contador == 13
                    contador=1;
                    velocidad = velocidad+1;
                end
                
            end
        end
        % For formal reasons, the 'state' output variable must be specified both
        % for input and output.
        [ok4, state] = bci.GetSystemState( state );
        
    end
catch exception % Make sure to delete the BCI2000Remote object
    bci.delete;
    throw(exception);
end

bci.delete;

%% Thresholding del documento txt para eliminar porciones con pestañeos

primerbin = DATA(:,1);
threshold = 2*(mode(primerbin)+std(primerbin)); % Estimamos dónde debe estar el threshold según el histograma. Por recomendación de los autores, debe ser el doble de la amplitud relevada
[rangopestaneo windowacc] = eogdetection_accdiff(primerbin,6,40,threshold);

%Limpiar el pestañeo teniendo los rangos
for i=1:size(rangopestaneo,1) %cantidad de pestañeos que hay que limpiar
    for j=rangopestaneo(i,1):rangopestaneo(i,2)
        DATA(j,:)=0;
    end
end

%Guardamos el threshold
threshold_mat = '\threshold.mat';
path_threshold = strcat(ruta_datos,calibracion,threshold_mat);
save( path_threshold, 'threshold');

%% Cálculo de RTBs para ventanas de 1 seg de duración de la señal
vent=32;% equivalente a 1 seg de duración
for i=1:floor(size(DATA,1)/vent)
    a=(vent*(i-1))+1;
    Theta_c1=mean(DATA(a:a+vent,2));
    Theta_c2=mean(DATA(a:a+vent,12));
    for j=1:6
        Beta1(j)=mean(DATA(a:a+vent,(j+4)));
        Beta2(j)=mean(DATA(a:a+vent,(j+14)));
    end
    Beta_c1=mean(Beta1);
    Beta_c2=mean(Beta2);
    RTB_c1(i)=Theta_c1/Beta_c1;
    RTB_c2(i)=Theta_c2/Beta_c2;
end

% Salvando discontinuidades debido a valores NaN
RTB_c1=RTB_c1(~isnan(RTB_c1));
RTB_c2=RTB_c2(~isnan(RTB_c2));

%% MODELO DE REGRESION LINEAL CON AMBAS CARACTERÍSTICAS
x1=RTB_c1;
x1=x1';
x2=RTB_c2;
x2=x2';
RTBprom=((RTB_c1+RTB_c2)/2);%la salida sera inversamente proporcional al promedio de la RTB de ambos canales
RTBprom_min=min(RTBprom);
RTBprom_max=max(RTBprom);
y=((1-10)/(RTBprom_max-RTBprom_min)*(RTBprom-RTBprom_min))+10;
y=y';
X = [x1 x2];
mdl = fitlm(X,y);

% Guardamos el modelo de regresión lineal
modelo_regresion = '\modelo_regresion';
ruta_modelo=strcat(ruta_datos,calibracion,modelo_regresion);
saveCompactModel(mdl,ruta_modelo);

