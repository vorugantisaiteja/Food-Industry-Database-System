/*DROP COMMANDS*/
-- Drop table commands
drop table orders;
Drop Table Restaurant_Inventory;
Drop Table Menu_Items;
drop table Waiters;
drop table Restaurants;
drop table Cusine_Types;
drop table customers;


/*Drop Sequences*/
drop sequence cusine_types_seq;
drop sequence restaurants_seq;
drop sequence waiters_seq;
Drop Sequence miid_seq;
drop sequence o_id_seq;
drop sequence cust_id_seq;


/
/* CREATE TABLE COMMANDS*/

/* Create Cusisine Type Table*/
CREATE TABLE Cusine_Types (
    ct_ID int NOT NULL PRIMARY KEY,
    ct_Name varchar(20)
);

/* Create Restaurants Table*/
CREATE TABLE Restaurants (
    r_ID int NOT NULL PRIMARY KEY,
    r_Name varchar(20) ,
    r_st_addr varchar(30),
    r_city varchar(20),
    r_state varchar(20),
    r_zip number,
    ct_id int,
    FOREIGN KEY (ct_ID) REFERENCES Cusine_Types(ct_ID)
);

/* Create Waiters Table*/
CREATE TABLE Waiters (
    w_ID int NOT NULL PRIMARY KEY,
    w_Name varchar(20),
    r_id int,
    FOREIGN KEY (r_id) REFERENCES Restaurants(r_id)
);

/* Creation of Menu_Items Table*/
Create table Menu_Items (
    mi_id int PRIMARY KEY,
    mitem_name varchar(20),
    mi_price number,
    ct_id int,
    FOREIGN KEY (ct_id) REFERENCES Cusine_Types(ct_ID)

);

/*Creation of Restaurant_Inventory Table*/
Create table Restaurant_Inventory (
   mi_id int,          
   mitem_name varchar(20),
   r_id int,
   quantity number,
   FOREIGN KEY (mi_id) REFERENCES Menu_Items(mi_id),
   FOREIGN KEY (r_id) REFERENCES Restaurants(r_id)
);

/*Customers Table*/
create table customers
(
customer_id int primary key, --primary key is created
customer_name varchar(20),
Email_id varchar(70),
Street varchar(50),
City varchar(20),
State varchar(20),
Zip_Code int,
Credit_Card varchar(20)
);
/

/* Creation of Orders Table*/

create table ORDERS (
               O_ID int,
               R_ID int,
               Cust_ID int,
               MI_ID int,
               W_ID int,
               Order_date date,
               Amount_paid number,
               Tip number,
	      primary key (O_ID),
               foreign key (R_ID) references restaurants(R_ID),
               foreign key (Cust_ID) references customers(Customer_ID),
               foreign key (MI_ID) references menu_items(MI_ID),
               foreign key (W_ID) references waiters(W_ID)
);





/* Create Sequences*/

CREATE SEQUENCE Cusine_Types_seq
 START WITH 1
 INCREMENT BY 1
 NOCACHE;
 
CREATE SEQUENCE Restaurants_seq
 START WITH 1
 INCREMENT BY 1
 NOCACHE; 

CREATE SEQUENCE Waiters_seq
 START WITH 1
 INCREMENT BY 1
 NOCACHE; 
 
--Creates a sequence of ids for menu items
Create Sequence miid_seq START with 1 increment by 1;

--Creates a sequence of ids for ORDERS
create sequence o_id_seq start with 1 increment by 1;

--creating sequence
create sequence cust_id_seq start with 1;


/*Procedure: add_Cuisine_type 
Purpose: To add values to Cusine_Types Table */
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE add_Cuisine_type(ct_ID INT,ct_Name VARCHAR )
IS
begin
insert into Cusine_Types values(ct_ID,ct_Name);
Exception
   When others Then
   dbms_output.put_line('Error Found While Inserting data');
end;

/*Populating Values to Cuisine Type Table */
/
Set Serveroutput on;
Begin
add_Cuisine_type(Cusine_Types_seq.NEXTVAL, 'American');
add_Cuisine_type(Cusine_Types_seq.NEXTVAL, 'Italian');
/*Deliverable 3 : Member 1*/
add_Cuisine_type(Cusine_Types_seq.NEXTVAL, 'BBQ');
add_Cuisine_type(Cusine_Types_seq.NEXTVAL, 'Indian');
add_Cuisine_type(Cusine_Types_seq.NEXTVAL, 'Ethiopian');
End;
/


/*PROCEDURE: add_Restaurant
Purpose: To add values to Restaurants Table*/
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE add_Restaurant( r_ID int ,
                                             r_Name varchar,
                                             r_st_addr varchar,
                                             r_city varchar,
                                             r_state varchar,
                                             r_zip number,
                                             ct_id int)
IS
begin
insert into Restaurants values( r_ID,r_Name ,r_st_addr,r_city ,r_state ,r_zip ,ct_id) ;
Exception
   When others Then
   dbms_output.put_line('Error Found While Inserting data');
end;
/

/*Function: FIND_CUISINE_TYPE_ID
Purpose: To find the Cuisine Type ID from Cuisine Type Name */
SET SERVEROUTPUT ON;
create or replace function FIND_CUISINE_TYPE_ID(cuisineName in varchar) return int
is 
cuisineId int;
begin
select ct_ID  into cuisineId from Cusine_Types where ct_Name = cuisineName;
return cuisineId;
exception 
    when no_data_found then
    dbms_output.put_line('No data Found, this Cuisine is not in the database');
WHEN OTHERS THEN 
DBMS_OUTPUT.PUT_LINE ('Too many rows');
end FIND_CUISINE_TYPE_ID;

