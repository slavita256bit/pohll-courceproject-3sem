#import "../bsuir-core/src/block-schemes/lib.typ": *

// Draft for Buyer::place_order(); storage and concurrency mechanisms are undecided.
#let order-flow() = {
  set text(hyphenate: false)
  let start = terminal(55mm, 10mm, [Начало])
  let vars = process(55mm, 35mm, [Вх.: cart \ Пр.: item, product, stock, \ quantity, order \ Вых.: status])
  let empty = decision(55mm, 71mm, [Корзина cart \ пуста])
  let access = predefined(55mm, 99mm, [ф. lock_data() \ Согласование доступа к данным])
  let first = predefined(55mm, 126mm, [ф. first_item() \ Первая позиция item \ в корзине cart])
  let remaining = decision(55mm, 154mm, [Позиция item \ существует])
  let stock = predefined(55mm, 182mm, [ф. get_quantity() \ Остаток stock \ для товара product])
  let enough = decision(55mm, 210mm, [Остатка stock \ достаточно])
  let next = predefined(55mm, 238mm, [ф. next_item() \ Следующая позиция item \ в корзине cart])
  let missing = input-output(113mm, 210mm, [Сообщение \ о нехватке товара])
  let create = predefined(178mm, 154mm, [ф. make_order() \ Заказ order \ из корзины cart])
  let decrement = predefined(178mm, 182mm, [ф. update_stock() \ Уменьшение остатков \ товаров из заказа order])
  let save = predefined(178mm, 210mm, [ф. save_order() \ Запись заказа order \ в бин. файл. \ Сохранение остатков])
  let release = predefined(178mm, 255mm, [ф. unlock_data() \ Освобождение доступа к данным])
  let error = input-output(113mm, 71mm, [Сообщение \ о пустой корзине])
  let finish = terminal(178mm, 284mm, [Конец])

  scheme(width: 225mm, height: 294mm, text-size: 8pt,
    start, vars, empty, access, first, remaining, stock, enough, next,
    missing, create, decrement, save, release, error, finish,
    link(start, vars), link(vars, empty), link(empty, access),
    link(empty, error, from-side: "right", to-side: "left"),
    route(port(error, "right"), (216mm, 71mm), (216mm, 284mm), port(finish, "right")),
    link(access, first), link(first, remaining), link(remaining, stock),
    link(remaining, create, from-side: "right", to-side: "left"),
    link(stock, enough), link(enough, next),
    link(enough, missing, from-side: "right", to-side: "left"),
    route(port(next, "left"), (23mm, 238mm), (23mm, 140mm), (55mm, 140mm)),
    link(create, decrement), link(decrement, save), link(save, release),
    route(port(missing, "bottom"), (113mm, 255mm), port(release, "left")),
    link(release, finish),
    label(63mm, 82mm, [Нет], width: 12mm), label(86mm, 66mm, [Да], width: 12mm),
    label(63mm, 165mm, [Да], width: 12mm), label(86mm, 149mm, [Нет], width: 12mm),
    label(63mm, 221mm, [Да], width: 12mm), label(86mm, 205mm, [Нет], width: 12mm),
    ..attached-comment(vars, [Метод Buyer::place_order() \ cart -- корзина покупателя, тип Cart&. \ item -- текущая позиция корзины cart, тип CartItem\*. \ product -- товар в позиции item, тип Product&. \ stock -- актуальный остаток товара product, тип int. \ quantity -- количество товара в позиции item, тип int. \ Для заказа требуется stock ≥ quantity. \ order -- заказ, сформированный из позиций cart, тип Order. \ status -- возвращаемое значение метода, тип bool.], gap: 8mm, width: 105mm, height: 36mm),
    ..attached-comment(access, [Проверка и изменение остатков выполняются при согласованном доступе нескольких экземпляров.], gap: 8mm, width: 110mm, height: 20mm),
  )
}
