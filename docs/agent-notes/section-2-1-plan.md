# Scope and data decisions

The student decides substantive design choices. The current report describes the chosen file groups and remains a draft.

## Application and assignment

- Desktop marketplace for Windows and Linux using C++23, STL, Qt 6 Widgets, and CMake. Name Qt Creator as the development environment in the report. The student may use CLion for coding.
- Buyers browse the catalog and product pages, search, filter, and sort by criteria including rating. Their carts persist between launches. They place orders and can rate or review an ordered product.
- There is one seller in the entire application. The seller adds, edits, and deletes products, replies to reviews, and confirms each order. Confirmation marks the order as sent. Delivery is simulated.
- Administrators manage users, categories, and property definitions. Only administrators can define properties.
- Use related text and binary files, with simultaneous use by multiple application instances in the project scope. The assignment also calls for a usable interface with menus, at least three levels of class inheritance, custom containers, iterators and algorithms alongside STL, exception handling, and undo for recent additions, edits, and deletions. The main algorithms need substantive work beyond basic container operations.
- The comparison in chapter 1 uses offline access, local storage, and no advertising as the project's advantages.

## Agreed data model

- **Users.** One role per account. The earlier design lists ID, login, password hash (`string`), display name, role, phone, and address. Phone was chosen in place of email. The storage representation beyond the logical type remains open.
- **Categories.** Categories form a tree and inherit property definitions from ancestors. Products belong only to leaf categories, with no products assigned to categories that have subcategories. Products are displayed only after choosing a leaf category. Creating a subcategory is forbidden while the parent category has any product records, including inactive records kept for order history. Each definition has an ID, name, type, and required flag. Supported values are text, integer, fractional number, and boolean. At category creation both required and optional properties are allowed. Later additions must be optional. Categories cannot be deleted or hidden, including when they have no products. Treat the tree as application data. Design the C++ inheritance hierarchy around behavior.
- **Products.** Each product belongs to one category and is not moved to another category. Store products in separate files by category. The draft stores ID, name, description, price, category, stock count, brand, and property values. Distinguish absent optional values from empty text, zero, and false. Keep ratings as separate records and compute the average from them. Product photos are a possible later enhancement. The student chose a class hierarchy for text, integer, fractional and boolean property values. Each product stores its property values in a map keyed by property ID. Category products still use BinaryTree.
- **Filtering.** Text and boolean characteristics use exact-value conditions. Integer and fractional characteristics use ranges. A buyer selects a leaf category before viewing its products. By default, a product with no value for an optional characteristic passes the condition for that characteristic; other conditions still apply. The student requested a `define` to change this behavior. The draft declares `INCLUDE_PRODUCTS_WITH_MISSING_PROPERTY` in `src/FilterSettings.h`; its behavior is not yet implemented.
- **Property comparisons.** Reuse the existing PropertyValue hierarchy for comparing actual values when filtering. Pass the PropertyDefinition to identify the characteristic and its type. PropertyValue overloads == and <=> to compare contents. PropertyDefinition describes the characteristic and its type. FilterCondition has four derived classes for text, integer, real and Boolean values. The text and Boolean classes store one expected value. The numeric classes store inclusive minimum and maximum values. Each owns its data by value. ProductFilter stores the four concrete condition types in a variant, and calls the common virtual matches operation. Products store PropertyOperand values by value. Do not use smart pointer types.
- **Orders.** An order contains line items and has a single state. The seller confirms the whole order. Store different buyers' orders in different files. An empty cart cannot be ordered. The user cannot select a quantity above current stock. Stock is checked again at checkout and the user is notified if it has become insufficient. An exception may be raised if reducing stock would make it negative. Coordinate the check and update when multiple instances work concurrently.
- **Reviews.** Buyers can rate an ordered product from 1 to 5 and may include review text. Each buyer has one editable rating and review per product, even after repeat purchases. The seller can answer reviews.

