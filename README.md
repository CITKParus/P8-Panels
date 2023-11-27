# P8-Panels

# "Панели" расширение к "ПАРУС 8 Онлайн"

## Термины и сокращения

**Система** - "ПАРУС 8 Предприятие"\
**БД** - База Данных\
**СУБД** - Система Управления Базами Данных\
**Расширение** - программный комплекс, дополняющий функциональность той или иной программной системы. В контексте данного документа (если не указано иное) - описываемое расширение "Панели".\
**Фреймворк** - программная платформа, определяющая структуру программной системы, программное обеспечение, облегчающее разработку и объединение разных компонентов большого программного проекта. В контексте данного документа (если не указано иное) - описываемое расширение "Панели".\
**Панель** - представление данных и функций Системы, реализованное с применением описываемого фреймворка\
**SPA** - Single Page Application - технология разработки WEB-приложений, предполагающая динамическую генерацию интерфейса внутри одного HTML-документа, отображаемого браузером\
**HTML** - HyperText Markup Language — язык гипертекстовой разметки\
**CSS** - Cascading Style Sheets - каскадные таблицы стилей\
**DOM** - Document Object Model - объектная модель документа (в контексте данного документа - HTML)\
**JS** - JavaScript — мультипарадигменный интерпретируемый язык программирования\
**JSX** - JavaScript eXtension - расширение JavaScript, которое позволяет создавать деревья DOM с использованием синтаксиса, подобного XML

## Назначение

Расширение представляет собой фреймворк, основной задачей которого является сокращение времени разработки нестандартных графических интерфейсов и панелей мониторинга, работающих в составе WEB-приложения "ПАРУС 8 Онлайн".

## Состав

В расширение входят:

-   Библиотека расширения "P8-Panels-ParusOnlineExt.dll" для сервера приложений "ПАРУС 8 Онлайн" - обеспечивает низкоуровневое взаимодействие разрабатываемых панелей с Системой
-   Хранимые объекты сервера БД Системы, обеспечивающие обмен данными между панелями и учётными регистрами Системы
-   API для высокоуровневого взаимодействия с сервером БД Системы
-   API для взаимодействия разрабатываемых панелей с WEB-приложением "ПАРУС 8 Онлайн"
-   WEB-приложение "Парус 8 - Панели мониторинга", являющееся "точкой входа" для подключения реализуемых панелей, включающее в себя:
    -   Подключенные и настроенные библиотеки ["React"](https://react.dev/), ["React-Router"](https://reactrouter.com/), ["MUI"](https://mui.com/)
    -   Настроенный транспайлер ["Babel"](https://babeljs.io/)
    -   Настроенный сборщик WEB-приложений ["WebPack"](https://webpack.js.org/)
    -   Настроенный статический анализатор кода ["ESLint"]()
    -   Настройки среды разработки ["Visual Studio Code"](https://code.visualstudio.com/)
    -   Готовый контекст React-приложения
    -   Компоненты для отображения единого бокового меню подключенных панелей, галереи подключенных панелей, интеграции в рабочий стол WEB-приложения "ПАРУС 8 Онлайн"
    -   Готовые панели мониторинга для ряда прикланых приложений Системы

## Требования к разработчику

Для успешной разработки собственных панелей, с применением описываемого фреймворка потребуются знания следующих технологий:

-   HTML, CSS, JS, JSX
-   Разработка SPA WEB-приложений
-   Знакомство с основами работы перечисленных выше библиотек и системных средств (в первую очередь "React")
-   Знание архитектуры Системы, принципов работы и организации её серверной части

## Установка

1. Установите сервер приложений "ПАРУС 8 Онлайн" согласно документации (см. "Парус-Онлайн 2. Часть 1. Установка ГГГГ.ММ.docx").
2. Разместите на диске сервера приложений библиотеку расширения "P8-Panels-ParusOnlineExt", для этого скопируйте содержимое папки "bin" из [репозитория расширения "P8-Panels-ParusOnlineExt"](https://github.com/CITKParus/P8-Panels-ParusOnlineExt), например, в каталог "C:\p8web20\Ext\P8-Panels-ParusOnlineExt".
3. Подключите библиотеку расширения к серверу приложений "ПАРУС 8 Онлайн". Для этого добавьте ссылку на библиотеку в файл "Config\extensions.config" сервера приложений:

```
<?xml version="1.0"?>
<parus.extensions enabled="true" resolveKind="Static" viewsMode="Shared" rootPath="c:\p8web20\Ext\">
	<extensions>
		<extension assembly="P8PanelsParusOnlineExt" path="P8-Panels-ParusOnlineExt\bin\P8-Panels-ParusOnlineExt.dll"/>
	</extensions>
</parus.extensions>
```

Где:

-   `rootPath="c:\p8web20\Ext\"` - атрибут, указывающий на корневой каталог хранения расширений для сервера приложений "ПАРУС 8 Онлайн"\
-   `path="P8-Panels-ParusOnlineExt\bin\P8-Panels-ParusOnlineExt.dll"` - атрибут, указывающий на каталог размещения библиотеки расширения "Панели" относительного коревого `rootPath`.\

Затем, установите в файле конфигурации "PrecompiledApp.config" сервера приложений атрибут `updatable` в `true`:

```
<precompiledApp version="2" updatable="true"/>
```

4. Разместите WEB-приложение "Парус 8 - Панели мониторинга" на сервере приложений "ПАРУС 8 Онлайн". Для этого в каталоге "Modules" сервера приложений создайте подкаталог "P8-Panels" и проведите клонирование репозитория ["P8-Panels"](https://github.com/CITKParus/P8-Panels) в него:

```
git clone https://github.com/CITKParus/P8-Panels.git
```

5. Проведите компиляцию хранимых объектов БД из каталога "db" клонированного репозитория (компиляцию проводить под пользователем-владельцем схемы серверной части Системы, с последующей перекомпиляцией зависимых инвалидных объектов), затем исполните скрипт "grants.sql", размещённый в этом же каталоге.

6. Перезапустите сервер приложений "ПАРУС 8 Онлайн"

## Подключение поставляемых панелей мониторинга

## Разработка пользовательских панелей

### Общие сведения

### API для взаимодействия с сервером "ПАРУС 8 Предприятие"

### Компоненты пользовательского интерфейса

#### Типовые интерфейсные примитивы

##### Компоненты MUI

##### Сообщения "P8PAppMessage", "P8PAppInlineMessage"

##### Индикатор загрузки "P8PAppProgress"

#### Высокоуровневые компоненты

##### Таблица данных "P8PDataGrid"

##### Графики "P8PChart"

##### Диаграмма ганта "P8PGantt"

### API для взаимодействия с WEB-приложением "ПАРУС 8 Онлайн"
