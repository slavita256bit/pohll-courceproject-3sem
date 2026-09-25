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
    code: ""
  ),
  year: none,
  pagination-align: right,
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
#set par(spacing: 0.8em, first-line-indent: 1.25cm, justify: true)

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

// Списки по ГОСТ (скобка в нумерации)
#set enum(
  indent: 1.25cm,
  body-indent: 0.5em,
  spacing: 0.65em,
  numbering: "1)"
)

#set list(
  indent: 1.25cm,
  body-indent: 0.5em,
  spacing: 0.65em,
  marker: [--]
)

#show figure: fig => {
  if fig.kind == table { fig } else { move(dx: -7.5mm, fig) }
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

// 2. Для нумерованных списков (+ ...)
#show enum: it => {
  if it.has("label") and it.label == <auto-punct> {
    it
  } else {
    let total = it.children.len()
    let new-items = it.children.enumerate().map(((i, item)) => {
      let delim = if i == total - 1 [.] else [;]
      enum.item(item.body + delim)
    })
    [#enum(..new-items) <auto-punct>]
  }
}

// ==========================================
// ТЕКСТ КУРСОВОЙ РАБОТЫ
// ==========================================

#heading(numbering: none, outlined: false)[СОДЕРЖАНИЕ]
#outline(title: none, depth: 2, indent: auto)

= Введение

Развитие систем электронной коммерции требует создания надежных, масштабируемых и удобных в использовании программных продуктов. Современные маркетплейсы объединяют множество участников торгового процесса, что обуславливает необходимость четкого разделения прав доступа и ролей, а также гибкого подхода к хранению структур данных, описывающих разнообразные товары.

Целью данной курсовой работы является разработка кроссплатформенного приложения «Маркетплейс» на языке программирования высокого уровня "C++" с использованием графического фреймворка "Qt".

Для достижения поставленной цели необходимо решить следующие задачи:
- спроектировать объектно-ориентированную архитектуру приложения для управления информацией о пользователях, товарах и категориях
- реализовать систему динамического формирования категорий, позволяющую добавлять новые свойства и характеристики товаров во время выполнения программы
- разработать алгоритмы поиска, многокритериальной фильтрации и сортировки каталога товаров с учетом динамически настраиваемых полей
- разработать механизмы долговременного хранения данных с использованием бинарных и текстовых файлов
- обеспечить корректную параллельную работу нескольких экземпляров приложения за счет безопасного конкурентного доступа к файлам
- разработать систему аутентификации и разграничения прав доступа пользователей (администратор, продавец, покупатель)
- спроектировать и реализовать графический интерфейс пользователя (GUI)
- провести тестирование работоспособности разработанного приложения на операционных системах семейств "Windows" и "Linux"

В основу разработки должны быть заложены принципы объектно-ориентированного проектирования, независимость алгоритмов обработки и хранения данных от графического интерфейса чтобы успростить дальнейшее масштабирование функционала системы.