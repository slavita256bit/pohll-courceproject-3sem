#import "@local/typst-bsuir-core:1.18.6": *
#import "title.typ": pnayavu-course-project

// Настройки шрифтов по ГОСТ
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
  // Поля по СТП 01-2024, п. 2.1.1: слева 30, справа 15, сверху и снизу 20 мм
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

Развитие систем электронной коммерции требует создания надежных, масштабируемых и удобных в использовании программных продуктов. Современные маркетплейсы объединяют множество участников торгового процесса, что обуславливает необходимость четкого разделения прав доступа и ролей, а также гибкого подхода к хранению структур данных, описывающих разнообразные товары.

Целью данной курсовой работы является разработка кроссплатформенного приложения "Маркетплейс" на языке программирования "C++" с использованием графического фреймворка "Qt".

Эффективная реализация подобной системы напрямую зависит от выбора технологического стека. Язык программирования высокого уровня "C++" сочетает в себе высокую производительность и развитые средства объектно-ориентированного проектирования, что критически важно для построения масштабируемой архитектуры и быстрой обработки больших объемов информации. Использование кроссплатформенного фреймворка "Qt" дополняет возможности языка, обеспечивая создание отзывчивого графического интерфейса.

Для достижения поставленной цели необходимо решить следующие задачи:
- спроектировать объектно-ориентированную архитектуру приложения для управления информацией о пользователях, товарах и категориях
- реализовать систему динамического формирования категорий, позволяющую добавлять новые свойства и характеристики товаров во время выполнения программы
- разработать алгоритмы поиска, многокритериальной фильтрации и сортировки каталога товаров с учетом динамически настраиваемых полей
- разработать механизмы долговременного хранения данных с использованием бинарных и текстовых файлов
- обеспечить корректную параллельную работу нескольких экземпляров приложения за счет безопасного конкурентного доступа к файлам
- разработать систему аутентификации и разграничения прав доступа пользователей (администратор, продавец, покупатель)
- спроектировать и реализовать графический интерфейс пользователя (GUI)
- провести тестирование работоспособности разработанного приложения на операционных системах семейств "Windows" и "Linux"

В основу разработки должны быть заложены принципы объектно-ориентированного проектирования и независимости алгоритмов обработки и хранения данных от графического интерфейса, чтобы упростить дальнейшее масштабирование функционала системы.

#include "01-literature-review.typ"

#include "references.typ"
