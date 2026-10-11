// Оформление имен файлов и горизонтальных схем записей.
#let file-name(name) = text(font: "Times New Roman", hyphenate: false, name)
#let record-grid(columns, ..cells) = {
  set text(hyphenate: true)
  table(
    columns: columns,
    align: center + horizon,
    ..cells.pos(),
  )
}

// Вертикальная подпись поля без дробления слов переносами.
#let vertical-field(body, kind: none) = {
  set text(hyphenate: false)
  rotate(-90deg, reflow: true, box(align(center)[
    #body
    #if kind != none { [\ #kind] }
  ]))
}

// Совместное размещение схем на одной странице.
#let record-sheet(body) = {
  pagebreak(weak: true)
  block(width: 100%, breakable: false, body)
  pagebreak(weak: true)
}

= Функциональное проектирование

== Структура входных и выходных данных

Данные вводятся через пользовательский интерфейс и считываются из файлов. После добавления, изменения и удаления записей данные сохраняются в файлах. Ограничения полей приведены в таблице @tab-data-limits.

#figure(
  table(
    columns: (1.6fr, 0.9fr, 1.8fr),
    align: center + horizon,
    table.header([Константа], [Значение], [Назначение]),
    [`MAX_NAME`], [80 символов], [Имя пользователя, название товара, категории, свойства и бренда],
    [`MAX_PROPERTY_TEXT`], [255 символов], [Текстовое значение свойства],
    [`MAX_DESCRIPTION`], [200 символов], [Описание товара],
    [`MAX_REVIEW`], [100 символов], [Текст отзыва],
    [`MAX_REPLY`], [100 символов], [Ответ продавца],
    [`MIN_RATING` \ `MAX_RATING`], [1 и 5], [Границы оценки товара],
  ),
  caption: [Ограничения полей данных],
) <tab-data-limits>

Состав файлов приложения приведен в таблице @tab-data-files.

