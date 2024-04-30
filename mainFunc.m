function res = mainFunc(txt, ecc)

load('qrtab.mat');
close all

count = length(txt);

ver = 1;
coll = 1;

%% Выбор режима кодирования

txtMod = txt;
txtMod(txtMod == ' ') = '';

if any(isstrprop(txtMod, 'lower')) % Проверка наличия строчных букв
    alnm_cap = charcap(:, 3);
    alnm_err = errcap(:, 1);
    coll = 3;
    [raw, luval] = qr_byte(txt, count, ecc, alnm_cap, alnm_err);
else
    if sum(isstrprop(txtMod, 'upper')) == length(txtMod) % Проверка наличия только прописных букв
        alnm_cap = charcap(:, 2);
        alnm_err = errcap(:, 1);
        coll = 2;
        [raw, luval] = qr_alphanumeric(txt, count, ecc, alnm_cap, alnm_err);
    else % Строго числовые символы
        alnm_cap = charcap(:, 1);
        alnm_err = errcap(:, 1);
        coll = 1;
        [raw, luval] = qr_numeric(txt, count, ecc, alnm_cap, alnm_err);
    end
end

splt = blockup(raw, luval, errcap);
errcod = zeros(length(splt), errcap(luval, 2));
datcod = zeros(length(splt), max(errcap(luval, 4), errcap(luval, 6)));
Gpol = generate_polynomial(errcap(luval, 2), gftab);

%% Генерация многочлена сообщения и кодов ошибок для каждого блока
for i = 1:length(splt)
    Mpol = generate_message_polynomial(splt{i});
    errcod(i, :) = div_polynomials(Mpol, Gpol, errcap(luval, 2), gftab);
    datcod(i, 1:length(Mpol)) = Mpol;
end

%% Перемешивание кодов
intr = interleave_data_and_error_codewords(datcod, errcod, errcap(luval, :));

%% Преобразование сообщения в двоичный вид
fmsg = numbersToBinaryString(intr);

%% Добавление остаточных битов
ver = ceil(luval/4);
rb = remcap(ver);
if (rb)
    fmsg = horzcat(fmsg, digital_to_binary(0, rb));
end

if (ver == 1)
    A = qrmodule(ver, fmsg, [], ecc);     
else
    A = qrmodule(ver, fmsg, algtab(ver - 1, :), ecc);
end

res = A;
end
