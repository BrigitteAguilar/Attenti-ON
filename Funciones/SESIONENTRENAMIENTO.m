% SESION ENTRENAMIENTO

% Función que se llama al presionar 'Iniciar entrenamiento' en la GUI

%%
bci = actxserver( 'BCI2000Automation.BCI2000Remote' );
fila=1;%fila de la matriz de salida
contador = 0;
tiempo=zeros(1,2);% vector auxiliar para registrar tiempo de adquisición
DATA = zeros(32,20);%preinicializacion de matriz de salida de duracion 1 seg
indice = 1;
% Archivo para guardar los datos
ruta_datos = getappdata(0,'path_sesion');
calibracion = '\Calibracion';
th = '\Calibracion\threshold.mat';
%th_reca = '\Calibracion\threshold_reca.mat';
%ruta_th = strcat(ruta_datos,th);
model = '\Calibracion\modelo_regresion';
model_reca = '\Calibracion\modelo_regresion_reca';
recalibra = getappdata(0,'recalibracion');
if strcmp(recalibra,'si') % si es recalibrado, carga el modelo y threshold de recalibracion
    ruta_mod = strcat(ruta_datos,model_reca);
    %ruta_th = strcat(ruta_datos,th_reca);
else
    ruta_mod = strcat(ruta_datos,model); %sino, carga el modelo y threshold original
end
ruta_th = strcat(ruta_datos,th);
threshold = load(ruta_th);
modelo = loadCompactModel(ruta_mod);
figura = '\fig_vel.jpg';
pathfig = strcat(ruta_datos,figura);
nom = getappdata(0,'nombre');
ape = getappdata(0,'apellido');
guion = '_';
nombre_apellido = strcat(nom,guion,ape);
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
    bci.DataDirectory = ruta_datos;
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
    tic
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
            contador = contador+1;
            if fila==32
                 
                % 2do paso: Thresholding del documento txt para eliminar porciones con pestañeos
                
                primerbin = DATA(:,1);
                [rangopestaneo windowacc] = eogdetection_accdiff(primerbin,6,40,threshold.threshold);
                
                %Limpiar el pestañeo teniendo los rangos
                for i=1:size(rangopestaneo,1) %cantidad de pestañeos que hay que limpiar
                    for j=rangopestaneo(i,1):rangopestaneo(i,2)
                        DATA(j,:)=0;
                    end
                end
                
                % 3er paso: Cálculo de RTBs para ventanas de 1 seg de duración de la señal
                
                Theta_c1=mean(DATA(:,2));
                Theta_c2=mean(DATA(:,12));
                for j=1:6
                    Beta1(j)=mean(DATA(:,(j+4)));
                    Beta2(j)=mean(DATA(:,(j+14)));
                end
                Beta_c1=mean(Beta1);
                Beta_c2=mean(Beta2);
                RTB_c1=Theta_c1/Beta_c1;
                RTB_c2=Theta_c2/Beta_c2;
                %end
                
                % Salvando discontinuidades debido a valores NaN
                RTB_c1=RTB_c1(~isnan(RTB_c1));
                RTB_c2=RTB_c2(~isnan(RTB_c2));
                
                %guardamos los valores en vectores para una eventual
                %recalibracion
                
                RTB_c1_reca(contador) = RTB_c1;
                RTB_c2_reca(contador) = RTB_c2;
                
                % MODELO DE REGRESION LINEAL CON AMBAS CARACTERÍSTICAS
                x1=RTB_c1;
                
                x2=RTB_c2;

                X = [x1 x2];
                ypred(indice)=round(predict(modelo,X));
                if ypred(indice)>10
                    ypred(indice)=10;
                else
                    if ypred(indice)<1
                        ypred(indice)=1;
                    end
                end
                tcpipClient = tcpip('127.0.0.1',55001);
                set(tcpipClient,'Timeout',30);
                fopen(tcpipClient);
                a=int2str(ypred(indice));
                fwrite(tcpipClient,a);
                fclose(tcpipClient);
                indice = indice+1;
                fila = 1;
            end
        end
        % For formal reasons, the 'state' output variable must be specified both
        % for input and output.
        [ok4, state] = bci.GetSystemState( state );
     temporizador = toc  ; 
    end
catch exception % Make sure to delete the BCI2000Remote object
    bci.delete;
    throw(exception);
end

vel=figure('Visible','off');
plot(ypred);
grid on
title('Velocidad del personaje');
xlabel('Tiempo [s]');
ylabel('Velocidad');
saveas(vel,pathfig);
setappdata (0, 'prom_vel', mean(ypred));
setappdata (0, 'min_vel', min(ypred));
setappdata (0, 'max_vel', max(ypred));
setappdata (0, 'tiempotranscurrido', temporizador);

%% Nuevo modelo para una eventual recalibracion
x1=RTB_c1_reca;
x1=x1';
x2=RTB_c2_reca;
x2=x2';
RTBprom=((RTB_c1_reca+RTB_c2_reca)/2);%la salida sera inversamente proporcional al promedio de la RTB de ambos canales
RTBprom_min=min(RTBprom);
RTBprom_max=max(RTBprom);
y=((1-10)/(RTBprom_max-RTBprom_min)*(RTBprom-RTBprom_min))+10;
y=y';
X = [x1 x2];
mdl_reca = fitlm(X,y);

% Guardamos el modelo de regresión lineal
modelo_regresion_reca = '\modelo_regresion_reca';
ruta_modelo=strcat(ruta_datos,calibracion,modelo_regresion_reca);
saveCompactModel(mdl_reca,ruta_modelo);

%reseteamos el boton recalibrar
setappdata(0,'recalibracion','no');
