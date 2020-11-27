%{
   Alnalisis de la variabilidad de las energias renovbales

%}


clear all
close all
format long
set(0,'defaultTextInterpreter','latex');


% Elegir el dia para analizar 
load("G14Abr.mat")
load("Y14Abr.mat")
load("B14Abr.mat")

day = input("1. '14 de Abril', 2. '13 de Mayo', 3. '17 de Mayo'  (Selecciona el dia ingresando el numero de opcion) :    ");


%.............................Cargando datos.......................................
switch (day)
    
    case 1
    % Datos del 14 de Abril
        green_data = Ab14VeNew;
        x_green = green_data(1,:);
        y_green = green_data(2,:);
        
        yellow_data = Ab14AmNew;
        x_yellow = yellow_data(1,:);
        y_yellow = yellow_data(2,:);
        
        blue_data13 = Ab14AzNew;
        x_blue = blue_data13(1,:);
        y_blue = blue_data13(2,:);
        
    case 2
        % Datos del 13 de Mayo
        green_data = xlsread("Data001Verde13mayoExcel.xlsx");
        x_green = transpose(green_data(:,1));
        y_green = transpose(green_data(:,2));
        
       

        
        yellow_data = xlsread("Data002Amarillo13mayoExcel.xlsx");
        x_yellow = transpose(yellow_data(:,1));
        y_yellow = transpose(yellow_data(:,2));
        
       
        
        

        blue_data132 = xlsread("Data003Azul13mayoExcel.xlsx");
        x_blue = transpose(blue_data132(:,1));
        y_blue = transpose(blue_data132(:,2));
    
    case 3
    %Datos del 17 de Mayo2
        disp("Por ahora no hay datos :(")
    otherwise
        disp("Dia no elegido :(")

end

%...................................Limpiando datos......................................
oldSizeGreen = length(x_green);
[x_green, x_G13index ] = unique(x_green,'stable');   % Limpiando los datos repetidos del vector x
y_green = unique_xy_values(x_green,y_green,oldSizeGreen,x_G13index); % Limpiando los datos en el vetor y

oldSizeYellow = length(x_yellow);
[x_yellow,x_Y13index] = unique(x_yellow,'stable'); % Limpiando los datos repetidos del vector x
y_yellow = unique_xy_values(x_yellow,y_yellow,oldSizeYellow,x_Y13index); % Limpiando los datos en el vetor y

oldSizeBlue13 = length(x_blue);
[x_blue, x_B13index] = unique(x_blue,'stable'); % Limpiando los datos repetidos del vector x
y_blue = unique_xy_values(x_blue,y_blue,oldSizeBlue13,x_B13index); % Limpiando los datos en el vetor y

%.................................Graficando las series de tiempo.........................................
figure(1)
plot(x_green,y_green,'Color','g', 'LineWidth',1.2);
title("CURVA PATO MIERCOLES 13 DE MAYO DE 2020")
grid on
hold on

plot(x_yellow,y_yellow,'Color','#fbc02d','LineWidth',1.2);
plot(x_blue,y_blue,'Color','b','LineWidth',1.2);


supLimit = x_blue(end);   % Limite de prueba para curva azul -> 2397.6199

% .........................Interpolando ..................................
x_Int = x_Interpol(24*60,supLimit); %Escala minutal
x_IntH = x_Interpol(24,supLimit);   %Escala horaria

%-------------------Interpolacion minutal----
y_GInt = interp1(x_green,y_green, x_Int);
y_BInt = interp1(x_blue,y_blue, x_Int);
y_YInt = interp1(x_yellow,y_yellow, x_Int);

%------------------Interpolacion horaria--------
y_GIntH = interp1(x_green,y_green, x_IntH);
y_BIntH = interp1(x_blue,y_blue, x_IntH);
y_YIntH = interp1(x_yellow,y_yellow, x_IntH);


disp(length(y_GInt));
disp(length(y_BInt));


newLim_M = 24*60;
newLim_H = 24 ; 
newXM = cambioDeEscala(newLim_M,x_Int);
newXH = cambioDeEscala(newLim_H,x_IntH);

%...............................Igualando los extremos de la curva de
%....................................generacion solar y eolica.............

index_0 = find( newXM == 448);
index_f = find( newXM == 1244);

y_YInt(1:index_0) = y_GInt(1:index_0);
y_YInt(index_f:end) = y_GInt(index_f:end);

index_0H = find( newXH == 7);
index_fH = find(newXH == 20);
y_YIntH(1:index_0H) = y_GIntH(1:index_0H);
y_YIntH(index_fH : end) = y_GIntH(index_fH:end);

%-----------------------------Graficando curvas interpoladas-------------------------------
showInterpol(newXM,y_YInt,y_GInt,y_BInt,2,"CURVA PATO MIERCOLES 13 DE MAYO DE 2020 INTERPOLADAS"); 
showInterpol(newXH,y_YIntH,y_GIntH,y_BIntH,3,"CURVA PATO MIERCOLES 13 DE MAYO DE 2020 INTERPOLADAS "); 


%...............................Graficas de dispersion.....................

% tot_smooth = smoothdata(y_YInt,'sgolay',10);
% FV_smooth  = smoothdata(y_GInt,'sgolay',10);   % tot - FV --> curva verde
% 
% 
% 
% res_tot = y_YInt - tot_smooth;
% res_FV = y_GInt - FV_smooth;
% 
% divRes = res_tot./res_FV ;  

