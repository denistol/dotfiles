#!/usr/bin/env python3
"""
Скрипт для сопряжения Apple Keyboard в Linux (BlueZ / bluetoothctl).
1. Удаляет старую привязку устройства.
2. Включает сканирование и ждёт появления клавиатуры.
3. При обнаружении отправляет запрос на сопряжение (pair).
4. Выводит крупный PIN-код / Passkey для ввода на клавиатуре.
5. При успешном сопряжении добавляет в доверенные (trust) и подключает (connect).
"""

import errno
import os
import pty
import re
import select
import signal
import sys
import time

time.sleep(10)

DEFAULT_MAC = "C4:14:11:02:83:7B"
DEVICE_MAC = sys.argv[1].upper() if len(sys.argv) > 1 else DEFAULT_MAC

ANSI_REGEX = re.compile(r"\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])")


def clean_ansi(text: str) -> str:
    return ANSI_REGEX.sub("", text)


def print_banner(pin: str):
    border = "═" * 56
    print(f"\n\033[1;33m╔{border}╗")
    print("║" + " " * 56 + "║")
    print("║     ВВЕДИТЕ ЭТОТ КОД НА КЛАВИАТУРЕ APPLE И НАЖМИТЕ ENTER:     ║")
    print("║" + " " * 56 + "║")
    print(f"║\033[1;32m{pin.center(56)}\033[1;33m║")
    print("║" + " " * 56 + "║")
    print(f"╚{border}╝\033[0m\n", flush=True)


def main():
    print(f"\033[1;34m[i] Целевой MAC-адрес клавиатуры: {DEVICE_MAC}\033[0m")
    print(
        "\033[1;34m[i] Убедитесь, что клавиатура включена (или выключите и включите тумблер).\033[0m\n"
    )

    master, slave = pty.openpty()
    pid = os.fork()

    if pid == 0:
        os.close(master)
        os.setsid()
        os.dup2(slave, 0)
        os.dup2(slave, 1)
        os.dup2(slave, 2)
        os.close(slave)
        os.execlp("bluetoothctl", "bluetoothctl")
        sys.exit(1)

    os.close(slave)

    def cleanup(signum=None, frame=None):
        try:
            os.write(master, b"scan off\nquit\n")
            time.sleep(0.3)
            os.kill(pid, signal.SIGTERM)
        except Exception:
            pass
        print("\n\033[1;30m[i] Выход.\033[0m")
        sys.exit(0)

    signal.signal(signal.SIGINT, cleanup)
    signal.signal(signal.SIGTERM, cleanup)

    def send_cmd(cmd: str):
        try:
            os.write(master, (cmd + "\n").encode("utf-8"))
        except OSError:
            pass

    time.sleep(0.5)
    print(
        "\033[1;36m[1/4] Инициализация Bluetooth и удаление старого сопряжения...\033[0m"
    )
    send_cmd("power on")
    send_cmd("default-agent")
    send_cmd(f"remove {DEVICE_MAC}")
    time.sleep(0.5)

    print(
        f"\033[1;36m[2/4] Запуск сканирования. Ожидание события '[NEW] Device {DEVICE_MAC}'...\033[0m"
    )
    send_cmd("scan on")

    pairing_attempted = False
    paired_success = False
    connected_success = False
    last_pin = None
    buffer = ""

    while True:
        try:
            rlist, _, _ = select.select([master, sys.stdin.fileno()], [], [], 0.5)
        except (OSError, select.error) as e:
            if getattr(e, "errno", None) == errno.EINTR:
                continue
            break

        # Проброс пользовательского ввода из консоли в bluetoothctl
        if sys.stdin.fileno() in rlist:
            try:
                user_input = os.read(sys.stdin.fileno(), 1024)
                if user_input:
                    os.write(master, user_input)
            except OSError:
                pass

        if master in rlist:
            try:
                data = os.read(master, 2048)
                if not data:
                    break
            except OSError as e:
                if e.errno == errno.EIO:
                    break
                raise

            text_chunk = data.decode("utf-8", errors="ignore")
            buffer += text_chunk

            # Обрабатываем построчно
            while "\n" in buffer:
                line, buffer = buffer.split("\n", 1)
                clean = clean_ansi(line).strip()
                if not clean:
                    continue

                # Отладочный / информационный вывод ключевых строк
                if (
                    "Device " in clean
                    or "Failed" in clean
                    or "successful" in clean
                    or "agent" in clean
                ):
                    print(f"  \033[2m>> {clean}\033[0m")

                # Обнаружение устройства: сопряжение стартует строго при появлении "[NEW] Device <MAC>"
                target_trigger = f"[NEW] Device {DEVICE_MAC}".lower()
                if target_trigger in clean.lower() and not pairing_attempted:
                    print(
                        f"\n\033[1;32m[+] Обнаружено: '{clean}'!\033[0m"
                    )
                    print(
                        f"\033[1;32m[+] Запускаем сопряжение (pair {DEVICE_MAC})...\033[0m"
                    )
                    pairing_attempted = True
                    send_cmd(f"pair {DEVICE_MAC}")

                # Запрос подтверждения passkey
                confirm_match = re.search(
                    r"Confirm passkey\s*(\d+)", clean, re.IGNORECASE
                )
                if confirm_match:
                    pin = confirm_match.group(1)
                    if pin != last_pin:
                        last_pin = pin
                        print_banner(pin)
                    send_cmd("yes")

                # Вывод passkey / PIN code
                pin_match = re.search(
                    r"(?:Passkey|PIN code|PIN|passkey):\s*(\d+)", clean, re.IGNORECASE
                )
                if pin_match:
                    pin = pin_match.group(1)
                    if pin != last_pin:
                        last_pin = pin
                        print_banner(pin)

                # Запрос на ручной ввод PIN (legacy pairing)
                if "Enter PIN code:" in clean:
                    print("\033[1;33m[!] BlueZ запросил PIN. Отправляем 0000...\033[0m")
                    send_cmd("0000")
                    print_banner("0000")

                # Успешное сопряжение
                if "Pairing successful" in clean:
                    paired_success = True
                    print("\n\033[1;32m[3/4] Сопряжение прошло успешно!\033[0m")
                    print(
                        "\033[1;36m[4/4] Добавляем в доверенные (trust) и подключаем (connect)...\033[0m"
                    )
                    send_cmd(f"trust {DEVICE_MAC}")
                    send_cmd(f"connect {DEVICE_MAC}")
                    send_cmd("scan off")

                # Ошибка сопряжения
                if "Failed to pair" in clean:
                    print(f"\n\033[1;31m[-] Ошибка сопряжения: {clean}\033[0m")
                    print(
                        "\033[1;33m[i] Выключите и снова включите клавиатуру. Попробуем снова через 3 секунды...\033[0m"
                    )
                    time.sleep(3)
                    pairing_attempted = False
                    send_cmd(f"remove {DEVICE_MAC}")
                    send_cmd("scan on")

                # Успешное подключение
                if "Connection successful" in clean:
                    connected_success = True
                    print(
                        f"\n\033[1;32m[✔] Клавиатура ({DEVICE_MAC}) успешно подключена и готова к работе!\033[0m\n"
                    )
                    cleanup()

    cleanup()


if __name__ == "__main__":
    main()
