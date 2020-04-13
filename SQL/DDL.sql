--DDL
--Elise Anderson
--100945395
--tested on postgres/pgadmin
--Note: some tables names were changed from schema so postgres/pgadmin would accept it

create table address --stores address by name/addressee
	(addressee		varchar(20),
	 street_num		numeric(8, 0),
	 street			varchar(20),
	 city			varchar(30),
	 province		varchar(2),
	 country		varchar(20),
	 primary key (addressee)
	);

--Note: changed from "user" to "users" so postgres/pgadmin would accept it
create table users --base class for owner and customer to inherit
	(email			varchar(20),
	 password		varchar(20),
	 primary key (email)
	);

create table owner --user that restocks books
	(owner_name		varchar(20), 
	 primary key (email)
	)inherits(users); --inherits user table attributes, using format found at https://www.postgresql.org/docs/9.0/ddl-inherit.html

create table customer --user that buys books
	(customer_name		varchar(20), 
	 billing_num		numeric(16,0),
	 primary key (email),
	 foreign key(customer_name) references address(addressee) --name and addressee are same
	)inherits(users); --inherits user table attributes, using format found at https://www.postgresql.org/docs/9.0/ddl-inherit.html

--Note: changed from "order" to "orders" so postgres/pgadmin would accept it
create table orders --tracks order number, address, current location, and billing info
	(tracking_num		numeric(16,0),
	 addressee		varchar(20),
	 billing_num		numeric(16, 0),
	 location		varchar(30),
	 primary key (tracking_num),
	 foreign key (addressee) references address
	);

create table buys --tracks user orders
	(email			varchar(20),
	 tracking_num		numeric(16,0),
	 primary key (email, tracking_num),
	 foreign key (email) references customer,
	 foreign key (tracking_num) references orders
	);

create table publisher --holds publisher contact info
	(publisher_name		varchar(30),
	 email			varchar(20),
	 bank_num		numeric(16, 0),
	 addressee		varchar(20),
	 primary key (publisher_name),
	 foreign key (addressee) references address
	);

create table phone --stores publisher phone numbers
	(phone_num		numeric(11,0),
	 publisher_name		varchar(30),
	 primary key (phone_num),
	 foreign key (publisher_name) references publisher
	);
	
create table inventory --holds store inventory specific book info
	(ISBN			numeric(13, 0),
	 price			numeric(5, 2),
	 percent_to_pub		numeric(3, 2),
	 num_in_stock		numeric(6, 0),
	 primary key (ISBN)
	);

create table book--holds book info
	(title			varchar(50),
	 author			varchar(20),
	 genre			varchar(20),
	 page_num		numeric(4,0),
	 publisher_name		varchar(30),
	 ISBN			numeric(13, 0),
	 primary key (title),
	 foreign key (publisher_name) references publisher,
	 foreign key (ISBN) references inventory
	);


create table sale --tracks every instance of a book being sold
	(ISBN			numeric(13, 0),
	 tracking_num		numeric(16,0),
	 date			numeric(10, 0),
	 num_books		numeric(6, 0),
	 primary key (ISBN, tracking_num),
	 foreign key (ISBN) references inventory,
	 foreign key (tracking_num) references orders
	);

create table restocks --tracks every instance of books being restocked by an owner (or automatically by bot)
	(ISBN			numeric(13, 0),
	 email			varchar(20),
	 date			numeric(10, 0),
	 num_books		numeric(6, 0),
	 primary key (ISBN, email, date),
	 foreign key (ISBN) references inventory,
	 foreign key (email) references owner
	);