/*Populating values to Restaurant Table*/
/
Set Serveroutput on;
Begin
 add_Restaurant(Restaurants_seq.NEXTVAL,'Ribs_R_US','Regina Dr', 'Halethorpe','MD',21250, FIND_CUISINE_TYPE_ID('American'));
 add_Restaurant(Restaurants_seq.NEXTVAL,'Bella Italia','Circle Dr', 'Halethorpe','MD',21043, FIND_CUISINE_TYPE_ID('Italian'));

/*Deliverable 3 : Member 1*/
 add_Restaurant(Restaurants_seq.NEXTVAL,'Roma','Westland Gardens', 'Arbutus','MD',21043, FIND_CUISINE_TYPE_ID('Italian'));
 add_Restaurant(Restaurants_seq.NEXTVAL,'Bull Roast','Maiden Choice', 'Arbutus','NY',10013, FIND_CUISINE_TYPE_ID('BBQ'));
 add_Restaurant(Restaurants_seq.NEXTVAL,'Taj Mahal','Towson', 'Baltimore','NY',10013, FIND_CUISINE_TYPE_ID('Indian'));
 add_Restaurant(Restaurants_seq.NEXTVAL,'Selasie','Towson', 'Baltimore','PA',16822, FIND_CUISINE_TYPE_ID('Ethiopian'));
 add_Restaurant(Restaurants_seq.NEXTVAL,'Ethiop','Fells Point', 'Charles Town','PA',16822, FIND_CUISINE_TYPE_ID('Ethiopian'));
 END;
/


--Procedure for Listing the data of Restaurant Table--
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE List_RestaurantTable AS
Rest_REC     Restaurants%ROWTYPE;
CURSOR cur IS SELECT * FROM Restaurants;
BEGIN
OPEN cur;
dbms_output.Put_line('---------------Restaurant Details-----------');
LOOP
    FETCH cur INTO Rest_REC;
    EXIT WHEN cur%NOTFOUND;
    

    dbms_output.Put_line('Restaurant ID:'||Rest_REC.R_ID||
                                            '   Restaurant_Name:'||Rest_REC.R_name||
                                            '   Address:'||Rest_REC.r_st_addr||
                                            '   City:'|| Rest_REC.r_City ||
                                            '   State:'||Rest_REC.R_state ||
                                            '   ZIP:'||Rest_REC.r_Zip);
  END LOOP;
CLOSE cur; 
Exception
   When others Then
   dbms_output.put_line('Error Found while Executing');
END;
/*Displaying the Restaurant Table */

/
set serveroutput on;
Begin
List_RestaurantTable;
End;
/


/*Function: FIND_RESTAURANT_ID
Purpose: To find the Restaurant ID from Restaurant Name */
SET SERVEROUTPUT ON;
create or replace function FIND_RESTAURANT_ID(RestaurantName in varchar) return int
is
restaurantid INT;
begin
select Restaurants.r_Id into restaurantid from Restaurants where RestaurantName=Restaurants.r_Name;
    return restaurantid;
exception 
    when no_data_found then
    dbms_output.put_line('No data Found, this Restaurant is not in the database');
WHEN OTHERS THEN 
DBMS_OUTPUT.PUT_LINE ('Too many rows');
end FIND_RESTAURANT_ID;
/

/*PROCEDURE: Hire_Waiter
Purpose: To populate values into Waiter Table */
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE Hire_Waiter ( w_ID int ,
                                             w_Name varchar,
                                             r_Id int)
IS
begin
insert into Waiters values( w_ID, w_Name,r_ID);
Exception
   When others Then
   dbms_output.put_line('Error Found While Inserting data');
end;

/*Execute commands for entering data into the Waiiter Table */
/
Set Serveroutput on;
Begin
 Hire_Waiter(Waiters_seq.NEXTVAL,'Jack',FIND_RESTAURANT_ID('Ribs_R_US'));
 Hire_Waiter(Waiters_seq.NEXTVAL,'Jill',FIND_RESTAURANT_ID('Ribs_R_US'));
 Hire_Waiter(Waiters_seq.NEXTVAL,'Wendy',FIND_RESTAURANT_ID('Ribs_R_US'));

 Hire_Waiter(Waiters_seq.NEXTVAL,'Mary',FIND_RESTAURANT_ID('Bella Italia'));
 Hire_Waiter(Waiters_seq.NEXTVAL,'Pat',FIND_RESTAURANT_ID('Bella Italia'));
 Hire_Waiter(Waiters_seq.NEXTVAL,'Michael',FIND_RESTAURANT_ID('Bella Italia'));
 Hire_Waiter(Waiters_seq.NEXTVAL,'Rakesh',FIND_RESTAURANT_ID('Bella Italia'));
 Hire_Waiter(Waiters_seq.NEXTVAL,'Verma',FIND_RESTAURANT_ID('Bella Italia'));

 Hire_Waiter(Waiters_seq.NEXTVAL,'Mike',FIND_RESTAURANT_ID('Roma'));
 Hire_Waiter(Waiters_seq.NEXTVAL,'Judy',FIND_RESTAURANT_ID('Roma'));
 Hire_Waiter(Waiters_seq.NEXTVAL,'Trevor',FIND_RESTAURANT_ID('Selasie'));
 Hire_Waiter(Waiters_seq.NEXTVAL,'Chap',FIND_RESTAURANT_ID('Taj Mahal'));
 Hire_Waiter(Waiters_seq.NEXTVAL,'Hannah',FIND_RESTAURANT_ID('Bull Roast'));

 Hire_Waiter(Waiters_seq.NEXTVAL,'Trudy',FIND_RESTAURANT_ID('Ethiop'));
 Hire_Waiter(Waiters_seq.NEXTVAL,'Trisha',FIND_RESTAURANT_ID('Ethiop'));
 Hire_Waiter(Waiters_seq.NEXTVAL,'Tariq',FIND_RESTAURANT_ID('Ethiop'));
 END;
 /





