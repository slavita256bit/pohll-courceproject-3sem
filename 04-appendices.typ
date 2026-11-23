#import "bsuir-core/lib.typ": appendices, appendix, drawing-sheet
#import "drawings/classes.typ": diagram
#import "drawings/order-flow.typ": order-flow
#import "drawings/filter-flow.typ": filter-flow

#show: appendices

#let course-drawing = drawing-sheet.with(
  author: [Ермаков],
  reviewer: [Ковальчук],
  group: [ЭВМ, гр. 550503],
)

#course-drawing(paper: "a1", flipped: true, title: [Диаграмма классов])[
  #appendix[Диаграмма классов] <app-class-diagram>
  #align(center, diagram(scale: 120%))
]

#course-drawing(paper: "a2", title: [Схема алгоритма оформления заказа])[
  #appendix[Схема алгоритма оформления заказа] <app-order-flow>
  #align(center, scale(145%, reflow: true, order-flow()))
]

#course-drawing(paper: "a2", title: [Схема алгоритма фильтрации товаров])[
  #appendix[Схема алгоритма фильтрации товаров] <app-filter-flow>
  #align(center, scale(125%, reflow: true, filter-flow()))
]

#appendix[Листинг программы] <app-listing>

// #include "listings.typ"