#figure(
  table(
    columns: (1.1fr, 0.7fr, 2fr),
    align: center,
    table.header([Файл], [Формат], [Содержимое]),
    [#file-name("users.bin")], [Бинарный], [Пользователи и роли],
    [#file-name("categories.txt")], [Текстовый], [Категории и определения их свойств],
    [#file-name("products.bin")], [Бинарный], [Товары и значения их свойств],
    [#file-name("carts.txt")], [Текстовый], [Позиции корзин покупателей],
    [#file-name("orders.bin")], [Бинарный], [Заказы, части продавцов и товарные позиции],
    [#file-name("replies.bin")], [Бинарный], [Оценки, отзывы и ответы продавцов],
  ),
  caption: [Состав файлов приложения],
) <tab-data-files>

Категория и ее свойства сохраняются в одной записи файла #file-name("categories.txt"). Структура приведена в таблице @tab-category-structure.

#figure(
  record-grid((1fr, 1fr, 1fr, 0.8fr, 1fr, 1fr, 1fr, 1fr),
    table.cell(colspan: 8)[*Категория*],
    table.cell(rowspan: 3)[#vertical-field([Идентификатор], kind: [int])],
    table.cell(rowspan: 3)[#vertical-field([Родительская категория], kind: [int])],
    table.cell(rowspan: 3)[#vertical-field([Название], kind: [string])],
    table.cell(colspan: 5)[*Список свойств категории*],
    table.cell(rowspan: 2)[#vertical-field([Число свойств], kind: [int])],
    table.cell(colspan: 4)[*Свойство*],
    [#vertical-field([Идентификатор], kind: [int])], [#vertical-field([Название], kind: [string])], [#vertical-field([Тип значения], kind: [перечисление])], [#vertical-field([Обязательность], kind: [булевое значение])],
  ),
  caption: [Структура записи файла #file-name("categories.txt")],
) <tab-category-structure>

Категория наследует свойства предков. Типы значений -- текст, целое число, дробное число и булевое значение. После создания категории добавляются только необязательные свойства.

Запись позиции корзины в файле #file-name("carts.txt") содержит следующие поля:
- идентификатор покупателя -- int
- идентификатор товара -- int
- количество -- int

Запись отзыва в файле #file-name("replies.bin") содержит следующие поля:
- идентификатор -- int
- идентификатор товара -- int
- идентификатор покупателя -- int
- оценка -- int
- текст отзыва -- string
- признак наличия ответа -- булевое значение
- текст ответа -- string

Покупатель оставляет одну оценку с необязательным отзывом на заказанный товар и может редактировать ее. Продавец может добавить ответ.

Структуры товара и заказа приведены в таблицах @tab-product-structure и @tab-order-structure. Необязательное свойство без значения отсутствует в списке. Удаленный товар становится неактивным и сохраняется для истории заказов. Средняя оценка вычисляется по отзывам. Продавец подтверждает только свою часть заказа; цена и адрес фиксируются при оформлении.

#record-sheet[
#figure(
  block(width: 100%, record-grid((..range(9).map(_ => 1fr), 1fr, 1.2fr, 1.3fr),
    table.cell(colspan: 12)[*Товар*],
    table.cell(rowspan: 3)[#vertical-field([Идентификатор], kind: [int])],
    table.cell(rowspan: 3)[#vertical-field([Продавец], kind: [int])],
    table.cell(rowspan: 3)[#vertical-field([Категория], kind: [int])],
    table.cell(rowspan: 3)[#vertical-field([Название], kind: [string])],
    table.cell(rowspan: 3)[#vertical-field([Описание], kind: [string])],
    table.cell(rowspan: 3)[#vertical-field([Цена (копейки)], kind: [int])],
    table.cell(rowspan: 3)[#vertical-field([Количество], kind: [int])],
    table.cell(rowspan: 3)[#vertical-field([Бренд], kind: [string])],
    table.cell(rowspan: 3)[#vertical-field([Активность], kind: [булевое значение])],
    table.cell(colspan: 3)[*Список значений свойств*],
    table.cell(rowspan: 2)[#vertical-field([Число значений], kind: [int])],
    table.cell(colspan: 2)[*Значение свойства*],
    [#vertical-field([Идентификатор свойства], kind: [int])], [#vertical-field([Значение], kind: [по типу свойства])],
  )),
  caption: [Структура записи файла #file-name("products.bin")],
) <tab-product-structure>

#figure(
  block(width: 100%, record-grid((1fr, 1fr, 1.5fr, 0.9fr, 1fr, 1fr, 0.9fr, 1fr, 1fr, 1.4fr),
    table.cell(colspan: 10)[*Заказ*],
    table.cell(rowspan: 5)[#vertical-field([Идентификатор], kind: [int])],
    table.cell(rowspan: 5)[#vertical-field([Покупатель], kind: [int])],
    table.cell(rowspan: 5)[#vertical-field([Адрес при оформлении], kind: [string])],
    table.cell(colspan: 7)[*Список частей заказа*],
    table.cell(rowspan: 4)[#vertical-field([Число частей], kind: [int])],
    table.cell(colspan: 6)[*Часть заказа*],
    table.cell(rowspan: 3)[#vertical-field([Продавец], kind: [int])],
    table.cell(rowspan: 3)[#vertical-field([Состояние], kind: [перечисление])],
    table.cell(colspan: 4)[*Список товарных позиций*],
    table.cell(rowspan: 2)[#vertical-field([Число позиций], kind: [int])],
    table.cell(colspan: 3)[*Товарная позиция*],
    [#vertical-field([Товар], kind: [int])], [#vertical-field([Количество], kind: [int])], [#vertical-field([Цена (в копейках)\ единицы при оформлении], kind: [int])],
  )),
  caption: [Структура записи файла #file-name("orders.bin")],
) <tab-order-structure>
]
