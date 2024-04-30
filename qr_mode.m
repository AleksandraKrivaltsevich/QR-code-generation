function res = qr_mode(mode)
% Функция qr_mode возвращает битовую строку, указывающую используемый режим.

switch mode
    case 1 % Числовой режим
        res = '0001';
    case 2 % Алфавитно-цифровой режим
        res = '0010';
    case 3 % Байтовый режим
        res = '0100';
    case 4 % Кандзи режим
        res = '1000';
    case 5 % ECI режим
        res = '0111';
end

end
