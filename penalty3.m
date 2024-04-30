function numpn = penalty3(qrmat)
% Функция penlt3 проверяет наличие шаблона, соответствующего последовательности 
% темный-светлый-темный-темный-темный-светлый-темный с четырьмя светлыми модулями по обе стороны.
sum = 0;
pat1 = [0 1 0 0 0 1 0 1 1 1 1]; % Паттерн 1
pat2 = [1 1 1 1 0 1 0 0 0 1 0]; % Паттерн 2

for i = 1:length(qrmat)
    for j = 1:length(qrmat) - 10
        % Проверка строк на наличие двух паттернов
        if isequal(qrmat(i, j:j+10), pat1)
            sum = sum + 40;
        end
        if isequal(qrmat(i, j:j+10), pat2)
            sum = sum + 40;
        end
        
        % Проверка столбцов на наличие двух паттернов
        if isequal(qrmat(j:j+10, i), pat1')
            sum = sum + 40;
        end
        if isequal(qrmat(j:j+10, i), pat2')
            sum = sum + 40;
        end
    end
end

numpn = sum;
end