/*Function: FIND_Waiter_ID
Purpose: This Procedure finds the Waiter ID given the Waiter name*/
SET SERVEROUTPUT ON;
create or replace function FIND_Waiter_ID(WaiterName in varchar) return int
is
waiterid INT;
begin
select Waiters.w_Id into waiterid from Waiters where WaiterName=Waiters.w_Name;
    return waiterid;
exception 
    when no_data_found then
    dbms_output.put_line('No data Found, this Waiter is not in the database');
WHEN OTHERS THEN 
DBMS_OUTPUT.PUT_LINE ('Too many rows');
end FIND_Waiter_ID;

/
/*PROCEDURE: Display_List_of_Waiters
Purpose: This Procedure Displays the Waiter Details given the input parameter of Restaurant name*/
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE Display_List_of_Waiters(restaurantName in varchar) AS
Waiter_REC     Waiters%ROWTYPE;
CURSOR cur IS SELECT * FROM Waiters where r_ID= FIND_RESTAURANT_ID(restaurantName);
BEGIN
OPEN cur;
dbms_output.Put_line('---List of Waiters working at ' || restaurantName || ' are as follows---');
LOOP
    FETCH cur INTO Waiter_REC;
    EXIT WHEN cur%NOTFOUND;
    
    dbms_output.Put_line('Waiter Details -->   ID:' 
                         ||Waiter_REC.w_ID 
                         ||',  Name: ' 
                         ||Waiter_REC.w_Name 
                         ||', Restaurant Name: ' 
                         ||restaurantName); 
                         
  END LOOP;
       dbms_output.Put_line('------------------------------------------------------------------');                    

CLOSE cur; 
Exception
   When others Then
   dbms_output.put_line('Error Found while Executing');
END;
/
/*Displaying Waiter Details of Waiters working at Bella Italia Restaurant*/
Set Serveroutput on;
Begin
 Display_List_of_Waiters('Bella Italia');
END;
/
/*Deliverable 3
Group: T11
Name: Manisha Yadav
Task: Member 1*/

/*PROCEDURE: Display_Restaurant_By_Cuisine
Purpose: This Procedure Displays the Restaurant Details given the input parameter of Cuisine name*/
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE Display_Restaurant_By_Cuisine(CuisineName in varchar) AS
Res_rec  Restaurants%ROWTYPE;
CURSOR cur IS SELECT * FROM Restaurants where ct_ID=FIND_CUISINE_TYPE_ID(CuisineName);
BEGIN
dbms_output.Put_line( 'Cuisine Name ' ||'    '|| 'Restaurant Name ' ||'   '|| ' Restaurant Address'); 
dbms_output.Put_line('--------------------------------------------------------------------------------');
OPEN cur; 
LOOP
    FETCH cur INTO Res_rec;
    EXIT WHEN cur%NOTFOUND;
     dbms_output.Put_line( CuisineName ||'           '||Res_rec.r_Name ||'           '|| Res_rec.r_st_addr || ',' || Res_rec.r_City || ',' || Res_rec.r_state || ',' || Res_rec.r_zip); 
  
  END LOOP;
CLOSE cur;
dbms_output.Put_line('--------------------------------------------------------------------------------');
Exception
   When others Then
   dbms_output.put_line('Error Found While Executing');
END;
/
/*Displaying Restaurant Details offering American Cuisine*/
Set Serveroutput on;
Begin

 Display_Restaurant_By_Cuisine('Italian');
 Display_Restaurant_By_Cuisine('Ethiopian');
 Display_Restaurant_By_Cuisine('BBQ');
 Display_Restaurant_By_Cuisine('American');
 Display_Restaurant_By_Cuisine('Indian');
END;
/



/*Displaying Waiter Details of Waiters working at a particular Restaurant*/
set serveroutput on;
Begin
Display_List_of_Waiters('Roma');
Display_List_of_Waiters('Bella Italia');
Display_List_of_Waiters('Ethiop'); 
END;
/




/* Member 3*/
/*Sai Teja Voruganti*/
Create or Replace Procedure INSERT_MENU_ITEMS(item_name varchar,price number,ctid int)
AS
Begin
   Insert into Menu_Items 
   (mi_id,mitem_name,mi_price,ct_id) 
   values
   (miid_seq.nextval,item_name,price,ctid);
Exception
   When others Then
   dbms_output.put_line('Error Found While Inserting data');
End INSERT_MENU_ITEMS;
/

/*Procedure for inserting records into Restaurant Table*/
Create or Replace Procedure INSERT_RESTAURANT_INVENTORY(menu_id int,item_name varchar,res_id int,item_quant number)
AS
Begin
   INSERT into Restaurant_Inventory(mi_id,mitem_name,r_id,quantity)
values
  (menu_id,item_name,res_id,item_quant);
   Exception
       When others Then
       dbms_output.put_line('Error Found While Inserting data');
End INSERT_RESTAURANT_INVENTORY;
/

/*Procedure for Listing the data of Restaurant Inventory wrt Restaurant Name*/
Set Serveroutput on;
Create or Replace Procedure List_ResInven(Res_name varchar)
AS
Begin
   for i in (select * from Restaurant_Inventory where r_id=FIND_RESTAURANT_ID(Res_name))
   loop
   dbms_output.put_line('Restaurant_Name:'||Res_name||' Menu_ItemId:'||i.MI_ID||'  Item_name:'|| i.MITEM_NAME ||' Restaurant_ID:'||i.R_ID ||' Quantity:'||i.QUANTITY);
   --Select MI_ID ,MITEM_NAME ,R_ID ,QUANTITY  from Restaurant_Inventory where r_id=FIND_RESTAURANT_ID(Res_name); 
End loop;
EXCEPTION
     WHEN others THEN
     dbms_output.put_line('Error while fetching data!');
End List_ResInven;
/

