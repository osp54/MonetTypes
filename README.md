# MonetTypes
MonetTypes - набор типов данных для скриптов MonetLoader, форк [moonloader-definitions](https://github.com/GovnocodedByChapo/moonloader-definitions).
Отличия от оригинала:
- Помечены функции как deprecated, которые не поддерживаются в MonetLoader
- Добавлены новые типы данных (ивент onTouch, MONET_DPI_SCALE, MONET_VERSION, и т.д.)
## Установка
1. Склонируйте репозиторий
  - `git clone https://github.com/osp54/MonetTypes`
2. Добавьте в `.vscode/settings.json` вашего проекта путь к папке `library` в репозитории MonetTypes:
```json
{
  "Lua.workspace.library": ["путь к папке library в репозитории MonetTypes"]
}
```