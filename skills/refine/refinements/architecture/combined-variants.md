<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Combined variants

When code varies along two axes, the cost of a change grows with their sum, not
their product. Code written once for each pair of variants makes every new
variant on one axis cost a piece of code for each variant on the other.

## Why it costs the reader

A reader looking for how one variant works has to collect it from every pair it
appears in. Each pair also drifts from its neighbors, since nothing shares the
parts they have in common.

## How to spot it

- File or type names built from two words, one from each axis.
- A new case that means touching a file in every folder.
- Parallel lists, switches or hierarchies that have to gain a member together.
- One giant function that handles every pair, as the other way to avoid the
  product.

## The move

Pick one axis to own the code and turn the other into data. Each variant on
the first axis gets one place, holding a declarative description of itself.
Each variant on the second reads that description through one interface,
often as a list of registered entries. A new variant on either axis is then
one new entry, and neither touches the other.

## Example

Before, an exporter per report per format:

```text
exports/
    sales_csv    sales_pdf    sales_xlsx
    stock_csv    stock_pdf    stock_xlsx
```

After, a report is one description, and each format renders any of them:

```text
sales = Report {
    title: "Sales",
    columns: [Column("Month"), Column("Revenue", as: Money)],
    rows: salesByMonth
}

formats = [Csv, Pdf, Xlsx]    // each one: render(report) -> Bytes
```

## Sources

- [Parallel Inheritance
  Hierarchies](https://refactoring.guru/smells/parallel-inheritance-hierarchies)
  and [Shotgun Surgery](https://refactoring.guru/smells/shotgun-surgery).
- Clean Code, chapter 10, "Organizing for Change".