/*Procedure for updating the Restaurant Inventory */
Create or Replace Procedure REDUCE_INVENTORY(item_name varchar,rid int,quant number)
AS
Begin
   Update restaurant_inventory SET quantity=quantity-quant where mitem_name=item_name and r_id=rid;
   dbms_output.put_line(item_name||' quantity has been reduced by '||quant);

End REDUCE_INVENTORY;
/

/*FIND_MENU_ITEM_ID function returns Menu_Item_Id*/
Create or replace function FIND_MENU_ITEM_ID(item_name varchar)
  return int
IS
  menuitem_id int;
Begin
  Select mi_id into menuitem_id from Menu_Items where mitem_name=item_name;
  return menuitem_id;
  Exception
  WHEN others THEN
  dbms_output.put_line('Error While Fetching the data');
End FIND_MENU_ITEM_ID;
/

/*Inserting into Menu Items Table*/
Set Serveroutput on;
Begin
INSERT_MENU_ITEMS('burger',10,FIND_CUISINE_TYPE_ID('American'));
INSERT_MENU_ITEMS('fries',5,FIND_CUISINE_TYPE_ID('American'));
INSERT_MENU_ITEMS('pasta',15,FIND_CUISINE_TYPE_ID('American'));
INSERT_MENU_ITEMS('salad',10,FIND_CUISINE_TYPE_ID('American'));
INSERT_MENU_ITEMS('salmon',20,FIND_CUISINE_TYPE_ID('American'));
INSERT_MENU_ITEMS('lasagna',15,FIND_CUISINE_TYPE_ID('Italian'));
INSERT_MENU_ITEMS('meatballs',10,FIND_CUISINE_TYPE_ID('Italian'));
INSERT_MENU_ITEMS('spaghetti',15,FIND_CUISINE_TYPE_ID('Italian'));
INSERT_MENU_ITEMS('pizza',20,FIND_CUISINE_TYPE_ID('Italian'));


INSERT_MENU_ITEMS('steak',25,FIND_CUISINE_TYPE_ID('BBQ'));
INSERT_MENU_ITEMS('Burger',10,FIND_CUISINE_TYPE_ID('BBQ'));
INSERT_MENU_ITEMS('pork loin',15,FIND_CUISINE_TYPE_ID('BBQ'));
INSERT_MENU_ITEMS('fillet mignon',30,FIND_CUISINE_TYPE_ID('BBQ'));

INSERT_MENU_ITEMS('dal soup',10,FIND_CUISINE_TYPE_ID('Indian'));
INSERT_MENU_ITEMS('rice',5,FIND_CUISINE_TYPE_ID('Indian'));
INSERT_MENU_ITEMS('tandoori chicken',10,FIND_CUISINE_TYPE_ID('Indian'));
INSERT_MENU_ITEMS('samosa',8,FIND_CUISINE_TYPE_ID('Indian'));

INSERT_MENU_ITEMS('meat chunks',12,FIND_CUISINE_TYPE_ID('Ethiopian'));
INSERT_MENU_ITEMS('legume stew',10,FIND_CUISINE_TYPE_ID('Ethiopian'));
INSERT_MENU_ITEMS('flatbread',3,FIND_CUISINE_TYPE_ID('Ethiopian'));

End;
/

/*Calling Insert_Restaurant_Inventory Procedure for inserting values*/
Set Serveroutput on;
Begin
INSERT_RESTAURANT_INVENTORY(FIND_MENU_ITEM_ID('burger'),'burger',FIND_RESTAURANT_ID('Ribs_R_US'),50);
INSERT_RESTAURANT_INVENTORY(FIND_MENU_ITEM_ID('fries'),'fries',FIND_RESTAURANT_ID('Ribs_R_US'),150);
INSERT_RESTAURANT_INVENTORY(FIND_MENU_ITEM_ID('lasagna'),'lasagna',FIND_RESTAURANT_ID('Bella Italia'),10);
INSERT_RESTAURANT_INVENTORY(FIND_MENU_ITEM_ID('meatballs'),'meatballs',FIND_RESTAURANT_ID('Bella Italia'),5);

INSERT_RESTAURANT_INVENTORY(FIND_MENU_ITEM_ID('steak'),'steak',FIND_RESTAURANT_ID('Bull Roast'),15);
INSERT_RESTAURANT_INVENTORY(FIND_MENU_ITEM_ID('pork loin'),'pork loin',FIND_RESTAURANT_ID('Bull Roast'),50);
INSERT_RESTAURANT_INVENTORY(FIND_MENU_ITEM_ID('fillet mignon'),'fillet mignon',FIND_RESTAURANT_ID('Bull Roast'),5);

INSERT_RESTAURANT_INVENTORY(FIND_MENU_ITEM_ID('dal soup'),'dal soup',FIND_RESTAURANT_ID('Taj Mahal'),50);
INSERT_RESTAURANT_INVENTORY(FIND_MENU_ITEM_ID('rice'),'rice',FIND_RESTAURANT_ID('Taj Mahal'),500);
INSERT_RESTAURANT_INVENTORY(FIND_MENU_ITEM_ID('samosa'),'samosa',FIND_RESTAURANT_ID('Taj Mahal'),150);

INSERT_RESTAURANT_INVENTORY(FIND_MENU_ITEM_ID('meat chunks'),'meat chunks',FIND_RESTAURANT_ID('Selasie'),150);
INSERT_RESTAURANT_INVENTORY(FIND_MENU_ITEM_ID('legume stew'),'legume stew',FIND_RESTAURANT_ID('Selasie'),150);
INSERT_RESTAURANT_INVENTORY(FIND_MENU_ITEM_ID('flatbread'),'flatbread',FIND_RESTAURANT_ID('Selasie'),500);

INSERT_RESTAURANT_INVENTORY(FIND_MENU_ITEM_ID('meat chunks'),'meat chunks',FIND_RESTAURANT_ID('Ethiop'),150);
INSERT_RESTAURANT_INVENTORY(FIND_MENU_ITEM_ID('legume stew'),'legume stew',FIND_RESTAURANT_ID('Ethiop'),150);
INSERT_RESTAURANT_INVENTORY(FIND_MENU_ITEM_ID('flatbread'),'flatbread',FIND_RESTAURANT_ID('Ethiop'),500);

