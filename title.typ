#import "@preview/modern-g7-32:0.2.0": custom-title-template
#import custom-title-template: *

// 1. ПАРСЕР АРГУМЕНТОВ
#let arguments(..args) = {
  let args = args.named()

  args.ministry = fetch-field(
    args.at("ministry", default: "Министерство образования Республики Беларусь"),
    ("value*",),
  ).value

  args.organization = fetch-field(
    args.at("organization", default: none),
    ("type*", "name*"),
    default: (
      type: "Учреждение образования",
      name: "«Белорусский государственный университет\nинформатики и радиоэлектроники»",
    ),
    hint: "организации",
  )

  args.faculty = fetch-field(
    args.at("faculty", default: "компьютерных систем и сетей"),
    ("value*",),
    hint: "факультета"
  ).value

  args.department = fetch-field(
    args.at("department", default: "электронных вычислительных машин"),
    ("value*",),
    hint: "кафедры"
  ).value

  args.discipline = fetch-field(
    args.at("discipline", default: "Программирование на\nязыках высокого уровня"),
    ("value*",),
    hint: "дисциплины"
  ).value

  args.approver = fetch-field(
    args.at("approver", default: (name: "А. М. Ковальчук")),
    ("name*",),
    hint: "допускающего к защите"
  )

  args.work = fetch-field(
    args.at("work", default: (
      topic: "Разработка кроссплатформенного приложения\n«Маркетплейс»",
      code: "БГУИР КР 6-05-0611-05 XXX ПЗ"
    )),
    ("topic*", "code*"),
    hint: "курсовой работы"
  )

  args.student = fetch-field(
    args.at("student", default: (name: "В. С. Ермаков", group: "558301")),
    ("name*", "group*"),
    hint: "студента"
  )

  args.manager = fetch-field(
    args.at("manager", default: (name: "А. М. Ковальчук")),
    ("name*",),
    hint: "руководителя"
  )

  // КАСТОМНЫЙ ФУТЕР (ГОРОД И ГОД)
  // Извлекаем параметры из структуры footer, либо берем дефолты
  args.footer = fetch-field(
    args.at("footer", default: none),
    ("city*", "year*"),
    default: (
      city: "МИНСК",
      year: "2026",
    ),
    hint: "подвала (город и год)",
  )

  return args
}

// 2. ВЕРСТКА ТИТУЛЬНОГО ЛИСТА
#let template(
  ministry: none,
  organization: (:),
  faculty: none,
  department: none,
  discipline: none,
  approver: (:),
  work: (:),
  student: (:),
  manager: (:),
  footer: (:),
  ..rest, // Чтобы игнорировать любые неожиданные системные поля
) = {
  // Отключаем абзацный отступ для титульника
  set par(first-line-indent: 0pt)

  align(center)[
    #ministry \
    \
    #organization.type \
    #organization.name
  ]

  v(1.5fr)

  align(left)[
    Факультет #faculty
    #v(0.5em)
    Кафедра #department
    #v(0.5em)
    #grid(
      columns: (auto, 1fr),
      column-gutter: 0.5em,
      [Дисциплина:], [#discipline]
    )
  ]

  v(2fr)

  align(right)[
    #block(width: 6.5cm, align(left)[
      К ЗАЩИТЕ ДОПУСТИТЬ \
      #grid(
        columns: (1fr, auto),
        align: bottom,
        column-gutter: 0.5em,
        line(length: 100%, stroke: 0.5pt),
        approver.name
      )
    ])
  ]

  v(2fr)

  align(center)[
    ПОЯСНИТЕЛЬНАЯ ЗАПИСКА \
    к курсовой работе \
    на тему \
    \
    #upper(work.topic) \
    \
    #work.code
  ]

  v(3fr)

  pad(right: 1cm)[
    #grid(
      columns: (1fr, auto),
      row-gutter: 2em,

      [Студент],
      [#student.name \ (гр. #student.group)],

      [Руководитель],
      [#manager.name]
    )
  ]

  v(2fr)

  // ОТРИСОВКА ФУТЕРА
  pad(bottom: 1cm)[
    #align(center)[
      #footer.city #footer.year
    ]
  ]
}

#let pnayavu-course-project = (arguments: arguments, template: template)