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
- **Categories.** Categories form a tree and inherit property definitions from ancestors. Each definition has an ID, name, type, and required flag. Supported values are text, integer, fractional number, and boolean. At category creation both required and optional properties are allowed. Later additions must be optional. Categories cannot be deleted or hidden, including when they have no products. Treat the tree as application data. Design the C++ inheritance hierarchy around behavior.
- **Products.** Each product belongs to one category and is not moved to another category. Store products in separate files by category. The draft stores ID, name, description, price, category, stock count, brand, and property values. Distinguish absent optional values from empty text, zero, and false. Keep ratings as separate records and compute the average from them. Product photos are a possible later enhancement.
- **Orders.** An order contains line items and has a single state. The seller confirms the whole order. Store different buyers' orders in different files.
- **Reviews.** Buyers can rate an ordered product from 1 to 5 and may include review text. Each buyer has one editable rating and review per product, even after repeat purchases. The seller can answer reviews.

## Current file inventory

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
- Login, password, phone, address, and property value validation. Earlier notes record 80 characters for names, 200 for descriptions, and 100 each for reviews and replies. Confirm which names use the 80-character limit. The 255-character text property limit was proposed.
- Changes to categories and properties, and deletion of properties or accounts with existing references, including changes to type or required status. Decide how product IDs are resolved across category files for carts, orders, and reviews, and how related files are updated by concurrent instances.
- Undo scope and persistence, custom container and iterator choices, STL usage, and a substantive C++ class hierarchy. A dynamic array, undo stack, and STL for temporary results were early proposals.
