#let code-font = "Consolas"
#let code-size = 10pt
// Число знаков Consolas 10 пт в поле шириной 165 мм.
#let columns = 85

#let format-listing(source) = {
  // Ищем комментарий после кода без строковых литералов и других знаков /.
  let trailing-comment = regex("^([ \\t]*)([^ \\t/\"'][^/\"']*?)[ \\t]+(//.*)$")
  source.split("\n").map(line => {
    let comment = line.match(trailing-comment)
    if comment == none { return line }

    let (indent, code, explanation) = comment.captures
    let compact = indent + code + " " + explanation
    if compact.clusters().len() <= columns { return compact }

    // Длинное пояснение занимает всю ширину строки над объявлением.
    indent + explanation + "\n" + indent + code
  }).join("\n")
}

#let source-file(path) = {
  let filename = path.split("/").last()
  block(width: 100%, sticky: true, above: 8pt, below: 6pt,
    align(center, strong([Код файла #filename])),
  )
  block(width: 100%, breakable: true, above: 0pt, below: 6pt, {
    set par(first-line-indent: 0pt, justify: false, leading: 0.5em)
    raw(format-listing(read(path)), lang: "cpp", block: true)
  })
}

#show raw: set text(font: code-font, size: code-size)

#for path in (
  "src/String.h",
  "src/BinaryTree.h",
  "src/BinaryTreeIterator.h",
  "src/Account.h",
  "src/User.h",
  "src/Buyer.h",
  "src/Seller.h",
  "src/Administrator.h",
  "src/Category.h",
  "src/PropertyDefinition.h",
  "src/PropertyValue.h",
  "src/TextPropertyValue.h",
  "src/IntegerPropertyValue.h",
  "src/RealPropertyValue.h",
  "src/BooleanPropertyValue.h",
  "src/PropertyOperand.h",
  "src/Product.h",
  "src/CategoryProducts.h",
  "src/FilterSettings.h",
  "src/ProductFilter.h",
  "src/FilteredProduct.h",
  "src/ProductSortEntry.h",
  "src/CartItem.h",
  "src/Cart.h",
  "src/OrderItem.h",
  "src/Order.h",
  "src/Review.h",
  "src/File.h",
  "src/BinaryFile.h",
  "src/TextFile.h",
) {
  source-file(path)
}
