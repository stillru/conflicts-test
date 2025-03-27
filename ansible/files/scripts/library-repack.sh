#!/bin/bash
set -e

# Функция для перепаковки библиотеки
repack_library() {
    local orig_lib="$1"
    local new_name="$2"
    local new_soname="$3"

    # Копируем библиотеку
    cp "$orig_lib" "/usr/local/lib/$new_name"

    # Обновляем SONAME
    patchelf --set-soname "$new_soname" "/usr/local/lib/$new_name"

    # Находим и обновляем все бинарные файлы
    find / -type f -executable 2>/dev/null | while read -r binary; do
        # Проверяем, использует ли бинарник оригинальную библиотеку
        if ldd "$binary" 2>/dev/null | grep -q "$(basename "$orig_lib")"; then
            echo "Обновляем зависимости для $binary"
            patchelf --replace-needed "$(basename "$orig_lib")" "$new_name" "$binary" || true
        fi
    done

    # Обновляем кэш библиотек
    ldconfig
}

# Список проблемных библиотек
LIBRARIES=(
    "/usr/lib64/libssl.so.1.1"
    "/usr/lib64/libcrypto.so.1.1"
)

# Перепаковываем каждую библиотеку
for lib in "${LIBRARIES[@]}"; do
    base_name=$(basename "$lib")
    repack_library "$lib" "lib_custom_${base_name}" "$base_name"
done
