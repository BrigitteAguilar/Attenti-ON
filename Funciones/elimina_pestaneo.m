%--------------------------------------------------------------------------
% Este script quita parpadeos seg�n el m�todo de Chang, 2016 (MSDW).
% Utiliza el c�digo MatLab gratuito provisto por los autores.
%--------------------------------------------------------------------------

%-------------Par�metros modificables-----------

sujeto = 'Sujeto Brigitte\';
sesion = 'Sesion3.txt';

% ------No modificable-------

%Carga el txt de bci_2000_automation.m en una matriz llamada DATA
path1 = 'D:\Facultad\Proyecto final\Se�ales Stroop\';
path2 = 'Densidades_Espectrales_de_Potencia\';
filepath = strcat(path1,sujeto,path2,sesion);
DATA = load(filepath);
primerbin = DATA(:,1);
threshold = 2*(mode(primerbin)+std(primerbin));
[rangopestaneo windowacc] = eogdetection_accdiff(primerbin,6,40,threshold);

%Limpiar el pesta�eo teniendo los rangos
for i=1:size(rangopestaneo,1) %cantidad de pesta�eos que hay que limpiar
    for j=rangopestaneo(i,1):rangopestaneo(i,2)
        DATA(j,:)=0;
    end
end