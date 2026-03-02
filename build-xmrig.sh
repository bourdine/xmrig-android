#!/bin/bash
echo "Подготовка нативного кода XMRig для Android..."

# Создаём целевую папку, если её нет
mkdir -p app/src/main/cpp

# Проверяем, существует ли папка xmrig_custom_source (подмодуль с исходниками)
if [ -d "xmrig_custom_source" ]; then
    echo "Копируем файлы из xmrig_custom_source в app/src/main/cpp"
    cp -r xmrig_custom_source/* app/src/main/cpp/ 2>/dev/null
    echo "Копирование завершено."
else
    echo "Ошибка: папка xmrig_custom_source не найдена!"
    echo "Возможно, не инициализированы подмодули. Проверьте наличие папки."
    exit 1
fi

# Проверяем, что miner.cpp теперь существует
if [ -f "app/src/main/cpp/miner.cpp" ]; then
    echo "✅ miner.cpp найден."
else
    echo "⚠️  ВНИМАНИЕ: miner.cpp не найден после копирования."
    echo "Возможно, структура xmrig_custom_source другая. Нужно будет уточнить."
fi

echo "Готово."
