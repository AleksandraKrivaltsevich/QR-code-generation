function res = alphanumeric_encoding( chrc )
% Функция возвращает значение для алфавитно-цифрового символа

if (character >= '0' && character <= '9')     % Если символ является цифрой ASCII
    value = 1 * character - 48;
    
elseif (character >= 'A' && character <= 'Z') % Если символ - прописная буква ASCII
    value = 1 * character - 55;

elseif (character == ' ')                     % Если символ - пробел
    value = 1 * character + 4;       

elseif (character == '$' || character == '%') % Если символ - знак доллара или процента
    value = 1 * character + 1;

elseif (character == '*' || character == '+') % Если символ - знак умножения или плюса
    value = 1 * character - 3;

elseif (character == '-' || character == '.' || character == '/') % Если символ - знак минуса, точки или косой черты
    value = 1 * character - 4; 
    
elseif (character == ':')                     % Если символ - двоеточие
    value = 1 * character - 14;  

else
    value = 0;
    fprintf('Недопустимый символ.\n');       % Выводим сообщение об ошибке для недопустимых символов
end

result = value;
end