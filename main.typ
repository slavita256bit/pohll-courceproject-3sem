#import "@local/typst-bsuir-core:1.18.8": *
#import "title.typ": pnayavu-course-project

#set text(font: "Times New Roman", size: 14pt, lang: "ru", overhang: false)
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
#let stp-line-step = 18pt
#let stp-leading = 8.3pt
// Пробельная строка добавляет один шаг к обычному промежутку между строками.
#let stp-blank-line-gap = stp-line-step + stp-leading
#set par(leading: stp-leading, spacing: stp-leading, first-line-indent: 1.25cm, justify: true)
// Приложение Л СТП: нижняя граница номера в 10 мм от края листа.
#let stp-page-number-bottom = 10mm
#set page(footer-descent: 0pt, footer: context {
  if counter(page).get().first() > 1 {
    set par(first-line-indent: 0pt)
    box(width: 100%, height: page.margin.bottom - stp-page-number-bottom,
      align(bottom + right,
        text(top-edge: "bounds", bottom-edge: "bounds", counter(page).display()),
      ),
    )
  }
})

// СТП 2.1.1, 2.2.6 и приложение Л: пробельная строка у заголовков.
#show heading: set block(above: stp-blank-line-gap, below: stp-blank-line-gap)
// СТП 2.6.3: пробельная строка снаружи таблицы вместе с названием.
// Библиотека gost уже добавляет pad(bottom: 0.5em) ко всем figure.
#let gost-figure-bottom-inset = 0.5em
#show figure.where(kind: table): set block(above: 0pt, below: 0pt)
#show figure.where(kind: table): it => block(
  breakable: false,
  above: stp-blank-line-gap,
  below: stp-blank-line-gap - gost-figure-bottom-inset,
)[#it]
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

// СТП 2.3.5 и приложение Л: маркер с абзацного отступа,
// продолжение — от левого поля, между пунктами обычный шаг строк.
#show list: it => {
  set par(first-line-indent: (amount: 1.25cm, all: true), spacing: stp-leading)
  for (i, item) in it.children.enumerate() {
    let delim = if i == it.children.len() - 1 [.] else [;]
    par()[-- #item.body#delim]
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

Маркетплейс представляет собой торговую площадку, на которой размещаются предложения разных продавцов. Покупатель получает доступ к общему каталогу и может выбирать товары по их характеристикам, стоимости и отзывам. Продавец размещает сведения о своих товарах и обрабатывает поступившие заказы. Организация такой площадки требует согласованной работы с данными о товарах, пользователях и покупках.

При большом количестве предложений одного просмотра каталога недостаточно для выбора товара. Информация должна быть упорядочена так, чтобы пользователь мог найти нужное предложение и сравнить его с другими. При этом товары различаются по набору характеристик: для одежды важны размер и материал, для техники -- параметры устройства. Поэтому организация каталога должна учитывать особенности категорий и позволять изменять их состав без переработки всей программы.

Работа маркетплейса также связана с разграничением действий участников. Покупатель, продавец и администратор используют одну систему, но решают в ней разные задачи. Изменения, внесенные одним участником, должны корректно отражаться при последующей работе других. Например, сведения в карточке товара должны соответствовать данным, которые внес продавец. Ошибки в таких связях могут привести к отображению неверной информации и затруднить работу с каталогом.

Большинство известных маркетплейсов работает через сеть Интернет. В рамках курсового проекта рассматривается настольное приложение, в котором информация хранится на компьютере пользователя. Это позволяет организовать работу с каталогом без подключения к сети и рассмотреть основные действия участников торговой площадки в пределах локальной системы. При этом необходимо сохранять данные между запусками программы и учитывать связи между отдельными записями.

Актуальность темы заключается в необходимости совместно решать задачи организации каталога, обработки данных и взаимодействия пользователей. Разработка приложения для этой предметной области позволяет применить изученные средства программирования к взаимосвязанным задачам. При проектировании требуется определить, как представить сведения о товарах и участниках площадки, какие связи установить между ними и как отобразить результат обработки информации в интерфейсе.

Целью курсового проекта является разработка кроссплатформенного настольного приложения "Маркетплейс" с графическим интерфейсом. Работа включает анализ существующих решений, выбор технологий, проектирование структуры приложения, реализацию программных модулей и проверку их работы. Подробные требования к программе приведены в постановке задачи.

Практическое значение проекта состоит в закреплении навыков разработки приложений на языке "C++", объектно-ориентированного проектирования и работы с файловыми данными. Результатом должно стать приложение, позволяющее продемонстрировать взаимодействие покупателей, продавцов и администратора. Проверка программы должна показать, что действия пользователей приводят к ожидаемым изменениям данных и что эти изменения сохраняются после завершения работы.

#include "01-literature-review.typ"

#include "02-functional-design.typ"

#include "references.typ"