End;
/

/*Calling a Procedure for Listing the data of Restaurant Inventory wrt Restaurant Name*/
Set Serveroutput on;
Begin
dbms_output.put_line('-----------------Listing Restaurant Inventory by Restaurant Name---------------------');
List_ResInven('Taj Mahal');
List_ResInven('Selasie');
List_ResInven('Bull Roast');
End;
/

/*Calling a Procedure for Listing the data of Restaurant Inventory wrt Restaurant Name*/
Set Serveroutput on;
Begin
REDUCE_INVENTORY('rice',FIND_RESTAURANT_ID('Taj Mahal'),25);
REDUCE_INVENTORY('meat chunks',FIND_RESTAURANT_ID('Selasie'),50);
REDUCE_INVENTORY('fillet mignon',FIND_RESTAURANT_ID('Bull Roast'),2);

REDUCE_INVENTORY('fillet mignon',FIND_RESTAURANT_ID('Bull Roast'),2);

dbms_output.put_line('---------------  Initial Inventory for Ethiop restaurant -------------------');
List_ResInven('Ethiop');
REDUCE_INVENTORY('meat chunks',FIND_RESTAURANT_ID('Ethiop'),30);
REDUCE_INVENTORY('meat chunks',FIND_RESTAURANT_ID('Ethiop'),30);
REDUCE_INVENTORY('legume stew',FIND_RESTAURANT_ID('Ethiop'),20);
dbms_output.put_line('---------------  Final  Inventory for Ethiop restaurant -------------------');
List_ResInven('Ethiop');


End;
/


/*Member 5*/
/*Creating and Insert Procedure*/

CREATE OR REPLACE PROCEDURE Customer_insert
(name IN VARCHAR, Email IN VARCHAR, Street_address VARCHAR, City_name VARCHAR, State_name VARCHAR, Zip int, Credit_card_no varchar) AS
BEGIN
   INSERT INTO customers(customer_id,customer_name,Email_id,Street,City,State,Zip_Code,Credit_Card) VALUES(cust_id_seq.nextval,name,Email,Street_address,City_name,State_name,Zip,Credit_card_no );
END Customer_insert;
/

/*Insert Values INTO CUSTOMERS TABLE*/
SET SERVEROUTPUT ON;
begin
Customer_insert('Cust1','cust1@umbc.edu','Westland','Halethorpe','MD',21045,'1232-2321-5135-6454');
Customer_insert('Cust11','cust11@gmail.com','Normandy','Ellicot','MD',21045,'4734-6344-7344-7454');
Customer_insert('Cust3','cust3@yahoo.com','Maiden Choice','Arbutus','MD',21046,'1232-3256-7544-7345');
Customer_insert('Cust111','cust111@sreenidhi.edu','Chapel Sqr','Halethorpe','MD',21045,'2135-6345-7354-7345');
customer_insert('CustNY1','custNY1@sap.edu','columbia','quaz','NY',10045,'7421-8564-2346-1058');
customer_insert('CustNY2','custNY2@vnr.edu','elden','arbutus','NY',10045,'9517-7532-4589-3512');
customer_insert('CustNY3','custNY3@kits.edu','howla land','arbutus','NY',10045,'1248-8579-2469-3279');
customer_insert('CustPA1','custPA1@GMIT.edu','girmajipet','warangal','PA',16822,'0583-4803-8529-3259');
customer_insert('CustPA2','custPA2@kmit.edu','boduppal','hyd','PA',16822,'1837-5091-6207-7843');
customer_insert('CustPA3','custPA3@cvr.edu','sainagar','kazipet','PA',16822,'7814-5946-2080-7090');
customer_insert('CustPA4','custPA4@cvsr.edu','kukatpalli','hyd','PA',16822,'9857-0571-9846-8859');
customer_insert('CustPA5','custPA5@mason.edu','churchstreet','bangl','PA',16822,'4568-8652-9576-2287');
customer_insert('CustPA6','custPA6@quot.edu','kasibugga','warangal','PA',16822,'2583-7801-9586-0159');
End;
/


/*Creating a Function (Find_Customer_ID)*/

Create or replace function Find_Customer_ID (name IN VARCHAR2) return int
IS
ID int;
BEGIN
select Customer_ID into ID from Customers where Customer_name = name;
return ID;
END Find_Customer_ID;
/

/*creating a calling function
SET SERVEROUTPUT ON;
begin
dbms_output.put_line(Find_Customer_ID('Cust1'));
end;
/
*/

/*creating cursor to list customer names with zipcode*/
CREATE OR REPLACE PROCEDURE Customers_Zipcode(zip IN Customers.zip_code%TYPE)
IS
Cursor c1 is SELECT customer_name, zip FROM customers WHERE zip = zip_code; -- creating cursor
c_name Customers.customer_name%type; -- Customer name variable where the cursor will store data from the table
BEGIN
FOR item IN c1 -- for loop to iterate through Customers table
LOOP
dbms_output.put_line(item.customer_name); -- printing out customer name
END LOOP;
EXCEPTION -- exception handling
when no_data_found then dbms_output.put_line('No data found');
when others then dbms_output.put_line('Error');
COMMIT;
END;
/

--procedure calling

BEGIN
dbms_output.put_line('Customers who live in the zipcode- 21045');
Customers_Zipcode('21045');
END;
/

/*creating a HELPER FUNCTION*/
CREATE OR REPLACE FUNCTION FIND_CUSTOMER_NAME(cust_id IN integer)
RETURN varchar IS
name varchar(50); -- VARIABLE THAT HAS TO RETURN
BEGIN
SELECT customer_name INTO name FROM Customers WHERE customer_id = cust_id;
RETURN name;
EXCEPTION
when no_data_found then dbms_output.put_line('No such customer');
return -1;
END;	
/

