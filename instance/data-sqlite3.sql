PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
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
INSERT INTO users VALUES(1,'scottlefoll@gmail.com','pbkdf2:sha256:600000$AlrOYebQcp2XnnxI$72840982a85025c9e54621eec12333b2cf09f004fe5232c9415dde7a66c1b41e','2023-08-06 13:16:50.188775','2023-08-06 13:16:50.188775',1,'2023-08-06 13:18:50.188775','Admin');
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
INSERT INTO stocks VALUES(1,'MSFT',100,30000,1,'2023-08-04 00:00:00.000000',32778,'2023-08-06 13:24:42.007590',3277800);
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
INSERT INTO watchstocks VALUES(1,'MSFT','Microsoft Corporation',32778,'2023-08-06 13:24:51.873954',21184,36678,'2437204935000',272,3551,227,3420,90,1105,'2023-08-06 13:24:51.992034',1);
COMMIT;
