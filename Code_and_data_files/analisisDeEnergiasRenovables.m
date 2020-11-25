%{
   Alnalisis de la variabilidad de las energias renovbales

%}


clear all
close all
set(0,'defaultTextInterpreter','latex');


% Elegir el dia para analizar 

day = input("1. '14 de Abril', 2. '13 de Mayo', 3. '17 de Mayo'  (Selecciona el dia ingresando el numero de opcion) :    ");
%.............................Cargando datos.......................................
switch (day)
    
    case 1
    % Datos del 14 de Abril

        disp("Por ahora no hay datos :(")
    case 2
        % Datos del 13 de Mayo
        green_data = xlsread("Data001Verde13mayoExcel.xlsx");
        x_green = transpose(green_data(:,1));
        y_green = transpose(green_data(:,2));

        yellow_data = xlsread("Data002Amarillo13mayoExcel.xlsx");
        x_yellow = transpose(yellow_data(:,1));
        y_yellow = transpose(yellow_data(:,2));


        blue_data13 = xlsread("Data003Azul13mayoExcel.xlsx");
        x_blue = transpose(blue_data13(:,1));
        y_blue = transpose(blue_data13(:,2));
    
    case 3
    %Datos del 17 de Mayo
        disp("Por ahora no hay datos :(")
    otherwise
        disp("Dia no elegido :(")

end

%..............................Limpiando datos......................................
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

% Interpolando ....
supLimit = 2400;   % Limite de prueba para curva azul -> 2397.6199
x_Int = 0 : supLimit/(24*60) : supLimit-1 ;                                % vector de resulucion minutal 1440 puntos  (24*60)

disp(length(x_Int));                                                       % Calculo del stepSize ---> stepSize = LimiteSuperior/(24*60)
y_GInt = interp1(x_green,y_green, x_Int);
y_BInt = interp1(x_blue,y_blue, x_Int);
y_YInt = interp1(x_yellow,y_yellow, x_Int);

disp(length(y_GInt));

figure(2)
plot(x_Int,y_GInt ,'Color','g','LineWidth',1.2);
title("CURVA PATO MIERCOLES 13 DE MAYO DE 2020 INTERPOLADAS")
grid on
hold on

plot(x_Int,y_YInt,'Color','#fbc02d','LineWidth',1.2);
plot(x_Int,y_BInt,'Color','b','LineWidth',1.2);


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



