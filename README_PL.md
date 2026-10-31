# 🖥️ Raspberry Pi — kiosk aplikacji webowej (Debian 13)

[English README](README.md) · [Instrukcja konfiguracji](docs/SETUP.md) · [Diagnostyka](docs/TROUBLESHOOTING.md)

## O projekcie

Dokumentacja przedstawia konfigurację komputera jednopłytkowego ARM64 jako **terminala kioskowego** do obsługi firmowej aplikacji webowej. Po uruchomieniu Debian 13 automatycznie rozpoczyna sesję graficzną Openbox i otwiera Firefox ESR w trybie pełnoekranowym.

Projekt powstał na podstawie praktycznego wdrożenia i został **zanonimizowany na potrzeby publicznego portfolio**. Z repozytorium usunięto informacje pozwalające zidentyfikować organizację, jej infrastrukturę, konta i systemy wewnętrzne. Przykładowy adres `https://kiosk.example.invalid` nie wskazuje na prawdziwą usługę.

## Technologie

- **Debian 13 ARM64**, systemd i OpenSSH.
- **DRM/KMS, X.Org i modesetting** — obsługa grafiki i HDMI.
- **LightDM** — automatyczne rozpoczęcie sesji dedykowanego użytkownika.
- **Openbox** — lekki menedżer okien i autostart.
- **Firefox ESR** — tryb kiosk.
- **Bash, xset** — uruchamianie aplikacji, restart przeglądarki i wyłączenie wygaszania ekranu.

## Najważniejsze zagadnienia

1. Konfiguracja sterownika grafiki i dobór właściwej karty `/dev/dri/card*`.
2. Automatyczne logowanie użytkownika kiosku przez LightDM.
3. Uruchomienie aplikacji webowej w trybie pełnoekranowym.
4. Ponowne uruchamianie przeglądarki po jej zamknięciu.
5. Diagnostyka problemów z X.Org, sesją i usługami systemowymi.
6. Ochrona danych wrażliwych podczas publikowania dokumentacji technicznej.

## Struktura

| Lokalizacja | Zawartość |
| --- | --- |
| [`README.md`](README.md) | Główna dokumentacja projektu (EN) |
| [`docs/SETUP.md`](docs/SETUP.md) | Instrukcja konfiguracji krok po kroku |
| [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | Architektura i decyzje techniczne |
| [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md) | Typowe problemy i komendy diagnostyczne |
| [`docs/ACCEPTANCE_CHECKLIST.md`](docs/ACCEPTANCE_CHECKLIST.md) | Lista testów odbiorczych |
| [`docs/SECURITY.md`](docs/SECURITY.md) | Zasady bezpieczeństwa i anonimizacji |
| [`config/`](config) | Bezpieczne przykładowe konfiguracje |
| [`scripts/`](scripts) | Skrypt uruchamiający i diagnostyczny |

> **Uwaga:** W publicznej wersji celowo nie udostępniono rzeczywistych danych logowania ani mechanizmu automatycznego wpisywania hasła do systemu firmowego. Przed publikacją projektów powstałych w pracy należy również sprawdzić zasady poufności i prawa do udostępniania dokumentacji.
