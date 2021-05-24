%--------------------------------------------------------------------------
% Este script quita parpadeos según el método de Chang, 2016 (MSDW).
% Utiliza el código MatLab gratuito provisto por los autores.
%--------------------------------------------------------------------------

%-------------Parámetros modificables-----------

sujeto = 'Sujeto Brigitte\';
sesion = 'Sesion3.txt';

% ------No modificable-------

%Carga el txt de bci_2000_automation.m en una matriz llamada DATA
path1 = 'D:\Facultad\Proyecto final\Señales Stroop\';
path2 = 'Densidades_Espectrales_de_Potencia\';
filepath = strcat(path1,sujeto,path2,sesion);
DATA = load(filepath);
primerbin = DATA(:,1);
threshold = 2*(mode(primerbin)+std(primerbin));
[rangopestaneo windowacc] = eogdetection_accdiff(primerbin,6,40,threshold);

%Limpiar el pestañeo teniendo los rangos
for i=1:size(rangopestaneo,1) %cantidad de pestañeos que hay que limpiar
    for j=rangopestaneo(i,1):rangopestaneo(i,2)
        DATA(j,:)=0;
    end
end