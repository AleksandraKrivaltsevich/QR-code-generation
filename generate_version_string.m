function res = generate_version_string(ver)
% Функция генерирует 18-битную версионную строку для QR-кода.

genpstr = '1111100100101'; % Генерирующая строка
ver6 = digital_to_binary(ver, 6); % Преобразование версии в 6-битную строку
verstr = strcat(ver6, digital_to_binary(0, 12)); % Создание строки длиной 18 бит

k = 1;

% Удаление ведущих нулей из строки
while verstr(k) == '0'
    k = k + 1;
    if k == 16
        k = 1;
        break;
    end
end

verstr = verstr(k:end);
k = 1;

% Выполнение XOR операции, пока строка не станет длиной 12 бит
while length(verstr) > 12
    dif = length(verstr) - length(genpstr);
    
    % Добавление нулей к генерирующей строке
    genp1 = strcat(genpstr, digital_to_binary(0, dif));
    
    % Выполнение XOR
    verstr = regexprep(num2str(verstr ~= genp1), '\W', '');
    
    % Удаление ведущих нулей
    while verstr(k) == '0'
        k = k + 1;
    end
    verstr = verstr(k:end);
    k = 1;
end

% Добавление нулей, если длина строки меньше 12 бит
if length(verstr) < 12
    verstr = strcat(digital_to_binary(0, 12 - length(verstr)), verstr);
end

% Конкатенация 6-битной версионной строки с результатом XOR операции
res = strcat(ver6, verstr);
end