/*Member 4*/
/*function created for FIND_ORDER_ID*/
create or replace function FIND_ORDER_ID(O_date date)
  return int
IS
  order_id int;
Begin
  Select O_ID into order_id from orders where Order_date= O_date;
  return order_id;
exception 
    when no_data_found then
    dbms_output.put_line('No data Found, this orderdate is not in the database');
WHEN OTHERS THEN 
DBMS_OUTPUT.PUT_LINE ('Too many rows');
end;
/

/*PROCEDURE to add records for ORDERS*/
create or replace Procedure Add_New_Order(o_id INT,
                                          r_id INT,
                                          cust_id INT,
                                          mi_id INT,
                                          w_id INT,
                                          order_date date, 
                                          amount_paid Number
                                          )
AS
tip Number;
Begin
   tip:=amount_paid*0.2;
   INSERT into ORDERS
values
  (o_id,r_id,cust_id,mi_id,w_id,to_date(order_date,'yyyy-mm-dd'),amount_paid,tip);
End Add_New_Order;
/

--Adding records in Orders Table by calling the proc


Set Serveroutput on;
Begin
Add_New_Order(o_id_seq.nextval,FIND_RESTAURANT_ID('Bella Italia'),Find_Customer_ID('Cust1'),FIND_MENU_ITEM_ID('pizza'),FIND_Waiter_ID('Mary'),to_date('2022-03-10','yyyy-mm-dd'),20);
Add_New_Order(o_id_seq.nextval,FIND_RESTAURANT_ID('Bella Italia'),Find_Customer_ID('Cust11'),FIND_MENU_ITEM_ID('spaghetti'),FIND_Waiter_ID('Mary'),to_date('2022-03-15','yyyy-mm-dd'),30);
Add_New_Order(o_id_seq.nextval,FIND_RESTAURANT_ID('Bella Italia'),Find_Customer_ID('Cust11'),FIND_MENU_ITEM_ID('pizza'),FIND_Waiter_ID('Mary'),to_date('2022-03-15','yyyy-mm-dd'),20);
Add_New_Order(o_id_seq.nextval,FIND_RESTAURANT_ID('Bull Roast'),Find_Customer_ID('CustNY1'),FIND_MENU_ITEM_ID('fillet mignon'),FIND_Waiter_ID('Hannah'),to_date('2022-04-01','yyyy-mm-dd'),60);
Add_New_Order(o_id_seq.nextval,FIND_RESTAURANT_ID('Bull Roast'),Find_Customer_ID('CustNY1'),FIND_MENU_ITEM_ID('fillet mignon'),FIND_Waiter_ID('Hannah'),to_date('2022-04-02','yyyy-mm-dd'),60);
Add_New_Order(o_id_seq.nextval,FIND_RESTAURANT_ID('Bull Roast'),Find_Customer_ID('CustNY2'),FIND_MENU_ITEM_ID('pork loin'),FIND_Waiter_ID('Hannah'),to_date('2022-04-01','yyyy-mm-dd'),15);
Add_New_Order(o_id_seq.nextval,FIND_RESTAURANT_ID('Ethiop'),Find_Customer_ID('CustPA1'),FIND_MENU_ITEM_ID('meat chunks'),FIND_Waiter_ID('Trisha'),to_date('2022-04-01','yyyy-mm-dd'),120);
Add_New_Order(o_id_seq.nextval,FIND_RESTAURANT_ID('Ethiop'),Find_Customer_ID('CustPA1'),FIND_MENU_ITEM_ID('meat chunks'),FIND_Waiter_ID('Trisha'),to_date('2022-05-01','yyyy-mm-dd'),120);
Add_New_Order(o_id_seq.nextval,FIND_RESTAURANT_ID('Ethiop'),Find_Customer_ID('CustPA1'),FIND_MENU_ITEM_ID('meat chunks'),FIND_Waiter_ID('Trisha'),to_date('2022-05-10','yyyy-mm-dd'),120);
Add_New_Order(o_id_seq.nextval,FIND_RESTAURANT_ID('Ethiop'),Find_Customer_ID('CustPA2'),FIND_MENU_ITEM_ID('meat chunks'),FIND_Waiter_ID('Trevor'),to_date('2022-05-01','yyyy-mm-dd'),100);
Add_New_Order(o_id_seq.nextval,FIND_RESTAURANT_ID('Ethiop'),Find_Customer_ID('CustPA2'),FIND_MENU_ITEM_ID('meat chunks'),FIND_Waiter_ID('Trevor'),to_date('2022-05-11','yyyy-mm-dd'),100);

End;
/



--Proc to call the List of records from orders table with order_date as parameter—
/
create or replace PROCEDURE Display_List_of_orders(o_date in date) AS
Order_REC    orders%ROWTYPE;
CURSOR cur IS SELECT * FROM orders where order_date=o_date;
BEGIN
OPEN cur;
LOOP
    FETCH cur INTO Order_REC;
    EXIT WHEN cur%NOTFOUND;

    dbms_output.Put_line('Order Details -->   ID:' 
                         ||Order_REC.O_ID 
                         ||',  Date: ' 
                         || Order_REC.order_date ); 
END LOOP;
CLOSE cur; 
END;
/

--create proc to insert record for orders
/
create or replace Procedure INSERT_ORDERS(or_id int,rest_id int,customer_id int,menuitem_id int,waiter_id int,Or_date date,amo_paid number,tip_given number)
AS
Begin
   INSERT into Orders(o_id,r_id,cust_id,mi_id,w_id,order_date,amount_paid,tip)
values
  (or_id,rest_id,customer_id,menuitem_id,waiter_id,Or_date,amo_paid,tip_given);
   Exception
       When others Then
       dbms_output.put_line('Error Found While Inserting data');
