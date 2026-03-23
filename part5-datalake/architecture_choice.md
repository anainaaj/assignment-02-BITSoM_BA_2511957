## Architecture Recommendation

A Data Lakehouse is the most suitable architecture for a fast-growing food delivery startup handling diverse data types such as GPS logs, customer reviews, payment transactions, and menu images.

First,the system must handle both structured and unstructured data efficiently.GPS logs and transactions are structured or semi-structured,while text reviews and images are unstructured.A traditional Data Warehouse is optimized only for structured data and would struggle with flexibility.However Data Lakehouse,supports all data types in a single platform allowing seamless ingestion and storage.

Second, the startup requires both real-time analytics and reliable reporting.For example, GPS data may be used for live tracking and route optimization, while transaction data is used for financial reporting.A Data Lakehouse combines the scalability of a Data Lake with the ACID guarantees and performance optimizations of a Data Warehouse enabling both use cases without duplication.

Third, cost efficiency and scalability are critical for a growing company.A Data Lakehouse uses low-cost object storage while still enabling high-performance queries using engines like DuckDB .This avoids the high costs associated with scaling traditional warehouses.

Finally, it supports advanced analytics such as machine learning. Customer reviews and images can be directly used for sentiment analysis or recommendation systems without complex data movement.

Therefore, a Data Lakehouse provides the best balance of flexibility, performance and scalability for the startup’s needs.