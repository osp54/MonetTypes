-- Функция для чтения файла и извлечения функций и переменных
local function parseFile(filePath)
    local file = io.open(filePath, "r")  -- Открываем файл для чтения
    if not file then return nil end  -- Проверяем успешность открытия файла
    
    local functionsAndVariables = {}  -- Массив для хранения функций и переменных

    -- Читаем файл построчно
    for line in file:lines() do
        -- Извлекаем имя функции или переменной, игнорируя HTML-теги и ссылки
        local functionName = line:match("function%s+([%w_%.]+)%(")
        local variableName = line:match("([%w_]+)%s*=")

        if not line:find("---") and functionName then
            table.insert(functionsAndVariables, functionName)  -- Добавляем имя функции в массив
        elseif not line:find("---") and variableName then
            table.insert(functionsAndVariables, variableName)  -- Добавляем имя переменной в массив
        end
    end

    file:close()  -- Закрываем файл
    return functionsAndVariables  -- Возвращаем массив строк
end


-- Пример использования парсера
local filePath = "library/moonloader.lua"
local result = parseFile(filePath)


-- save as txt in format lua table
local file = io.open("result.txt", "w")
file:write("{\n")
for i, v in ipairs(result) do
    file:write("    \""..v.."\",\n")
end
file:write("}")
file:close()
print("Done!")