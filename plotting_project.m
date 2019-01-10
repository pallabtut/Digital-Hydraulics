% %Plotting of graphs
t1=15;t0=0;

figure(1)
clf
subplot(5,1,1)
plot(tout,x)
hold on 
plot(t_ref,x_ref)
title('Subplot 1:Displacement')
legend('x','x_ref')
hold off
axis([t0,t1,-inf,inf])

subplot(5,1,2)
plot(tout,v)
hold on
plot(t_ref,v_ref)
plot(discrete_time,v_est)
title('Subplot 2:Velocity')
legend('v','v_ref','v_est')
hold off
axis([t0,t1,-inf,inf])

subplot(5,1,3)
plot(tout,Supply_plot)
hold on
plot(tout,pA)
title('Subplot 3:Pressure')
legend('Supply_plot','pA')
hold off

subplot(5,1,4)
stairs(discrete_time,squeeze(plot_UPa))

hold on
stairs(discrete_time,squeeze(plot_at1))

title('Subplot 4:DFCU STATE')
legend('squeeze(plot_UPa)','squeeze(plot_at1)')
subplot(5,1,5)
plot(tout,squeeze(power))
title('POWER')
legend('power')
hold off;
figure(2)
Valve_switching=bar(sum(abs(diff(squeeze(u_pA)'))));
title('VALVE SWITCHING FOR PORT PA')
hold on;
figure(3)
Valve_switching=bar(sum(abs(diff(squeeze(u_aT)'))));
title('VALVE SWITCHING FOR PORT AT')
hold off;
figure(4)
stairs(tout,max_error)
title('MAX ERROR')
legend('position tracking error')
hold on;
figure(5)
feedback_error=bar(abs(diff(max_error_feed)'));
title('MAX ERROR1')
legend('position tracking error for feedback')
hold off;



