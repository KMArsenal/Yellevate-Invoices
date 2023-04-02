-- Create a table where we store our data

CREATE TABLE IF NOT EXISTS yellevate_invoices(
	country VARCHAR,
	customer_id VARCHAR,
	invoice_number NUMERIC,
	invoice_date DATE,
	due_date DATE,
	invoice_amount_usd NUMERIC,
	disputed BOOLEAN,
	disputed_lost BOOLEAN,
	settled_date DATE,
	days_to_settle INTEGER,
	days_late INTEGER;
)

-- Import Data "Yellevate Invoices.csv" to yellevate_invoices table
-- Confirm Data if Imported Correctly
SELECT *
FROM yellevate_invoices;


-- DATA CLEANING
-- Checking for NULL values
SELECT *
FROM yellevate_invoices
WHERE 
	(country IS NULL) OR
	(customer_id IS NULL) OR
	(invoice_number IS NULL) OR
	(invoice_date IS NULL) OR
	(due_date IS NULL) OR
	(invoice_amount_usd IS NULL) OR
	(disputed IS NULL) OR
	(disputed_lost IS NULL) OR
	(settled_date IS NULL) OR
	(days_to_settle IS NULL) OR
	(days_late IS NULL);
-- Query didn't return any rows, therefore there are no NULL values in the data


-- Check for inconsistency and messpellings in the country column
SELECT DISTINCT country
FROM yellevate_invoices;
--No inconsistent and misspelled entry


-- Checking for duplicated invoice number entries
-- ORDERED by DESC clause is added so duplicated entries will be whown at the topmost row
SELECT 
	invoice_number, 
	COUNT(invoice_number) AS entries 
FROM yellevate_invoices
GROUP BY invoice_number 
ORDER BY entries DESC;
-- No duplicated entries found


-- Checking for the accuracy of the values in the days_settled column
-- Query should return rows with values in the days_setled column not
-- equal to the diferrence between the invoice_date and settled_date
SELECT *
FROM yellevate_invoices
WHERE 
	days_to_settle != (settled_date-invoice_date);
-- Query didn't return any rows


-- Creating a view for future visualizations of data.
-- disputed and dispute_lost columns were changed for better clarity
CREATE VIEW yellevate_invoices_updated AS 
	SELECT 
		country, 
		customer_id, 
		invoice_number, 
		invoice_date, 
		invoice_amount_usd,
		CASE 
			WHEN CAST(disputed AS VARCHAR) = '1' THEN 'Disputed'
			ELSE 'No Disputed' END AS disputed,
		CASE
			WHEN CAST(dispute_lost AS VARCHAR) = '1' AND CAST(disputed AS VARCHAR) = '1' THEN 'Lost'
			WHEN CAST(dispute_lost AS VARCHAR) = '0' AND CAST(disputed AS VARCHAR) = '1' THEN 'Won'
			ELSE 'No Dispute' END AS dispute_lost,
		days_settled
	FROM yellevate_invoices;


-- Querying our created view to be loaded into our report in Power BI
SELECT *
FROM yellevate_invoices_updated; 














