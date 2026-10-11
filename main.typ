#import "@local/typst-bsuir-core:1.18.6": *
#import "title.typ": pnayavu-course-project

#set text(font: "Times New Roman", size: 14pt, lang: "ru")
#show math.equation: set text(font: "STIX Two Math", size: 14pt)

#show: gost.with(
  title-template: custom-title-template.from-module(pnayavu-course-project),
  student: (
    name: "Ермаков В.С",
    group: "550503"
  ),
  manager: (
    name: "Ковальчук А.М.",
  ),
  work: (
    topic: "Разработка кроссплатформенного приложения\n«Маркетплейс»",
    code: "6-05-0611-05 305"
  ),
  year: none,
  pagination-align: right,
  margin: (left: 30mm, right: 15mm, top: 20mm, bottom: 20mm),
//   footer: (city: "МИНСК", year: "2026")
)

#show "<<": "«"
#show ">>": "»"

// Нумерация рисунков и таблиц по разделам (например, Таблица 1.1)
#show figure.where(kind: image): set figure(
  numbering: n => {
    let section = counter(heading).get().first()
    numbering("1.1", section, n)
  }
)

#show figure.where(kind: table): set figure(
  numbering: n => {
    let section = counter(heading).get().first()
    numbering("1.1", section, n)
  }
)

#show figure.where(kind: table): set figure(gap: 0.3em)

// Заголовки 1 уровня всегда с новой страницы
#show heading.where(level: 1): it => {
  counter(figure.where(kind: table)).update(0)
  counter(figure.where(kind: image)).update(0)
  pagebreak(weak: true)
  upper(it)
}

#show math.equation: it => {
  show ".": ","
  if it.block { pad(y: 0.5em, it) } else { it }
}

// Настройка содержания
#show outline.entry: it => {
  show linebreak: []
  let clean_body = {
    show "(Обязательное)": ""
    show "(Справочное)": ""
    show strong: it => it.body
    show v: []
    it.body()
  }

  set block(spacing: 0.65em)

  if state("appendixes", false).at(it.element.location()) {
    set text(weight: "regular")
    link(it.element.location(), it.indented(
      none,
      [ПРИЛОЖЕНИЕ #it.prefix() #clean_body]
        + sym.space
        + box(width: 1fr, it.fill)
        + sym.space
        + sym.wj
        + it.page()
    ))
  } else {
    it
  }
}

#set math.equation(numbering: none)
// Межстрочный интервал 1,0 (шаг строк 18 пт) по СТП 01-2024, п. 2.1.1:
// шаг = высота прописной буквы (~9,7 пт) + leading; между абзацами — тот же шаг
#set par(leading: 8.3pt, spacing: 8.3pt, first-line-indent: 1.25cm, justify: true)
// Тире в подписях рисунков и таблиц — «–», как в СТП («Рисунок 2.1 – Название»)
#set figure.caption(separator: [ -- ])

#show heading: it => {
  if it.numbering == none {
    set align(center)
    it
  } else {
    it
  }
}

#show figure.where(kind: table): set align(left)
#show figure.caption.where(kind: table): set align(left)
#set table(align: left + horizon)
#show table: set par(justify: false)

#set list(
  indent: 1.25cm,
  body-indent: 0.5em,
  spacing: 0.65em,
  marker: [--]
)

#show figure: fig => {
  if fig.kind == image { move(dx: -7.5mm, fig) } else { fig }
}

// ====================================================
// ИСТОЧНИКИ: запись списка — #source[текст] <key>, ссылка в тексте — @key -> [n]
// ====================================================

