function [res, ver] = qr_numeric(txt, len, ecc, tcap, terr)
% Кодирование числовой строки QR.

cnt = 0; tog = 0; extrr = 0;

% Определение уровня коррекции ошибок и выбор соответствующего количества битов для кодирования.
if    (ecc == 'L')
    lookup = 1;
elseif(ecc == 'M')
    lookup = 2;
elseif(ecc == 'Q')
    lookup = 3;
elseif(ecc == 'H')
    lookup = 4;
else
    fprintf('Not valid ECC level.\n');
end

while (len > tcap(lookup))
    lookup = lookup + 4; % Переход на четыре строки в таблице
end

if ((lookup >= 1) && (lookup <= 36))
    bitpad = 10;
elseif ((lookup > 36) && (lookup <= 104))
    bitpad = 12;
else
    bitpad = 14;
end

% Режим и количество символов.
mode = qr_mode_ind(1);
chcount = digital_to_binary(len, bitpad);

% Кодирование данных.
k = 1; bts = 10; i = 1;
encStr = cell(1, ceil(len / 3));

while (k <= len)
    if (mod(k, 3) == 0)
        encStr(i) = {digital_to_binary(str2double(txt(k-2:k)), 10)}; % Получение троек цифр
        i = i + 1;
    end
    if (k == len)
        if (mod(k+1, 3) == 0)
            encStr(i) = {digital_to_binary(str2double(txt(k-1:k)), 7)}; % Две цифры в 7 битах   
            i = i + 1;
        end
        if (mod(k-1, 3) == 0)
            encStr(i) = {digital_to_binary(str2double(txt(k)), 4)}; % Одна цифра в 4 битах 
            i = i + 1;
        end
    end
    k = k + 1;
end

% Добавление завершающих битов.
curr = horzcat(mode, chcount, regexprep(strtrim(sprintf('%s ', encStr{:})), '\W', ''));
clen = length(curr);
bitlen = terr(lookup) * 8;

if (clen < bitlen)
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
    
    % Добавление дополнительных нулевых битов.
    clen2 = clen + i;
    if (mod(clen2, 8) ~= 0)
        while (mod(clen2, 8) ~= 0)
            clen2 = clen2 + 1;
            extrr = extrr + 1;
        end
        exBits = digital_to_binary(0, extrr);
    else
        exBits = '';
    end
    
    curr2 = horzcat(curr, termn, exBits);
    clen2 = length(curr2);
    
    % Добавление дополнительных нулевых битов.
    if (clen2 < bitlen)
        exByts = bitlen - clen2;
        ByStr  = cell(1, exByts / 8);
        i = 1;
        while (exByts > 0)
            if (~tog)
                ByStr{i} = '11101100'; % 237
            else
                ByStr{i} = '00010001'; % 17
            end
            tog = ~tog; % Переключение бита
            i = i + 1;
            exByts = exByts - 8;
        end
        res = horzcat(curr2, regexprep(strtrim(sprintf('%s ', ByStr{:})), '\W', ''));
    else
        ByStr = '';
        res = curr2;
    end
    
else
    res = curr;
end

ver = lookup;
end
