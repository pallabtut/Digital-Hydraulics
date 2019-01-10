function [t,x,v] = poly_traj_iha2576(t_values,dt_values,x_values,ts,poly_degree)

% [t,x,v] = poly_traj_iha2576(t_values,dt_values,x_values,ts,poly_degree)
%
% Generoi n‰ytev‰lill‰ ts aikavektorin ja sit‰ vastaavan asemaradan, jossa
% asema muuttuu 3. tai 5. asteen polynomilla (poly_degree) x_values
% vektorin m‰‰r‰‰mien pisteiden v‰lill‰. Liikkeiden aloitushetket m‰‰ritell‰‰n 
% vektorissa t_values ja liikeajat vektorissa dt_values.
%
% HUOM1: x_values vektorin on oltava yhden pitempi kuin t_values tai
% dt_values, koska sek‰ aloituspiste ett‰ lopetuspiste on m‰‰ritelt‰v‰.
%
% HUOM2: t_values(1) ei saa olla nolla
%
% (C) 21.4.2004 Matti Linjama, TUT/IHA
%
% Varmistukset

n = length(t_values);
n_dt = length(dt_values);
n_x = length(x_values);

if t_values(1) <= 0
    error('Ensimm‰isen liikkeen aloitushetken t‰ytyy olla positiivinen!')
end

if (n ~= n_dt) | (n+1 ~= n_x)
    error('Vektoreiden t_values ja dt_values t‰ytyy olla yht‰ pitki‰ ja vektorin x_values yhden pitempi!')
end

diff_t = diff(t_values);

if any(diff_t < dt_values(1:end-1))
    error('Jokin liikeaika on liian pitk‰!')
end

if (poly_degree ~= 3) & (poly_degree ~= 5)
    error('Polynomin asteen on oltava joko 3 tai 5')
end

% Polynomien datapisteiden lukum‰‰r‰t

n_movements = round(dt_values/ts);

% Indeksit muutoshetkiin ja aikavektorin generointi

ind = round(t_values/ts)+1;
n_points = ind(end)+n_movements(end)+5;  % Loppuun 5 pointsia tasaista

t = (0:(n_points-1))*ts;

% Alustetaan x-vektori askelmaiseksi ja nopeusvektori nollaksi

x = x_values(1)*ones(1,n_points);

for i = 2:n
    x(ind(i-1):ind(i)-1) = x_values(i);
end

x(ind(n):end) = x_values(n+1);

v = zeros(1,n_points);

% Polynomiradat

for i = 1:n
    if poly_degree == 3
        [x(ind(i):ind(i)+n_movements(i)),v(ind(i):ind(i)+n_movements(i))] = ...
            poly3(x_values(i),x_values(i+1),dt_values(i),ts);
    else
        [x(ind(i):ind(i)+n_movements(i)),v(ind(i):ind(i)+n_movements(i))] = ...
            poly5(x_values(i),x_values(i+1),dt_values(i),ts);
    end
end
end
function [x,v] = poly3(xini,xfinal,t,ts)

% [x,v] = poly3(xini,xfinal,t,ts)
%
% Generoi 3. asteen polynomiradan pisteest‰ xini pisteeseen xfinal.
% Liikeaika on t ja n‰ytev‰li ts. x on asema- ja v nopeusrata
%
% (C) 21.4.04 Matti Linjama, TUT/IHA

tt = (0:round(t/ts))*ts;

% Polynomin kertoimet

a3 = xini;
a1 = 3*(xfinal-xini)/t^2;
a0 = -2*(xfinal-xini)/t^3;

% Rata

x = a0*tt.^3+a1*tt.^2+a3;
v = 3*a0*tt.^2+2*a1*tt;
end

function [x,v,a,tt] = poly5(xini,xfinal,t,ts)

% [x,v,a,tt] = poly5(xini,xfinal,t,ts)
%
% Generoi 5. asteen polynomiradan pisteest‰ xini pisteeseen xfinal.
% Liikeaika on t ja n‰ytev‰li ts. x on asema- ja v nopeusprofiili.
%
% (C) 21.4.04 Matti Linjama, TUT/IHA

tt = (0:round(t/ts))*ts;

% Polynomin kertoimet

a5 = xini;
a2 = 10*(xfinal-xini)/t^3;
a1 = -15*(xfinal-xini)/t^4;
a0 = 6*(xfinal-xini)/t^5;

% Rata

x = a0*tt.^5+a1*tt.^4+a2*tt.^3+a5;
v = 5*a0*tt.^4+4*a1*tt.^3+3*a2*tt.^2;
a = 20*a0*tt.^3+12*a1*tt.^2+6*a2*tt;
end

