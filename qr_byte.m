function [res, ver] = qr_byte(txt, len, ecc, tcap, terr)
% Функция qr_byte генерирует часть закодированного QR-кода для байтовых данных.
% Она состоит из трех частей: режима, счетчика символов и закодированных данных.

% Определение таблицы ёмкости в зависимости от уровня коррекции ошибок.
if (ecc == 'L')
    lookup = 1;
elseif (ecc == 'M')
    lookup = 2;
elseif (ecc == 'Q')
    lookup = 3;
elseif (ecc == 'H')
    lookup = 4;
else
    fprintf('Недопустимый уровень ECC.\n');
end

% Нахождение соответствующего уровня емкости в таблице.
while (len > tcap(lookup))
    lookup = lookup + 4; % переход к следующим четырем строкам в таблице
end

% Определение количества битов, необходимых для представления одного байта.
if ((lookup >= 1) && (lookup <= 36))
    bitpad = 8;
elseif ((lookup > 36) && (lookup <= 104))
    bitpad = 16;
else
    bitpad = 16;
end

% Режим - байтовый.
mode = qr_mode(3);

% Подсчет количества символов и преобразование в двоичное представление.
chcount = digital_to_binary(len, bitpad); % дополнение битами

% Закодированные данные.
k = 1;
encStr = cell(1, len);
for k = 1:len
    encStr{k} = digital_to_binary(txt(k), 8); % кодирование байтов
end

% Соединение данных в строку.
curr = horzcat(mode, chcount, regexprep(strtrim(sprintf('%s ', encStr{:})), '\W', ''));

% Добавление битов завершения.
clen = length(curr);
bitlen = terr(lookup) * 8;

if (clen < bitlen)
    % Определение битов завершения.
    if (terr(lookup) * 8 - clen > 4)
        termn = '0000';
        i = 4;
    else
        for i = 1:4
            if (i == (bitlen - clen))
                termn = digital_to_binary(0, i);
                break;
            end
        end
    end
    
    % Добавление дополнительных нулевых битов, если необходимо.
    clen2 = clen + i;
    if (mod(clen2, 8) ~= 0)
        while (mod(clen2, 8) ~= 0)
            clen2 = clen2 + 1;
        end
        exBits = digital_to_binary(0, clen2 - clen);
    else
        exBits = '';
    end
    
    curr2 = horzcat(curr, termn, exBits);
    clen2 = length(curr2);
    
    % Добавление битов согласно правилам, если необходимо.
    if (clen2 < bitlen)
        exByts = bitlen - clen2;
        ByStr = cell(1, exByts / 8);
        tog = 0;
        for i = 1:exByts
            if (~tog)
                ByStr{i} = '11101100'; % 237
            else
                ByStr{i} = '00010001'; % 17
            end
            tog = ~tog;
        end
        res = horzcat(curr2, regexprep(strtrim(sprintf('%s ', ByStr{:})), '\W', ''));
    else
        res = curr2;
    end
    
else
    res = curr;
end

ver = lookup; % Возвращается использованный уровень емкости.
end
