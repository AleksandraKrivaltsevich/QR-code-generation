function numpn = penalty4(qrmat)
% Функция penlt4 определяет соотношение светлых модулей к темным модулям в QR-коде.

len = length(qrmat);
%% Общее количество модулей
tot = len * len;

%% Счетчик общего числа темных модулей
numdk = sum(qrmat(:) == 0);

%% Процент темных модулей
pmod = ((numdk / tot) * 100);
pmod = floor(pmod);

%% Ближайшее кратное 5
k = 0;
while (mod((pmod + k), 5) ~= 0)
    k = k + 1;
end
himul5 = pmod + k;

k = 0;
while (mod((pmod - k), 5) ~= 0)
    k = k + 1;
end
lomul5 = pmod - k;

%% Вычитание 50 и взятие абсолютного значения
himul5 = abs(himul5 - 50);
lomul5 = abs(lomul5 - 50);

%% Разделение каждого значения на 5
himul5 = himul5 / 5;
lomul5 = lomul5 / 5;

%% Взятие минимума из двух значений и умножение на 10
numpn = min(himul5, lomul5) * 10;
end
