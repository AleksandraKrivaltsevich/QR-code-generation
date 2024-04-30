function res = generate_format_string( ecc , masknum )
% Функция генерирует строку формата для QR-кода (15 бит).

if(ecc == 'L')
    ecbits = '01'; % Уровень коррекции ошибок L
elseif(ecc == 'M')
    ecbits = '00'; % Уровень коррекции ошибок M
elseif(ecc == 'Q')
    ecbits = '11'; % Уровень коррекции ошибок Q
elseif(ecc == 'H')
    ecbits = '10'; % Уровень коррекции ошибок H
else
    error('Not a valid correction level.'); % Выводится сообщение об ошибке, если уровень коррекции ошибок недопустим
end

maskbits = digital_to_binary( masknum , 3); % Преобразование номера маски в 3-битную двоичную строку
fivbits = strcat(ecbits , maskbits); % Объединение битов уровня коррекции ошибок и битов маски

bitss = strcat(fivbits, digital_to_binary(0,10)); % Дополнение 10 нулями и объединение с битами уровня коррекции ошибок и маски
k = 1;
zroflag = 0;

while(bitss(k) == '0') % Поиск первой единицы в строке
    k = k + 1;
    if(k == 16)
        k = 1;
        zroflag = 1; % Установка флага, если все биты равны нулю
        break;
    end
end

if(zroflag) % Если все биты равны нулю
    res = '101010000010010'; % Возвращаем стандартную строку
else
    bitss = bitss(k:end); % Удаляем начальные нули
    
    genpstr = '10100110111'; % Строка для генерации
    bits1   = bitss; % Копия битов
    
    while(length(bits1) > 10) % Пока длина битов больше 10
        dif = length(bits1)-length(genpstr); % Разница в длине
        genp1 = strcat(genpstr , digital_to_binary(0,dif)); % Дополнение строки генерации нулями
        bits1  = regexprep( num2str(genp1 ~= bits1) , '\W' , ''); % Выполнение операции XOR между строками
        while(bits1(k) == '0') % Удаление ведущих нулей
            k = k + 1;
        end
        bits1 = bits1(k:end); % Обновление битов
        k = 1;
    end
    
    if(length(bits1) < 10) % Если длина битов меньше 10
        bits1 = strcat(digital_to_binary(0 , 10 - length(bits1)) , bits1); % Дополнение нулями до 10 бит
    end
    
    %% Объединяем XOR результат с 5-битной строкой формата
    cmbnd = strcat(fivbits , bits1); % Объединяем биты уровня коррекции ошибок и маски с результатом XOR
    
    %% Финальное выполнение XOR с строкой 101010000010010
    res = regexprep( num2str(cmbnd ~= '101010000010010') , '\W' , ''); % Финальная операция XOR с заданной строкой
end

end
