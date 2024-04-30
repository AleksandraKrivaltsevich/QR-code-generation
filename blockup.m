function res = blockup( rawbits , luval , errcap)
% Функция blockup разделяет битовые строки на различные блоки с учётом параметров уровня коррекции ошибок и версии QR-кода.

numblks = errcap(luval , 3) + errcap(luval , 5); % Вычисляем общее количество блоков на основе параметров уровня коррекции ошибок и версии QR-кода
blcks = cell(1,numblks); % Инициализируем ячейковый массив для хранения блоков
k = 1; % Инициализируем переменную-счётчик

% Проходим по каждому блоку
for i = 1:numblks 
    if(i <= errcap(luval , 3) ) % Если текущий блок относится к информационным блокам
        % Добавляем текущий блок в ячейковый массив, выделяя соответствующее количество битов из исходных данных
        blcks(i) = {rawbits(k : k + 8*errcap(luval , 4) - 1)};
        k = k + 8*errcap(luval , 4); % Обновляем счётчик для перехода к следующему блоку
    else
        % Добавляем текущий блок в ячейковый массив, выделяя соответствующее количество битов из исходных данных
        blcks(i) = {rawbits(k : k + 8*errcap(luval , 6) - 1)};
        k = k + 8*errcap(luval , 6); % Обновляем счётчик для перехода к следующему блоку
    end
end

res = blcks; % Возвращаем массив блоков в качестве результата работы функции
end