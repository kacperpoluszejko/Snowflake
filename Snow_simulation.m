
clear;
clc;
close all;

disp("SYMULACJA POWSTAWANIA ŚNIEŻYNKI")
disp("--------------------------------");
disp(" ");
disp("wybierz opcję:");
disp("1 - generuj symulację na bieżąco");
disp("2 - wyświetl tylko końcowy wynik symulacji");
opcja1=input("wprowadź numer: ");
while opcja1~=1 && opcja1~=2
    opcja1=input("niepoprawny numer, spróbuj ponownie: ");
end 

disp(" ");
disp("wprwadź wartość parametrów:");
beta=input("beta: "); %tło
while beta<0 || beta>=1
        beta=input("niepoprawna wartość parametru, wprowadź liczbę z przedziału [0;1): ");
end
gamma=input("gamma: "); %dodawana woda do układu
while gamma<0 || gamma>1
        gamma=input("niepoprawna wartość parametru, wprowadź liczbę z przedziału [0;1]: ");
end

F=400; %wymiary siatki
brejk=0;
mymap1=[0 0 0; 1 1 1; 0.99 0.99 0.99; 0.98 0.98 0.98; 0.97 0.97 0.97; 0.96 0.96 0.96; 0.95 0.95 0.95; 0.94 0.94 0.94; 0.93 0.93 0.93; 0.92 0.92 0.92; 0.91 0.91 0.91; 0.90 0.90 0.90; 0.89 0.89 0.89; 0.88 0.88 0.88; 0.87 0.87 0.87; 0.86 0.86 0.86; 0.85 0.85 0.85; 0.84 0.84 0.84; 0.83 0.83 0.83; 0.82 0.82 0.82; 0.81 0.81 0.81; 0.80 0.80 0.80; 0.79 0.79 0.79; 0.78 0.78 0.78; 0.77 0.77 0.77; 0.76 0.76 0.76; 0.75 0.75 0.75; 0.74 0.74 0.74; 0.73 0.73 0.73; 0.72 0.72 0.72; 0.71 0.71 0.71; 0.70 0.70 0.70; 0.69 0.69 0.69; 0.68 0.68 0.68; 0.67 0.67 0.67; 0.66 0.66 0.66; 0.65 0.65 0.65; 0.64 0.64 0.64; 0.63 0.63 0.63; 0.62 0.62 0.62; 0.61 0.61 0.61; 0.60 0.60 0.60; 0.59 0.59 0.59; 0.58 0.58 0.58; 0.57 0.57 0.57; 0.56 0.56 0.56; 0.55 0.55 0.55; 0.54 0.54 0.54; 0.53 0.53 0.53; 0.52 0.52 0.52; 0.51 0.51 0.51; 0.50 0.50 0.50; 0.50 0.50 0.50];

A=zeros(F,F); %macierz docelowa
B=zeros(F,F); % macierz "receptive"
C=zeros(F,F); %macierz nonreceptive
C2=zeros(F,F); %save macierzy nonreceptive
N=3000; %liczba iteracji czasowych

A=A+beta;
A(round(F/2), round(F/2))=1;

C=A;

v = VideoWriter('symulacja_lod.mp4', 'MPEG-4'); 
v.FrameRate = 20;  % liczba klatek na sekundę
open(v);  % otwieramy plik do zapisu


for t=1:N
    for i=2:F-1
        for j=2:F-1



            if mod(i,2)==0 %przypadek wierszów parzystych

                if A(i,j) >= 1 || A(i+1,j) >= 1 || A(i-1,j) >= 1 || A(i,j+1) >= 1 || A(i,j-1) >= 1 || A(i-1,j+1) >= 1 || A(i+1,j+1) >= 1 
                  
                    B(i,j)=A(i,j); %jeśli w sąsiedztwie znajduje się lód to komórkę zapisujemy do macierzy B
                    B(i,j)=B(i,j)+gamma;
                    C(i,j)=0;
                else
                    C(i,j)=A(i,j); % jeśli nie to do C
                end

            end

            if mod(i,2)==1 %przypadek wierszów nieparzystych

                if A(i,j) >= 1 || A(i+1,j) >= 1 || A(i-1,j) >= 1 || A(i,j+1) >= 1 || A(i,j-1) >= 1 || A(i-1,j-1) >= 1 || A(i+1,j-1) >= 1 
                   
                    B(i,j)=A(i,j); %jeśli w sąsiedztwie znajduje się lód to komórkę zapisujemy do macierzy B
                    B(i,j)=B(i,j)+gamma;
                    C(i,j)=0;
                else
                    C(i,j)=A(i,j); % jeśli nie to do C
                end

            end
    
    


        end
    end

    C2=C;

     for i=2:F-1
        for j=2:F-1 %tutaj policzymy dyfuzję luźnej wody


            if mod(i,2)==0 %przypadek wierszów parzystych
                C(i,j)=C2(i,j) - 0.5*C2(i,j) + 1/12*C2(i-1,j) + 1/12*C2(i+1,j) +  1/12*C2(i,j+1) + 1/12*C2(i,j-1) +  1/12*C2(i-1,j+1) + 1/12*C2(i+1,j+1);
            end
            
            if mod(i,2)==1 %przypadek wierszów nieparzystych
                C(i,j)=C2(i,j) - 0.5*C2(i,j) + 1/12*C2(i-1,j) + 1/12*C2(i+1,j) +  1/12*C2(i,j+1) + 1/12*C2(i,j-1) +  1/12*C2(i-1,j-1) + 1/12*C2(i+1,j-1);
            end


        end
    end

   A=B+C;


    if opcja1==1
    M=max(max(A)); 
    if M<=1
    colormap(mymap1);
    imagesc(A);
    clim([0.5,2]);
    title(['czas symulacji: ' int2str(t) 's']);
    xlabel(['β = ' int2str(beta) '   γ = ' int2str(gamma)]);
    pause(0.0005);
    else
    colormap(mymap1);
    imagesc(A);
    clim([1,M]);
    title(['czas symulacji: ' num2str(t) 's']);
    xlabel(['β = ' num2str(beta) '   γ = ' num2str(gamma)]);
    set(gcf, 'Position', [600, 200, 600, 520]);
    pause(0.005);
    end
    end

    % Zapis klatki do pliku wideo:
    frame = getframe(gcf);
    writeVideo(v, frame);

    % Warunek kończący:
    for k=2:F
        if A(round(F/35),k) >= 1  
            brejk=1;
        end
    end

    if brejk==1  %kończymy pętlę czasową jeśli do brzegów dociera lód
        break;
    end

end

close(v);  

if opcja1==2
M=max(max(A));    
colormap(mymap1);
imagesc(A);
clim([1,M]);
title(['czas symulacji: ' num2str(t) 's']);
xlabel(['β = '  num2str(beta) '   γ = ' num2str(gamma)]);
set(gcf, 'Position', [600, 200, 600, 520]);
end