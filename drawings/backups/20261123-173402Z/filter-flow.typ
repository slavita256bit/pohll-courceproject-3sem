#import "../bsuir-core/src/block-schemes/lib.typ": *

// Draft for CategoryProducts::filter(), with the matching logic shown in detail.
#let filter-flow() = {
  set text(hyphenate: false)
  let start = terminal(55mm, 10mm, [Начало])
  let vars = process(55mm, 35mm, [Вх.: products, filter \ Пр.: product, condition, \ value, matched \ Вых.: result])
  let init = predefined(55mm, 63mm, [ф. clear_result() \ Очистка дерева result])
  let first = predefined(55mm, 90mm, [ф. first_product() \ Первый товар product \ при обходе по ключу])
  let product = decision(55mm, 117mm, [Товар product \ существует])
  let first-condition = predefined(55mm, 144mm, [ф. first_condition() \ Первое условие condition \ из фильтра filter])
  let condition = decision(55mm, 171mm, [Условие condition \ существует])
  let value = predefined(55mm, 198mm, [ф. #text(size: 7pt)[get_property_value()] \ Значение value по ID \ из определения condition])
  let absent = decision(55mm, 225mm, [Значение value \ отсутствует])
  let allowed = decision(116mm, 225mm, [allow_missing \ (пропуск разрешён)])
  let pass-out = connector(116mm, 251mm, [А])
  let pass-in = connector(105mm, 306mm, [А])
  let compare = predefined(55mm, 252mm, [ф. matches() \ Проверка значения value \ условием condition])
  let matches = decision(55mm, 279mm, [matched \ (условие выполнено)])
  let next-condition = predefined(55mm, 306mm, [ф. next_condition() \ Следующее условие \ condition из фильтра])
  let add = predefined(116mm, 171mm, [ф. add_result() \ Ссылка на товар product \ в дерево result])
  let next-product = predefined(116mm, 144mm, [ф. next_product() \ Следующий товар product \ при обходе по ключу])
  let finish = terminal(55mm, 333mm, [Конец])

  scheme(width: 225mm, height: 342mm, text-size: 8pt,
    start, vars, init, first, product, first-condition, condition, value, absent,
    allowed, pass-out, pass-in, compare, matches, next-condition,
    add, next-product, finish,
    link(start, vars), link(vars, init), link(init, first), link(first, product),
    link(product, first-condition), link(first-condition, condition), link(condition, value),
    link(condition, add, from-side: "right", to-side: "left"),
    link(value, absent), link(absent, compare),
    link(absent, allowed, from-side: "right", to-side: "left"),
    link(compare, matches),
    link(matches, next-condition),
    route(port(matches, "right"), (153mm, 279mm), (153mm, 144mm), port(next-product, "right")),
    route(port(allowed, "right"), (153mm, 225mm), arrow: false),
    link(allowed, pass-out),
    link(pass-in, next-condition, from-side: "left", to-side: "right"),
    route(port(next-condition, "left"), (25mm, 306mm), (25mm, 157mm), (55mm, 157mm)),
    link(add, next-product, from-side: "top", to-side: "bottom"),
    route(port(next-product, "top"), (116mm, 103mm), (55mm, 103mm)),
    route(port(product, "left"), (12mm, 117mm), (12mm, 323mm), (55mm, 323mm), port(finish, "top")),
    label(62mm, 128mm, [Да], width: 12mm), label(24mm, 112mm, [Нет], width: 12mm),
    label(62mm, 182mm, [Да], width: 12mm), label(86mm, 166mm, [Нет], width: 12mm),
    label(62mm, 236mm, [Нет], width: 12mm), label(86mm, 220mm, [Да], width: 12mm),
    label(123mm, 237mm, [Да], width: 12mm), label(144mm, 220mm, [Нет], width: 12mm),
    label(62mm, 290mm, [Да], width: 12mm), label(86mm, 274mm, [Нет], width: 12mm),
    ..attached-comment(vars, [Метод CategoryProducts::filter() \ products -- дерево товаров выбранной конечной категории, тип #text("BinaryTree<Product>"). \ Обход products выполняется по ключу: левое поддерево, корень, правое поддерево. \ filter -- набор условий отбора, тип ProductFilter&. \ condition -- условие для характеристики, тип FilterCondition\*. \ definition -- определение характеристики в condition, тип PropertyDefinition. \ Метод matches() проверяет совпадение через == или включительный диапазон через ≤. \ product -- текущий товар из дерева products, тип Product\*. \ value -- значение проверяемой характеристики у product, тип PropertyValue\*. \ matched -- результат проверки condition, тип bool. \ result -- дерево ссылок на подходящие товары, тип #text("BinaryTree<FilteredProduct>&"). \ allow_missing -- пропуск разрешён настройкой INCLUDE_PRODUCTS_WITH_MISSING_PROPERTY и характеристика необязательна, тип bool.], gap: 8mm, width: 140mm, height: 50mm),
  )
}
