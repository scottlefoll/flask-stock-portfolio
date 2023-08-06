BEGIN;
PRAGMA writable_schema = on;
PRAGMA encoding = 'UTF-8';
PRAGMA page_size = '4096';
PRAGMA auto_vacuum = '0';
PRAGMA user_version = '0';
PRAGMA application_id = '0';
CREATE TABLE users (
	id INTEGER NOT NULL, 
	email VARCHAR, 
	password_hashed VARCHAR(128), 
	registered_on DATETIME, 
	email_confirmation_sent_on DATETIME, 
	email_confirmed BOOLEAN, 
	email_confirmed_on DATETIME, 
	user_type VARCHAR(10), 
	CONSTRAINT pk_users PRIMARY KEY (id), 
	CONSTRAINT uq_users_email UNIQUE (email)
);
CREATE TABLE stocks (
	id INTEGER NOT NULL, 
	stock_symbol VARCHAR, 
	number_of_shares INTEGER, 
	purchase_price INTEGER, 
	user_id INTEGER, 
	purchase_date DATETIME, 
	current_price INTEGER, 
	current_price_date DATETIME, 
	position_value INTEGER, 
	CONSTRAINT pk_stocks PRIMARY KEY (id), 
	CONSTRAINT fk_stocks_user_id_users FOREIGN KEY(user_id) REFERENCES users (id)
);
CREATE TABLE watchstocks (
	id INTEGER NOT NULL, 
	stock_symbol VARCHAR NOT NULL, 
	company_name VARCHAR, 
	current_share_price INTEGER, 
	current_share_price_date DATETIME, 
	fiftytwo_week_low INTEGER, 
	fiftytwo_week_high INTEGER, 
	market_cap VARCHAR, 
	dividend_per_share INTEGER, 
	pe_ratio INTEGER, 
	peg_ratio INTEGER, 
	profit_margin INTEGER, 
	beta INTEGER, 
	price_to_book_ratio INTEGER, 
	stock_data_date DATETIME, 
	user_id INTEGER, 
	CONSTRAINT pk_watchstocks PRIMARY KEY (id), 
	CONSTRAINT fk_watchstocks_user_id_users FOREIGN KEY(user_id) REFERENCES users (id)
);
INSERT OR IGNORE INTO 'stocks'('id', 'stock_symbol', 'number_of_shares', 'purchase_price', 'user_id', 'purchase_date', 'current_price', 'current_price_date', 'position_value') VALUES (1, 'MSFT', 100, 32778, 1, '2023-08-03 00:00:00.000000', 32778, '2023-08-05 10:19:14.754652', 3277800);
PRAGMA writable_schema = off;
COMMIT;

