/* PROJECT: Credit Card Transaction Intelligence
MODULE: Database Schema & Ingestion
*/

CREATE TABLE credit_card_transcations (
    transaction_id INT PRIMARY KEY,
    city VARCHAR(100),
    transaction_date DATE,
    card_type VARCHAR(20),
    exp_type VARCHAR(50),
    gender CHAR(1),
    amount INT
);
