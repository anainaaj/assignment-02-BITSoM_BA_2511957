# Anomaly Analysis 
## Insert Anomaly

In the current flat table, we cannot insert a new product unless it is part of an order.

Relevant columns: `product_id`, `product_name`, `category`, `unit_price`
**Example**:
Row 0 → product_id = `P004` (Notebook).
All products exist only because they are tied to an `order_id`

>If a new product like `P999` (Mouse) is introduced but not yet ordered, it cannot be stored.

**Problem**: Product catalog cannot exist independently.

## Update Anomaly

Redundant data causes multiple updates for a single logical change.
If the office changes, all such rows must be updated. Missing one row leads to inconsistent data.

**Example**: Sales rep office inconsistency

Row 1 → `SR01` → "Mumbai HQ, Nariman Point..."
Row 37 →` SR01` → "Mumbai HQ, Nariman Pt..."
Same sales rep has two slightly different addresses leading to data inconsistency.

## Delete Anomaly

Deleting an order can remove product/customer info entirely.

Example:
Row 0 → `P004` (Notebook).
If this is the only row containing P004, deleting it removes:
product name,
category,
price.

## Normalization Justification

Keeping everything in a single table may seem simpler initially, but this dataset clearly demonstrates why normalization is necessary.Multiple entities—customers, products, orders, and sales representatives are stored in a single table, leading to redundancy and inconsistency.

For instance, the sales representative `SR01` appears with two slightly different office addresses: “Nariman Point” and “Nariman Pt”. This is a direct result of storing repeated data across rows,creating update anomalies and reducing data reliability.Similarly, product information such as `product_name` and `unit_price` is duplicated across every order containing that product, increasing storage usage and risk of inconsistency.

The structure also limits flexibility.A new product cannot be inserted unless it is associated with an order, and deleting an order may remove all traces of a product or customer.These insert and delete anomalies highlight how fragile the system is.

By decomposing the table into Customers, Products, Orders, Sales_Reps, and Order_Items each entity is stored exactly once. This eliminates redundancy, ensures consistency, and allows independent updates. While normalization introduces more tables, it significantly improves data integrity and scalability, making it essential rather than over-engineering.