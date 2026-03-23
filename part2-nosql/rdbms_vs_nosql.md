## Database Recommendation

Patient data is sensitive and safety-critical. If a doctor updates a medication dosage every other doctor must immediately see the correct value as inconsistent data could directly harm someone. **MySQL's ACID** ensures that every write is either fully saved or fully rolled back and every read reflects the latest confirmed state. Patient records also have clear, structured relationships linking patients,doctors,medicines etc which relational tables model naturally does and enforce with foreign keys.

Fraud detection needs to process large volumes of unstructured or semi-structured event data  very quickly and the data shape can vary between events. Here, **MongoDB** becomes a reasonable choice as speed and flexibility matter more than strict consistency.

 A common real-world approach is a **hybrid architecture**: MySQL handles the core patient records while MongoDB handles the fraud detection model.