blue_smooth = smoothdata(y_BInt,10);
green_smooth = smoothdata(y_GInt,10);
xL = linspace(0,3.61e4,10000);
figure(10)
plot(blue_smooth,green_smooth,'o','MarkerSize',3,'MarkerEdgeColor','#1a237e',...
    'MarkerFaceColor','#000051');
title("Grafica de dispersion  Eolica v.s. Termica ")
hold on 

% ...............................Regresion lineal ........ y = b_1 x + b_0
xT = transpose(blue_smooth);
yT = transpose(green_smooth);
X = [ones(length(blue_smooth),1) , xT];

b = X\yT; 
format long
disp("b = ");
disp(b)

b_0 = b(1,1);
b_1 = b(2,1);
disp(b_0/b_1)

xpr = linspace(27600,36100,50000); % Vector x para graficar la regresion
yPr = b_1 * xpr + b_0;      %Lineal regresion ....
plot(xpr,yPr,'Color','r','LineWidth',2)
grid on 



% 
% TF = isoutlier(divRes,'percentiles',[2.5,97.5]);
% 
% indices = find(TF);
% disp(indices);
% promedio = 1;
% 
% for i = 1 : length(indices)
%   c = res_tot(indices(i))/res_FV(indices(i));
%   deltaRt = res_FV(indices(i))*(promedio-c);
%   RtNew = res_tot(indices(i))+deltaRt;
%   y_YInt(indices(i)) = tot_smooth(indices(i))+RtNew;
% end
% 
% 
% 
% 
% figure(4)
% scatter(newX, divRes)
% title("smooth data")
% hold on
% plot(newX,tot_smooth2,'r')
% plot(newX,tot_smooth3)

% res_tot = y_YInt - tot_smooth;
% divRes2 = res_tot./res_FV ; 
% figure(8)
% scatter(newX, divRes2)
% title("smooth data")
% hold on


%..................................Cambios minutales.......................

dif_min_FV_eo = diferencia(y_YInt,y_GInt); % Diferencias minutales entre la curva de generacion solar y la fotovoltaica
dif_hor_FV_eo = diferencia(y_YIntH,y_GIntH); % Diferencias horarias 

%---------------------------------Mostrasndo histogramas--------------------------
showHist(dif_min_FV_eo,4,"Diferencias minutales FV-EO");
showHist(dif_hor_FV_eo,6,"Diferencias horarias FV-EO");


% Funcion encargada de eliminar los valores y en caso de tener valores de x
% repetidos
function Y =  unique_xy_values(x,y,oldSize,indices)

    if length(x) ~= oldSize
        disp("adentro");
        for i = 1 : length(indices)        
            y_new(i) = y(x(i));        
        end 
        
    else
        y_new = y;
    end
    
    Y = y_new;              % Regresa el vector con datos unicos o el vector sin modificaciones
end

% Funcion encargada de realizar la diferencia entre dos vectores
function delta = diferencia(v1,v2)

    dif = v1 - v2;    
    dif_temp = nonzeros(dif);
    delta = transpose(dif_temp);   
end


%Funcion encargada de mostrar un histograma
function showHist(diferencias,num,tit)

    N_FV = length(diferencias);
    c = ceil(1 + log2(N_FV));
    disp("Numero de clases = "+c);
    minValue = min(diferencias);
    maxValue = max(diferencias);
    disp("valor maximo = "+maxValue);
    disp("valor minimo = "+minValue);

    width = (maxValue - minValue)/c ;
    edges = 0:width:maxValue;
    
    figure(num)
    hist = histogram(diferencias,edges);
    h = hist.Values;                         % histogram values 
    centers = 0.5* (edges(1:end - 1) + edges(2:end));   % valor central

    bar(centers,h);     
    title(tit)
    xlabel("MW");
    ylabel("Frecuencia");   
    grid on
    
    figure(num+1)
    semilogy(centers,h,'o','MarkerFaceColor',[0 0.447 0.741]);  %escala semi-Log
    title(tit)
    xlabel("MW");
    ylabel("Frecuencia"); 
    grid on
end

function re = x_Interpol(N,supLimit)

    x_Int = 0 : supLimit/(N) : supLimit;                         % vector de resulucion minutal 1440 puntos  (24*60)   
    x_Int = x_Int(1:  end -1);

    disp(length(x_Int));                                          % Calculo del stepSize ---> stepSize = LimiteSuperior/(24*60)
   
    re = x_Int;
end

%...................Cambiando la escala del eje X ................ 
function r = cambioDeEscala(newLim,x_Int)
           
    step = newLim/length(x_Int);
    newX = 0 : step : newLim ;
    newX = newX(1:end-1);
    disp("Largo de newX --> "+ length(newX)); 
    r = newX;
end

%..............................Graficando las curvas interpoladdas.........

function showInterpol(newX,y_YInt,y_GInt,y_BInt,num,t)
    figure(num)
    plot(newX,y_YInt,'Color','#fbc02d','LineWidth',1.2);
    title(t)
    grid minor
    hold on
    ax.GridAlpha = 1;

    plot(newX,y_GInt ,'Color','g','LineWidth',1.2);
    plot(newX,y_BInt,'Color','b','LineWidth',1.2);
end