#show figure.where(kind: "source"): it => block(width: 100%, spacing: 8.3pt, align(left, par(
  first-line-indent: (amount: 1.25cm, all: true),
  justify: true,
)[[#it.counter.display()] #it.body]))

#show ref: it => {
  let el = it.element
  if el != none and el.func() == figure and el.kind == "source" {
    link(el.location(), [[#numbering("1", ..el.counter.at(el.location()))]])
  } else {
    it
  }
}

#show figure.where(kind: image): set figure(gap: 1.5em)
#show figure.where(kind: image): set block(above: 2em, below: 1em)

// ====================================================
// АВТОМАТИЧЕСКАЯ ПУНКТУАЦИЯ ДЛЯ СПИСКОВ (ГОСТ)
// ====================================================

// 1. Для маркированных списков (- ...)
#show list: it => {
  if it.has("label") and it.label == <auto-punct> {
    it
  } else {
    let total = it.children.len()
    let new-items = it.children.enumerate().map(((i, item)) => {
      let delim = if i == total - 1 [.] else [;]
      list.item(item.body + delim)
    })
    [#list(..new-items) <auto-punct>]
  }
}

// 2. Сложное перечисление (+ ...) по СТП 01-2024, п. 2.3.7:
// каждый элемент — абзац «1 Текст.» с абзацного отступа, продолжение строк от левого поля.
// Элементы пишутся полными предложениями с прописной буквы и точкой в конце (ставится автором).
#show enum: it => {
  let start = if it.start == auto { 1 } else { it.start }
  for (i, item) in it.children.enumerate() {
    let n = if item.number in (auto, none) { start + i } else { item.number }
    par(first-line-indent: (amount: 1.25cm, all: true))[#n #item.body]
  }
}

// ==========================================
// ТЕКСТ КУРСОВОЙ РАБОТЫ
// ==========================================

#include "task-sheet.typ"

#heading(numbering: none, outlined: false)[СОДЕРЖАНИЕ]
#outline(title: none, depth: 2, indent: auto)

= Введение

Маркетплейсы объединяют покупателей и продавцов в единой системе, в которой можно просматривать товары, сравнивать их характеристики и оформлять заказы. Работа такой системы требует разграничения прав пользователей и организации каталога. Товары разных категорий имеют различные характеристики, поэтому способы их отображения, фильтрации и сортировки должны учитывать выбранную категорию.

Актуальность темы курсового проекта связана с необходимостью организовать работу с каталогом товаров и взаимодействие участников торгового процесса. Разработка настольного приложения позволяет рассмотреть эти задачи в системе с локальным хранением данных и работой без подключения к сети Интернет. При этом необходимо обеспечить согласованность информации в связанных файлах и обработку ошибочных действий пользователя.

Целью курсового проекта является разработка кроссплатформенного приложения "Маркетплейс" с графическим интерфейсом для просмотра и покупки товаров, управления каталогом и обработки заказов. Для реализации выбраны язык программирования "C++" и фреймворк "Qt". Обзор используемых технологий приведен в разделе 1.2.

Для достижения поставленной цели необходимо решить следующие задачи:
- рассмотреть существующие маркетплейсы и методы организации каталога товаров
- определить структуру данных о пользователях, категориях, товарах, заказах и отзывах, а также порядок их хранения в связанных файлах
- спроектировать иерархию классов с не менее чем тремя уровнями наследования и разграничить права покупателя, продавца и администратора
- предусмотреть добавление и изменение категорий и их характеристик администратором во время работы программы
- разработать средства поиска, фильтрации, сортировки и отображения товаров с учетом категории
- реализовать покупку товаров, оформление заказов, размещение отзывов и ответы продавцов на них
- разработать и использовать собственные контейнеры, итераторы и алгоритмы наряду со средствами стандартной библиотеки
- предусмотреть обработку исключительных ситуаций и отмену последних действий при добавлении, редактировании и удалении информации
- разработать пользовательский интерфейс с необходимыми пунктами меню и проверить работу приложения в операционных системах "Windows" и "Linux"

В ходе выполнения проекта необходимо применить на практике методы объектно-ориентированного проектирования, алгоритмы обработки данных и средства построения графического интерфейса. Результатом работы должно стать приложение, реализующее предусмотренные заданием действия для каждой роли пользователя.

#include "01-literature-review.typ"

#include "references.typ"
