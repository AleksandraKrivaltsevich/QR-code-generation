function [res, vers] = qr_alphanumeric(txt, len, ecc, tcap, terr)
% Функция qr_alphanum генерирует часть закодированного QR-кода для алфавитно-цифровых данных.
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
    error('Недопустимый уровень ECC.\n');
end

% Нахождение соответствующего уровня емкости в таблице.
while (len > tcap(lookup))
    lookup = lookup + 4; % переход к следующим четырем строкам в таблице
end

% Определение количества битов, необходимых для представления одного символа.
if ((lookup >= 1) && (lookup <= 36))
    bitpad = 9;
elseif ((lookup > 36) && (lookup <= 104))
    bitpad = 11;
else
    bitpad = 13;
end

% Режим - алфавитно-цифровой.
mode = qr_mode_ind(2);

% Подсчет количества символов и преобразование в двоичное представление.
chcount = digital_to_binary(len, bitpad);

% Закодированные данные.
k = 1; 
bts = 11; % количество битов для одного символа
if (mod(len, 2)) % кодирование в парах
    lim = (len + 1) / 2;
    odnum = 1;
else
    lim = len / 2;
    odnum = 0;
end
encStr = cell(1, lim);

for i = 1:lim
    if ((i == lim) && (odnum))
        pair = alphanumeric_encoding(txt(k));
        bts = 6; % для нечетного числа символов используется 6 бит
    else
        pair = 45 * alphanumeric_encoding(txt(k)) + alphanumeric_encoding(txt(k + 1));
    end
    encStr{i} = digital_to_binary(pair, bts);
    k = k + 2;
end

% Добавление битов завершения.
curr = horzcat(mode, chcount, regexprep(strtrim(sprintf('%s ', encStr{:})), '\W', ''));

% Дополнение до необходимой длины битами завершения и, при необходимости, дополнительными нулевыми битами.
clen = length(curr);
bitlen = terr(lookup) * 8;

if (clen < bitlen)
    if (bitlen - clen > 4)
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

vers = lookup; % Возвращается использованный уровень емкости.
end
