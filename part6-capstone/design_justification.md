## Storage Systems

To meet the hospital’s four goals a hybrid architecture combining multiple storage systems is most appropriate.

For predicting patient readmission risk, I would use a data lake (e.g., S3 or Azure Data Lake) to store raw historical data such as patient records, lab scans, and billing information. On top of this, a data warehouse (e.g., Snowflake, BigQuery, or Redshift) would store cleaned, structured data optimized for analytics and machine learning. This separation allows scalable storage of large volumes of historical data while enabling fast queries for model training.

For plain querying of patient history, a vector database (e.g., Pinecone or Weaviate) is essential. Patient records and clinical notes would be embedded into vector representations, enabling semantic search. This allows doctors to ask natural language questions like “Has this patient had a cardiac event before?” and retrieve contextually relevant answers rather than relying on rigid SQL queries.

For real-time monitoring and alerts (e.g., ICU alerts), a stream processing system (e.g., Kafka + stream processors like Flink or Spark Streaming) combined with a low-latency NoSQL database (e.g., Cassandra or DynamoDB) would be used. This ensures high-throughput ingestion of live data (ICU monitors) and immediate evaluation for anomaly detection or alert generation.

Finally, for reporting and dashboards, the data warehouse again plays a key role. Aggregated and transformed data is stored in reporting tables, enabling tools like Tableau or Power BI to generate monthly reports, cost analysis, and operational insights efficiently.

## OLTP vs OLAP Boundary

In this architecture the OLTP (Online Transaction Processing) system consists of operational databases handling real-time hospital activities. This includes Electronic Health Records (EHR), billing systems, and ICU monitoring systems. These systems are optimized for frequent inserts,updates and low-latency queries. For example, when a patient is admitted or a lab result is recorded, it is written to the OLTP system.

The boundary between OLTP and OLAP occurs at the ETL/streaming ingestion layer (e.g., Kafka pipelines or batch ETL jobs). Data is extracted from transactional systems and moved into the data lake. From there, it is transformed and loaded into the data warehouse for analytical use.

The OLAP (Online Analytical Processing) system begins in the data lake and warehouse layers. This is where historical data is aggregated, cleaned, and structured for analytics, machine learning, and reporting. All AI models, dashboards, and business intelligence queries operate on this side, ensuring that analytical workloads do not interfere with transactional performance.

## Trade-offs

A significant trade-off in this design is increased system complexity due to the use of multiple storage systems (data lake, warehouse, vector database, and streaming infrastructure). While each component is optimized for a specific workload, managing and integrating them introduces operational overhead, higher costs, and potential data consistency challenges.

To mitigate this, I would implement a data orchestration layer using tools like Airflow or managed pipelines to ensure reliable data movement and transformation.Additionally, adopting a data lakehouse approach (e.g., using Delta Lake or Apache Iceberg) can reduce fragmentation by combining lake and warehouse capabilities. Centralized metadata management and data catalogs would also improve governance and discoverability.

By carefully managing these integrations, the system retains flexibility and scalability while minimizing operational complexity.