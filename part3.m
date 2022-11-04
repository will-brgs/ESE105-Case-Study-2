x_init =[.05;% Infection rate
         .14;% Fatality Rate
         .025;% Recovery rate
         0.002;% Reinfection rat
         1.0;%Starting susceptible
          0;%Staarting infected
          0;%Starting recovered
          0];%Starting dead



x_no_vax = siroutput_prop(x_init, t);

x_init_vax =[.05;% Infection rate
         .14;% Fatality Rate
         .025;% Recovery rate
         0.002;% Reinfection rate
         .05;% Vaccination rate
         .05;% Recovered person vaccination rate
         .01;% Breakthrough infection rate
         x_no_vax(5);
         x_no_vax(6);
         x_no_vax(7);
         x_no_vax(8);
          0];%There are zero starting vaccinated individuals

[f_vax, x_vax] = vax_sir_fit(x_init_vax, 99, 365);

%Plot
figure()
hold on;
plot(f_vax(:,1))
plot(f_vax(:,2))
hold off;
title("Modeled Covid Data with Vaccinations");
ylabel("Number of Infections")
xlabel("Days")
legend("Infections", "Deaths");


%Results
vaxpop = cat(1, zeros(98,1),f_vax(:, 7));
vaxbreak = cat(1, zeros(98,1),f_vax(:, 7)*x_vax(7));