End INSERT_ORDERS;
/






/*-----------------------------------------Reports Section---------------------------------------------*/
/*---------------------------Member1 Reports------------------------*/
/*PROCEDURE: Report_Income_by_state
Purpose: This Procedure generates a report that lists the income of restaurants per cuisine type and per state.*/
SET SERVEROUTPUT ON;
create or replace procedure Report_Income_by_state
is
CURSOR cur_res IS
        select cusine_Types.ct_Name, restaurants.r_State, sum(orders.amount_paid)
        from orders, restaurants,cusine_Types where orders.r_id=restaurants.r_id and cusine_Types.ct_id= restaurants.ct_id  
        group by cusine_Types.ct_Name, restaurants.r_State;

    v_name  cusine_Types.ct_Name%type;
    v_state restaurants.r_State%type;
    v_sum orders.amount_paid%type;
    
BEGIN
    OPEN cur_res;
    dbms_output.Put_line('========================================================================
========================================================================
');
dbms_output.Put_line('-------------------------- REPORT BY MEMBER 1 ---------------');
    dbms_output.Put_line('------------------------REPORTING INCOME BY STATE ---------------');
    dbms_output.Put_line('Cuisine Type   ' || '   State  ' ||'  Income  '); 

    LOOP
    FETCH cur_res INTO v_name,v_state,v_sum;
 EXIT WHEN cur_res%NOTFOUND;
 
    dbms_output.Put_line(v_name ||'        '|| v_state ||'        ' || v_sum);
     
  END LOOP;
  dbms_output.Put_line('========================================================================
========================================================================
');
CLOSE cur_res;
Exception
   When others Then
   dbms_output.put_line('Error Found While Executing');
END;
/
set serveroutput on;
Begin
 Report_Income_by_state;
 END;
/

/*---------------------------Member2 Reports------------------------*/

Set Serveroutput on;
create or replace procedure Report_Tips
is
CURSOR cur_res IS
    select waiters.W_name, sum(orders.tip) from waiters , orders where orders.w_id=waiters.w_id group by waiters.W_name;
    v_name  waiters.W_name%type;
    v_sum orders.tip%type;   
BEGIN
       dbms_output.put_line('========================================================================');
       dbms_output.put_line(' -------------------------- REPORT BY MEMBER 2 -----------------------');
       dbms_output.Put_line('------------------------REPORTING TIPS BY WAITER ---------------');
    OPEN cur_res;
    LOOP
    FETCH cur_res INTO v_name,v_sum;
 EXIT WHEN cur_res%NOTFOUND;
    dbms_output.Put_line('Waiter Name : '||v_name ||'  Tips: '|| v_sum); 
  END LOOP;
CLOSE cur_res;
   dbms_output.put_line('========================================================================');
END;
/
/*---------------------------Member2 Reports------------------------*/
Set Serveroutput on;
create or replace procedure Per_StateTips
is
CURSOR cur_res IS
    select restaurants.r_state, sum(orders.tip) 
    from waiters , orders, restaurants where orders.w_id=waiters.w_id and orders.r_id=restaurants.r_id group by restaurants.r_state;
    s_name  varchar(20);
    s_sum number;
BEGIN
    dbms_output.put_line('========================================================================');
    dbms_output.put_line(' -------------------------- REPORT BY MEMBER 2 -----------------------');
    dbms_output.Put_line('------------------------REPORTING TIPS BY STATE ---------------');
    OPEN cur_res;
    LOOP
    FETCH cur_res INTO s_name,s_sum;
 EXIT WHEN cur_res%NOTFOUND;
    dbms_output.Put_line('State: '||s_name ||' Tips: '|| s_sum); 
  END LOOP;
CLOSE cur_res;
    dbms_output.put_line('========================================================================');
END;
/
Set Serveroutput on;
Begin
Report_Tips();
Per_StateTips();
End;
/

/*---------------------------Member3 Reports------------------------*/
--Report for Menu Items
Set Serveroutput on;
Declare
Cursor c1 is Select cusine_types.ct_name,menu_items.mitem_name,sum(quantity) from cusine_types,menu_items,restaurant_inventory 
 where cusine_types.ct_id=menu_items.ct_id and menu_items.mi_id=restaurant_inventory.mi_id group by cusine_types.ct_name,menu_items.mitem_name;
ctname cusine_types.ct_name%type;
menuname menu_items.mitem_name%type;
quant restaurant_inventory.quantity%type;
Begin
   dbms_output.put_line('========================================================================');
   dbms_output.put_line(' -------------------------- REPORT BY MEMBER 3 -----------------------');
   dbms_output.Put_line('------------------------REPORTING MENU ITEMS ---------------');
   
   open c1;
   loop
     fetch c1 into ctname,menuname,quant;
     exit when c1%NOTFOUND;
     dbms_output.put_line('Cusine name: '||ctname||' Menu Item Name: '||menuname||' Quantity of the menu item: '||quant);
   end loop;
   Close c1;
   dbms_output.put_line('========================================================================');
End;
/

/*---------------------------Member4 Reports------------------------*/
--report display orders per menuitem per cusinetype
/
Set Serveroutput on;
Declare
Cursor c1 is select ct_name,mitem_name 
from (
select mi_id,mitem_name,ct_id,ct_name, count_of_menuitem_percusine,dense_rank() over (PARTITION BY ct_name 
order by count_of_menuitem_percusine desc) as popularity_rank 
from (
select o.mi_id,m.mitem_name,m.ct_id,ct.ct_name, count(o.o_id) as count_of_menuitem_percusine from orders o, menu_items m,cusine_types ct
where o.mi_id=m.mi_id and m.ct_id=ct.ct_id group by o.mi_id,m.mitem_name,m.ct_id,ct.ct_name ))
where popularity_rank=1;
menuitemname varchar(20);
cusinename varchar(20);
Begin
   dbms_output.put_line('========================================================================');
   dbms_output.put_line(' -------------------------- REPORT BY MEMBER 4 -----------------------');
   dbms_output.Put_line('------------------------REPORTING POPULAR MENU ITEM ORDERED FOR EACH CUISINE TYPE ---------------');
   open c1;
   loop
     fetch c1 into cusinename,menuitemname;
     exit when c1%NOTFOUND;
     dbms_output.put_line('Menuitem name: '||menuitemname||
                                         ' , cusine name: '||cusinename);
   end loop;
   Close c1;
   dbms_output.put_line('========================================================================');
End;
/

--report that shows top restaurant per state
/
Set Serveroutput on;
Declare
Cursor c1 is SELECT r_state,r_name,amount_per_rest 
FROM (
SELECT r_state,r_name,amount_per_rest, DENSE_RANK() OVER
(PARTITION BY r_state ORDER BY amount_per_rest DESC) AS TOP_RANK 
FROM (select o.r_id,r.r_name,r.r_state, sum (o.amount_paid) as amount_per_rest from orders o, restaurants r 
where o.r_id=r.r_id group by o.r_id,r.r_name,r.r_state order by amount_per_rest desc))
WHERE TOP_RANK<=3 
ORDER BY r_state,amount_per_rest DESC;
reststate varchar(20);
restname varchar(20);
amount_per_rest number;
Begin
   dbms_output.put_line('========================================================================');
   dbms_output.put_line(' -------------------------- REPORT BY MEMBER 4 -----------------------');
   dbms_output.Put_line('------------------------REPORTING TOP 3 RESTAURANTS OF EACH STATE ---------------');
   open c1;
   loop
     fetch c1 into reststate,restname,amount_per_rest;
     exit when c1%NOTFOUND;
     dbms_output.put_line('Restaurant name: '||restname||' , Restaurant state: '||reststate||', amount: '||amount_per_rest);
   end loop;
   Close c1;
   dbms_output.put_line('========================================================================');
End;
/

/*---------------------------Member5 Reports------------------------*/

/*CREATING PROCEDURE FOR HIGHEST PAYING CUSTOMERS*/

CREATE OR REPLACE PROCEDURE Highest_Paying_Customers
IS
Cursor hpc is SELECT * FROM (SELECT CUST_ID, SUM(AMOUNT_PAID) AS total_paid
FROM ORDERS GROUP BY CUST_ID ORDER BY total_paid DESC) WHERE ROWNUM <= 3; /*
SELECT STATEMENT THAT RETURNS TOP THREE CUSTOMERS
*/
name varchar(50);
BEGIN
dbms_output.put_line('========================================================================');
dbms_output.put_line(' -------------------------- REPORT BY MEMBER 5 -----------------------');
dbms_output.Put_line('------------------------Highest Paying Customers ---------------');
FOR item IN hpc
LOOP 
name := FIND_CUSTOMER_NAME(item.CUST_ID);
dbms_output.put_line('Customer Name: '||name);
EXIT WHEN hpc%NOTFOUND;
END LOOP;
EXCEPTION -- exception handling
when no_data_found then dbms_output.put_line('No data found');
when others then dbms_output.put_line('Error');
COMMIT;
END;
/
/*CREATING PROCEDURE FOR LOWEST PAYING CUSTOMERS*/
CREATE OR REPLACE PROCEDURE Lowest_Paying_Customers
IS
Cursor lpc is SELECT * FROM (SELECT CUST_ID, SUM(amount_paid) AS total_paid
FROM orders GROUP BY CUST_ID ORDER BY total_paid ) WHERE ROWNUM <= 3;
/* SELECT STATEMENT THAT RETURNS BOTTOM THREE CUSTOMERS
*/
name varchar(50);
BEGIN
dbms_output.put_line('========================================================================');
dbms_output.put_line(' -------------------------- REPORT BY MEMBER 5 -----------------------');
dbms_output.Put_line('------------------------Lowest Paying Customers ---------------');
FOR item IN lPC
LOOP 
name := FIND_CUSTOMER_NAME(item.CUST_ID);
dbms_output.put_line('Customer Name: '||name); 
EXIT WHEN lPC%NOTFOUND;
END LOOP;
EXCEPTION -- exception handling
when no_data_found then dbms_output.put_line('No data found');
when others then dbms_output.put_line('Error');
COMMIT;
END;
/
/*CALLING PROCEDURE TO PRINT HIGHEST-LOWEST CUSTOMERS*/
BEGIN
Highest_Paying_Customers;
Lowest_Paying_Customers;
END;
/

/*CREATING A PROCEDURE TO PRINT STATE OF CUSTOMER IN DESC ORDER ACCORDING TO THEIR TIPS*/
CREATE OR REPLACE PROCEDURE tips_by_state
IS
-- creating cursor to join Customers table and Orders table
Cursor T_cur is SELECT Customers.state AS cust_state, SUM(ORDERS.tip) AS total_tips
FROM ORDERS JOIN customers ON customers.customer_ID = Orders.CUST_ID GROUP BY
customers.state ORDER BY total_tips DESC;
BEGIN
dbms_output.put_line('========================================================================');
dbms_output.put_line(' -------------------------- REPORT BY MEMBER 5 -----------------------');
dbms_output.Put_line('------------------------State of Generous Customers ---------------');
FOR item IN T_cur
LOOP 
dbms_output.put_line('State: '||item.cust_state || ' ' ||'Total Tip: '|| item.total_tips); -- to print customer state and total tip
EXIT WHEN T_cur%NOTFOUND; -- loop condition
END LOOP;
EXCEPTION -- exception handling
when no_data_found then dbms_output.put_line('No data found');
when others then dbms_output.put_line('Error');
COMMIT;
END;
/
/*Report State of generous customers*/
Set Serveroutput on;
Begin
tips_by_state;
End;
/


