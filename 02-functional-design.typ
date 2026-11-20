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

//TODO определится с контейнерами STL которые будут использоваться

Данные вводятся через пользовательский интерфейс и считываются из файлов. После добавления, изменения и удаления записей данные сохраняются в файлах.

Состав файлов приложения приведен в таблице @tab-data-files.

#figure(
  table(
    columns: (1.1fr, 0.7fr, 2fr),
    align: center,
    table.header([Файл], [Формат], [Содержимое]),
    [#file-name("users.bin")], [Бинарный], [Пользователи и роли],
    [#file-name("categories.txt")], [Текстовый], [Категории и определения их свойств],
    [#file-name("products/<id>.bin")], [Бинарный], [Товары и значения их свойств по категориям],
    [#file-name("carts.txt")], [Текстовый], [Позиции корзин покупателей],
    [#file-name("orders/<id>.bin")], [Бинарный], [Заказы покупателей и товарные позиции],
    [#file-name("replies.bin")], [Бинарный], [Оценки, отзывы и ответы продавца],
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
    [#vertical-field([Идентификатор], kind: [int])], [#vertical-field([Название], kind: [string])], [#vertical-field([Тип значения], kind: [перечисление])], [#vertical-field([Обязательность], kind: [bool])],
  ),
  caption: [Структура записи файла #file-name("categories.txt")],
) <tab-category-structure>

Категория наследует свойства предков. Типы значений -- текст, целое число, дробное число и булевое значение. После создания категории добавляются только необязательные свойства.

Корзина сохраняется между запусками программы. Структура записи позиции корзины приведена в таблице @tab-cart-structure.

#figure(
  table(
    columns: (2fr, 1fr),
    table.header([Поле], [Тип]),
    [Идентификатор покупателя], [int],
    [Идентификатор товара], [int],
    [Количество], [int],
  ),
  caption: [Структура записи файла #file-name("carts.txt")],
) <tab-cart-structure>

Структура записи отзыва приведена в таблице @tab-reply-structure.

#figure(
  table(
    columns: (2fr, 1fr),
    table.header([Поле], [Тип]),
    [Идентификатор], [int],
    [Идентификатор товара], [int],
    [Идентификатор покупателя], [int],
    [Оценка], [int],
    [Текст отзыва], [string],
    [Признак наличия ответа], [bool],
    [Текст ответа], [string],
  ),
  caption: [Структура записи файла #file-name("replies.bin")],
) <tab-reply-structure>

Покупатель оставляет одну оценку с необязательным отзывом на заказанный товар и может редактировать ее. Продавец может добавить ответ.

Товары каждой категории и заказы каждого покупателя хранятся в отдельных файлах. Имя файла состоит из идентификатора категории или покупателя и расширения. Структуры товара и заказа приведены в таблицах @tab-product-structure и @tab-order-structure. Необязательное свойство без значения отсутствует в списке. Удаленный товар становится неактивным и сохраняется для истории заказов. Средняя оценка вычисляется по отзывам. Продавец подтверждает заказ; цена и адрес фиксируются при оформлении.

#record-sheet[
#figure(
  block(width: 100%, record-grid((..range(8).map(_ => 1fr), 1fr, 1.2fr, 1.3fr),
    table.cell(colspan: 11)[*Товар*],
    table.cell(rowspan: 3)[#vertical-field([Идентификатор], kind: [int])],
    table.cell(rowspan: 3)[#vertical-field([Категория], kind: [int])],
    table.cell(rowspan: 3)[#vertical-field([Название], kind: [string])],
    table.cell(rowspan: 3)[#vertical-field([Описание], kind: [string])],
    table.cell(rowspan: 3)[#vertical-field([Цена (копейки)], kind: [int])],
    table.cell(rowspan: 3)[#vertical-field([Количество], kind: [int])],
    table.cell(rowspan: 3)[#vertical-field([Бренд], kind: [string])],
    table.cell(rowspan: 3)[#vertical-field([Активность], kind: [bool])],
    table.cell(colspan: 3)[*Список значений свойств*],
    table.cell(rowspan: 2)[#vertical-field([Число значений], kind: [int])],
    table.cell(colspan: 2)[*Значение свойства*],
    [#vertical-field([Идентификатор свойства], kind: [int])], [#vertical-field([Значение], kind: [по типу свойства])],
  )),
  caption: [Структура записи файла товаров],
) <tab-product-structure>

#figure(
  block(width: 100%, record-grid((1fr, 1fr, 1.5fr, 1fr, 0.9fr, 1fr, 1fr, 1.4fr),
    table.cell(colspan: 8)[*Заказ*],
    table.cell(rowspan: 3)[#vertical-field([Идентификатор], kind: [int])],
    table.cell(rowspan: 3)[#vertical-field([Покупатель], kind: [int])],
    table.cell(rowspan: 3)[#vertical-field([Адрес при оформлении], kind: [string])],
    table.cell(rowspan: 3)[#vertical-field([Состояние], kind: [перечисление])],
    table.cell(colspan: 4)[*Список товарных позиций*],
    table.cell(rowspan: 2)[#vertical-field([Число позиций], kind: [int])],
    table.cell(colspan: 3)[*Товарная позиция*],
    [#vertical-field([Товар], kind: [int])], [#vertical-field([Количество], kind: [int])], [#vertical-field([Цена (в копейках)\ единицы при оформлении], kind: [int])],
  )),
  caption: [Структура записи файла заказов],
) <tab-order-structure>
]
