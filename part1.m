
%%Part 1: SIRD Modeling
load COVIDdata.mat
load mockdata.mat
%Subpart 1: Modeling SIRD Without Reinfections
time = 798;

xs_noReinfect = zeros(1, time);% - suceptible
xi_noReinfect = zeros(1, time);% - infected
xr_noReinfect = zeros(1, time);% - recovered
xd_noReinfect = zeros(1, time);% - deceased

xs_noReinfect(1) = 0.9;
xi_noReinfect(1) = 0.1;
xr_noReinfect(1) = 0;
xd_noReinfect(1) = 0;

                %S       I       R        D
A_noReinfect = [0.95    0.04    0.00    0.00;
                0.05    0.80    0.00    0.00; 
                0.00    0.10    1.00    0.00; 
                0.00    0.05    0.00    1.00];

x_noReinfect = [xs_noReinfect;
                        xi_noReinfect;
                        xr_noReinfect;
                        xd_noReinfect];   

for index = 1:time
    if(index==time)
        break;
    end
    x_noReinfect(:, index+1) = A_noReinfect*x_noReinfect(:,index);
end

figure();
hold on;
plot(x_noReinfect(1, :))
plot(x_noReinfect(2, :))
plot(x_noReinfect(3, :))
plot(x_noReinfect(4, :))
legend('Suceptible', 'Infected', 'Recovered', 'Deceased','Location', 'east');
xlabel('Days');
ylabel('Porportion of Population');
title('Handmade SIRD Simulation Without Reinfection')
hold off;

%% Subpart 2: Modeling SIRD With Reinfections
%Should we implement the same code but insead have some sort of function
%that keeps track of how long its been since an individual has been
%recoverd? Then after a certian period of time we can put them back into
%suceptiable. or, we can just make recovered a number less than one and
%that proportion goes into the suceptable

xs_reinfect = zeros(1, time);% - suceptible
xi_reinfect = zeros(1, time);% - infected
xr_reinfect = zeros(1, time);% - recovered
xd_reinfect = zeros(1, time);% - deceased

xs_reinfect(1) = 0.9;
xi_reinfect(1) = 0.1;
xr_reinfect(1) = 0;
xd_reinfect(1) = 0;

             %S        I       R       D
A_reinfect =[0.95    0.04    0.20    0.00;
             0.05    0.85    0.00    0.00; 
             0.00    0.10    0.80    0.00; 
             0.00    0.01    0.00    1.00];

x_reinfect = [xs_reinfect;
                     xi_reinfect;
                     xr_reinfect;
                     xd_reinfect];

for index = 1:time
    if(index==time)
        break;
    end
    x_reinfect(:, index+1) = A_reinfect*x_reinfect(:,index);
end

figure();
hold on;
plot(x_reinfect(1, :))
plot(x_reinfect(2, :))
plot(x_reinfect(3, :))
plot(x_reinfect(4, :))
legend('Suceptible', 'Infected', 'Recovered', 'Deceased','Location', 'east');
xlabel('Days');
ylabel('Porportion of Population');
title('Handmade SIRD Simulation With')
hold off;
