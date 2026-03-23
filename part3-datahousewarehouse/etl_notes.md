## ETL Decisions

### Decision 1 — Standardise Category Casing

**Problem:**  
The `category` column contained the same category written with different
capitalisation across rows. For example, `Electronics` (Title Case) and
`electronics` (all lowercase) both appeared in the data, and `Groceries`
and `Grocery` were used interchangeably for what is clearly the same
product group. A database treats `'electronics'` and `'Electronics'` as
**different values**, so any `GROUP BY category` query would produce
duplicate rows one for each spelling giving wrong totals.

**Resolution:**  
All category values were normalised to **Title Case** with a single
spelling before insertion into `dim_product`:

| Raw value     | Cleaned value  |
|---------------|----------------|
| `electronics` | `Electronics`  |
| `Electronics` | `Electronics`  |
| `Groceries`   | `Grocery`      |
| `Grocery`     | `Grocery`      |
| `Clothing`    | `Clothing`     |

In a production ETL pipeline this would be handled with:
```sql
UPPER(SUBSTR(category,1,1)) || LOWER(SUBSTR(category,2))
```
combined with a lookup/mapping table for `Groceries → Grocery`.

---

### Decision 2 — Normalise Inconsistent Date Formats

**Problem:**  
The `date` column used at least three different formats across rows:
- `YYYY-MM-DD` (e.g. `2023-02-05`) — ISO standard
- `DD-MM-YYYY` (e.g. `20-02-2023`)
- `DD/MM/YYYY` (e.g. `15/08/2023`)

SQL date functions and comparisons only work reliably when all dates
share **one format**. Mixing formats makes ordering by date incorrect
and breaks range filters like `WHERE date BETWEEN '2023-01-01' AND '2023-03-31'`.

**Resolution:**  
All dates were converted to the ISO standard **`YYYY-MM-DD`**
before use. Each date was then encoded as an integer `date_key` in
`YYYYMMDD` format (e.g. `2023-08-15` → `20230815`) for fast joining.
Integer keys join faster than
date strings, and a dedicated `dim_date` table lets analysts filter by
month, quarter, or year without recalculating those fields every query.

---

### Decision 3 — Impute NULL City Values

**Problem:**  
Several rows had a NULL value in the `store_city` column for example,
`TXN5033` (Mumbai Central), `TXN5044` (Chennai Anna), `TXN5082`
(Delhi South), and others. Leaving `city` as NULL means those
transactions would be excluded from any city-level analysis, which would
silently under-count revenue by city.

**Resolution:**  
Because the `store_name` column was always present and each store name
maps to exactly **one** city (e.g. `'Mumbai Central'` is always in
`'Mumbai'`), the city was derived from the store name using a
deterministic lookup:

| store_name       | city        |
|------------------|-------------|
| Chennai Anna     | Chennai     |
| Delhi South      | Delhi       |
| Bangalore MG     | Bangalore   |
| Pune FC Road     | Pune        |
| Mumbai Central   | Mumbai      |

The corrected city value was applied before loading data into
`dim_store`, so every store row has a non-NULL city.