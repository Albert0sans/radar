% 
% %% 2.	Clutter Gaussiano con función de autocorrelación Gaussiana
close all
clear all
load clutter.mat 

coef_correlacion=[8,99];
num_pulsos=[3,9]; % N de la transparencia 10

Coeficientes_Cancelador_9=factorial(num_pulsos(2)-1)*(-1).^(0:(num_pulsos(2)- 1))./(factorial(0:(num_pulsos(2)-1)).*factorial(num_pulsos(2)-1-(0:(num_pulsos(2)- ...
1))));
Coeficientes_Cancelador_norm_9= Coeficientes_Cancelador_9/sqrt(sum(abs(Coeficientes_Cancelador_9).^2));

   

matriz_ruido_099=clutter_CNR30dB_099_0 + randn(600,600)+1i*randn(600,600);
SNR=20; Er=10^(SNR/10);
%% Anadimos blanco real
matriz_ruido_099(100,100:104)=sqrt(0.6*Er)*exp(1i*pi/5) + matriz_ruido_099(100,100:104);



salida_cancelador_9_099 = filter(Coeficientes_Cancelador_norm_9,1,matriz_ruido_099);



Pfa=1e-6;
No=1;
umbrales_No=gaminv(1-Pfa,1,2*No);


salida_cancelador_9_sin_transitorio=salida_cancelador_9_099(9:end,:); 


varianza_todas_filas_sin_transitorios=var(real(salida_cancelador_9_sin_transitorio(:)))

umbrales_estimados=gaminv(1-Pfa,1,2*varianza_todas_filas_sin_transitorios)




figure(); imagesc(abs(salida_cancelador_9_099).^2>umbrales_estimados(1)); title('Salida del blanco real'); colormap('gray')


%%% Repetimos y anadimos el señuelo


matriz_ruido_099(400:405,400:420)=sqrt(200*Er)*exp(1i*pi/5) + matriz_ruido_099(400:405,400:420);



salida_cancelador_9_099 = filter(Coeficientes_Cancelador_norm_9,1,matriz_ruido_099);



Pfa=1e-6;
No=1;
umbrales_No=gaminv(1-Pfa,1,2*No);


salida_cancelador_9_sin_transitorio=salida_cancelador_9_099(9:end,:); 


varianza_todas_filas_sin_transitorios=var(real(salida_cancelador_9_sin_transitorio(:)))

umbrales_estimados=gaminv(1-Pfa,1,2*varianza_todas_filas_sin_transitorios)




figure(); imagesc(abs(salida_cancelador_9_099).^2>umbrales_estimados(1)); title('Salida tras introducir el señuelo'); colormap('gray')


%%% Repetimos y anadimos el blaco



function [pdf_est, ejex] = pdf_estimada(datos, muestras)

long = length(datos);
    
[h, ejex] = hist(datos, muestras);
ancho_barra = ejex(2)-ejex(1);
area = ancho_barra*sum(h); % area=long*ancho_barra;
pdf_est = h./area;
end
