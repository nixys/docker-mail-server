/* additional parameters for logging: we log to stderr */

# Включение логирования
logging {
    # Уровень логирования: debug, info, warn, error
    level = "info";
    # Файл логов
    file = "/var/log/rspamd/rspamd.log";
    # Размер файла лога перед его ротацией
    max_size = "10MB";
    # Количество архивов файлов логов
    keep = 5;
}