## Current file inventory

The File hierarchy follows the lecture example. TextFile<T> uses the record’s stream operators. BinaryFile<T> uses the record’s read_binary and write_binary methods. Neither file class takes serialization callbacks. Record codecs and concurrent file updates remain open. Keep the file inventory and formats below.

| File | Format | Contents |
| --- | --- | --- |
| `users.bin` | Binary | Accounts and roles |
| `categories.txt` | Text | Categories and their property definitions |
| `products/<id>.bin`, one per category | Binary | Products and property values |
| `carts.txt` | Text | Buyer cart items |
| `orders/<id>.bin`, one per buyer | Binary | Orders and line items |
| `replies.bin` | Binary | Ratings, reviews, and seller replies |

The student chose binary files named using the category or buyer ID, for example `12.bin`, in separate directories. The directory names `products` and `orders` are working choices. Earlier 11- and 7-file proposals are historical. File encoding, delimiters, record headers, byte widths, and byte order remain open. Simplicity of search and processing is the priority, while the instructor expects multiple files.

## Draft assumptions to confirm

- Integer prices in BYN kopecks, with unit price and delivery address captured at checkout. The draft retains inactive products for order and review history. Confirm these choices and the behavior of hidden products.
- When stock is decremented, order statuses and cancellation, and the number and editing rules for seller replies.
- Login, password, phone, and address validation. The student chose a limit of 80 characters for names, product/category/property/brand titles, descriptions, review and reply text, and text property values. Ratings range from 1 to 5. The earlier 100- and 255-character limits are superseded. Apply limits in the future application or user guide, not as a limits table in the explanatory note.
- Changes to categories and properties, and deletion of properties or accounts with existing references, including changes to type or required status. Decide how product IDs are resolved across category files for carts, orders, and reviews, and how related files are updated by concurrent instances.
- Undo scope and persistence, custom container and iterator choices, STL usage, and a substantive C++ class hierarchy. A dynamic array, undo stack, and STL for temporary results were early proposals.

## Laboratory classes

The student chose `BinaryTree` and `String` from `/home/slavita/CLionProjects/sem2lab3`. Copies are in `src/` as a starting point for the diagram and later application code. The student explicitly permits partially rewriting these classes for the application. The lab `BinaryTree` is an owning binary search tree ordered by the object's comparison operator. Its `iterate` function uses `std::generator`; it is not a general category hierarchy. The student chose a separate tree of products for each category. Its console table-output methods are lab-specific. The assignment requires a custom iterator, so determine how to provide one alongside the existing generator.

The lab `String` allocates dynamically; its stream input uses an 80-byte buffer. The agreed limit is 80 characters, so input, validation, and the distinction between character count and stored bytes need attention before using it in the application. The copying constructors and other operations are preserved from the lab and require review before production use.

The student chose a temporary tree for sorting and suggested references to products. The working design has separate temporary entries referring to products in the category tree, so clearing the owning temporary tree deletes its entries rather than the original products. Their lifetime must be managed during updates. Products without ratings have a sort value of zero. Products missing the optional property used for sorting appear at the end in both directions. The demonstration constructs a second tree of FilteredProduct entries and passes a comparator. It computes keys during comparisons and uses product ID for ties. The lab tree is unbalanced, so building a temporary tree can take quadratic time in the worst case. Section 1.1.2 no longer attributes the sorting to an STL O(n log n) algorithm.

## Draft class hierarchy

The student approved a draft hierarchy: `Account` contains login and password data, `User` adds profile data, and `Buyer`, `Seller`, and `Administrator` inherit from `User`. The method signatures in `src/` are working proposals for the diagram, without implementations. Review them with the student and adapt them to the actual storage and interaction design before using them as final declarations.

The preliminary `Category`, `Cart` and `Order` declarations use `std::vector` to group their property definitions or item records in memory. This is a reversible working choice for the diagram; it does not determine the on-disk format.
