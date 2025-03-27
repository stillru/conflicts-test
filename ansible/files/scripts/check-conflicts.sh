#!/bin/bash
set -e

# Функция для проверки библиотечных зависимостей
check_library_conflicts() {
    # Собираем список всех установленных пакетов
    rpm -qa > /tmp/installed_packages.txt
    
    # Анализируем зависимости
    echo "Проверка конфликтов библиотек:"
    
    # Ищем пакеты с потенциально конфликтующими библиотеками OpenSSL
    echo "Поиск пакетов с библиотеками OpenSSL:"
    ssl_libraries=$(find /usr/lib64 -name "libssl.so.*" -o -name "libcrypto.so.*")
    
    if [ -z "$ssl_libraries" ]; then
        echo "Библиотеки OpenSSL не найдены"
        return 0
    fi
    
    conflicts=$(rpm -qf $ssl_libraries | sort | uniq)
    
    echo "Пакеты с библиотеками OpenSSL:"
    echo "$conflicts"
    
    # Проверяем версии библиотек
    echo -e "\nВерсии библиотек:"
    for pkg in $conflicts; do
        echo "Пакет $pkg:"
        rpm -q --provides $pkg
    done
    
    # Проверка на конфликты версий
    echo -e "\nПроверка версий библиотек:"
    echo "$conflicts" | while read -r pkg; do
        version=$(rpm -q --queryformat '%{VERSION}' "$pkg")
        echo "$pkg: версия $version"
    done
    
    # Дополнительный анализ зависимостей
    echo -e "\nПолный список зависимостей:"
    echo "$conflicts" | while read -r pkg; do
        echo "Зависимости $pkg:"
        rpm -qR "$pkg"
    done
}

# Функция для генерации отчета о конфликтах
generate_conflict_report() {
    echo "=== Отчет о конфликтах библиотек ==="
    
    # Создаем директорию для отчетов, если не существует
    mkdir -p /var/log/library_conflicts
    
    # Генерируем timestamped отчет
    report_file="/var/log/library_conflicts/conflict_report_$(date +%Y%m%d_%H%M%S).txt"
    
    # Выполняем проверку и сохраняем результат в файл
    check_library_conflicts > "$report_file"
    
    echo "Отчет сохранен в $report_file"
}

# Выбор режима работы
case "$1" in
    "check")
        check_library_conflicts
        ;;
    "report")
        generate_conflict_report
        ;;
    *)
        echo "Использование: $0 {check|report}"
        exit 1
        ;;
esac