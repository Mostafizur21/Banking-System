DROP TABLE Account_Info;
DROP TABLE Transaction;
DROP TABLE Card_Info;
DROP TABLE Customer;
DROP TABLE Employee_Info;


drop trigger TR_Customer_Age;
drop TRIGGER update_Account_Info;
drop TRIGGER TR_Employee_Age;



CREATE TABLE Employee_Info
(
	Id_Number number(5),
	Employee_Name varchar(20) NOT NULL,
	Branch varchar(20) NOT NULL,
	Status varchar(20) NOT NULL,
	Salary number(10) NOT NULL,
	Employee_Gender varchar(10) NOT NULL,
	date_of_birth date NOT NULL,
	Age number(3),
	primary key(Id_Number)		
);



CREATE TABLE Customer
(	
	Account_Number number(10),
	Customer_Name varchar(30) NOT NULL,
	Customer_Address varchar(30) NOT NULL,
	Customer_Branch varchar(20) NOT NULL,
	Customer_Gender varchar(10) NOT NULL,
	date_of_birth date NOT NULL,
	Customer_Age number(3),
	Customer_References number(5),
	PRIMARY KEY(Account_Number),
	FOREIGN KEY (Customer_References) REFERENCES Employee_Info (Id_Number) ON DELETE CASCADE
);



CREATE TABLE Account_Info
(	
	Account_Number number(10),
	Balance number(15) NOT NULL,
	Account_Branch varchar(20) NOT NULL,
	FOREIGN KEY (Account_Number) REFERENCES Customer (Account_Number) ON DELETE CASCADE		
);



CREATE TABLE Transaction
(
	Account_Number number(10),
	Transaction_Type varchar(10) NOT NULL,
	Amount number(15),
	FOREIGN KEY (Account_Number) REFERENCES Customer (Account_Number) ON DELETE CASCADE		
);



CREATE TABLE Card_Info
(
	Account_Number number(10),
	Card_Type varchar(10) NOT NULL,
	Card_number number(10),
	primary key(Card_number),
	FOREIGN KEY (Account_Number) REFERENCES Customer (Account_Number) ON DELETE CASCADE		
);





CREATE or replace TRIGGER TR_Customer_Age
BEFORE UPDATE OR INSERT ON Customer
FOR EACH ROW
BEGIN
:NEW.Customer_Age:=floor(months_between(sysdate,:NEW.date_of_birth)/12);
END TR_Customer_Age;
/



CREATE or replace TRIGGER TR_Employee_Age
BEFORE UPDATE OR INSERT ON Employee_Info
FOR EACH ROW
BEGIN
:NEW.Age:=floor(months_between(sysdate,:NEW.date_of_birth)/12);
END TR_Employee_Age;
/



CREATE or replace TRIGGER update_Account_Info
BEFORE INSERT OR UPDATE ON Transaction
FOR EACH ROW
declare
	trans_type varchar2(50);
	newamount number(10);
	balance_here number;
BEGIN
	trans_type:=:new.Transaction_type;
  newamount:=:new.amount;
  select balance into balance_here from account_info where account_Number=:new.account_number;
	
	if trans_type='Deposit' then
		update Account_Info set Balance=Balance+newamount where Account_Number=:new.Account_Number;
	elsif newamount <= (balance_here-1000) then
		update Account_Info	set Balance=Balance-newamount where Account_Number=:new.Account_Number;
	else
		RAISE_APPLICATION_ERROR(-20202, 'Balance less than withdraw amount');
	end if;
	
	
END update_Account_Info;
/


INSERT INTO Employee_Info (Id_Number,Employee_Name,Branch,Status,Salary,Employee_Gender,date_of_birth) VALUES(1,'Reza','KUET','Clerk',10000,'Male','12-Jan-93');
INSERT INTO Employee_Info (Id_Number,Employee_Name,Branch,Status,Salary,Employee_Gender,date_of_birth) VALUES(2,'Kazi','KUET','Clerk',10000,'Male','12-Dec-93');
INSERT INTO Employee_Info (Id_Number,Employee_Name,Branch,Status,Salary,Employee_Gender,date_of_birth) VALUES(3,'Bipu','Fulbari','Clerk',10000,'Male','21-Feb-93');
INSERT INTO Employee_Info (Id_Number,Employee_Name,Branch,Status,Salary,Employee_Gender,date_of_birth) VALUES(4,'Mustafiz','Doulotpur','Clerk',10000,'Male','20-Jan-93');
INSERT INTO Employee_Info (Id_Number,Employee_Name,Branch,Status,Salary,Employee_Gender,date_of_birth) VALUES(5,'Dip','KUET','Manager',20000,'Male','10-Jan-93');
INSERT INTO Employee_Info (Id_Number,Employee_Name,Branch,Status,Salary,Employee_Gender,date_of_birth) VALUES(6,'Runa','KUET','Manager',20000,'Female','12-Mar-93');
INSERT INTO Employee_Info (Id_Number,Employee_Name,Branch,Status,Salary,Employee_Gender,date_of_birth) VALUES(7,'Ishika','KUET','Manager',20000,'Female','12-Jul-93');
INSERT INTO Employee_Info (Id_Number,Employee_Name,Branch,Status,Salary,Employee_Gender,date_of_birth) VALUES(8,'Emtious','Doulotpur','Manager',20000,'Male','12-Jun-93');
INSERT INTO Employee_Info (Id_Number,Employee_Name,Branch,Status,Salary,Employee_Gender,date_of_birth) VALUES(9,'Fahad','Fulbari','Manager',20000,'Male','12-Aug-93');
INSERT INTO Employee_Info (Id_Number,Employee_Name,Branch,Status,Salary,Employee_Gender,date_of_birth) VALUES(10,'Milon','Doulotpur','Manager',20000,'Male','12-Sep-93');




INSERT INTO Customer (Customer_References,Account_Number,Customer_Name,Customer_Address,Customer_Branch,Customer_Gender,date_of_birth) VALUES(1,1234567890,'Suvashis','Lalon Shah Hall','KUET','Male','12-Jan-93');
INSERT INTO Customer (Customer_References,Account_Number,Customer_Name,Customer_Address,Customer_Branch,Customer_Gender,date_of_birth) VALUES(2,1234567891,'Sun','Lalon Shah Hall','KUET','Male','12-Dec-93');
INSERT INTO Customer (Customer_References,Account_Number,Customer_Name,Customer_Address,Customer_Branch,Customer_Gender,date_of_birth) VALUES(3,1234567892,'Raju','Lalon Shah Hall','Doulotpur','Male','21-Feb-93');
INSERT INTO Customer (Customer_References,Account_Number,Customer_Name,Customer_Address,Customer_Branch,Customer_Gender,date_of_birth) VALUES(4,1234567893,'Rashik','Sekh Mujib Hall','KUET','Male','20-Jan-93');
INSERT INTO Customer (Customer_References,Account_Number,Customer_Name,Customer_Address,Customer_Branch,Customer_Gender,date_of_birth) VALUES(5,1234567894,'Jisha','Rokeya Hall','Fulbari','Female','10-Jan-93');
INSERT INTO Customer (Customer_References,Account_Number,Customer_Name,Customer_Address,Customer_Branch,Customer_Gender,date_of_birth) VALUES(6,1234567895,'Disha','Rokeya Hall','KUET','Female','12-Mar-93');
INSERT INTO Customer (Customer_References,Account_Number,Customer_Name,Customer_Address,Customer_Branch,Customer_Gender,date_of_birth) VALUES(7,1234567896,'Suvra','Rokeya Hall','Doulotpur','Female','12-Jul-93');
INSERT INTO Customer (Customer_References,Account_Number,Customer_Name,Customer_Address,Customer_Branch,Customer_Gender,date_of_birth) VALUES(9,1234567897,'Suhail','Lalon Shah Hall','KUET','Male','12-Jun-93');
INSERT INTO Customer (Customer_References,Account_Number,Customer_Name,Customer_Address,Customer_Branch,Customer_Gender,date_of_birth) VALUES(9,1234567898,'Mafi','Amar Ekushey Hall','KUET','Male','12-Aug-93');
INSERT INTO Customer (Customer_References,Account_Number,Customer_Name,Customer_Address,Customer_Branch,Customer_Gender,date_of_birth) VALUES(9,1234567899,'Fahim','Lalon Shah Hall','Fulbari','Male','12-Sep-93');



INSERT INTO Account_Info VALUES(1234567890,10000,'KUET');
INSERT INTO Account_Info VALUES(1234567891,11000,'KUET');
INSERT INTO Account_Info VALUES(1234567892,12000,'Doulotpur');
INSERT INTO Account_Info VALUES(1234567893,13000,'KUET');
INSERT INTO Account_Info VALUES(1234567894,14000,'Fulbari');
INSERT INTO Account_Info VALUES(1234567895,15000,'KUET');
INSERT INTO Account_Info VALUES(1234567896,16000,'Doulotpur');
INSERT INTO Account_Info VALUES(1234567897,17000,'KUET');
INSERT INTO Account_Info VALUES(1234567898,18000,'KUET');
INSERT INTO Account_Info VALUES(1234567899,19000,'Fulbari');




INSERT INTO Card_Info VALUES(1234567890,'ATM',051107001);
INSERT INTO Card_Info VALUES(1234567891,'ATM',051107002);
INSERT INTO Card_Info VALUES(1234567892,'DEBIT',051107003);
INSERT INTO Card_Info VALUES(1234567893,'ATM',051107004);
INSERT INTO Card_Info VALUES(1234567894,'DEBIT',051107013);
INSERT INTO Card_Info VALUES(1234567895,'DEBIT',051107037);
INSERT INTO Card_Info VALUES(1234567896,'ATM',051107011);
INSERT INTO Card_Info VALUES(1234567897,'ATM',051107010);
INSERT INTO Card_Info VALUES(1234567898,'DEBIT',051107021);
INSERT INTO Card_Info VALUES(1234567899,'DEBIT',051107014);



INSERT INTO Transaction VALUES(1234567890,'Deposit',1000);
INSERT INTO Transaction VALUES(1234567890,'Deposit',1000);

INSERT INTO Transaction VALUES(1234567890,'Withdrawn',10000);


SELECT * FROM Customer;
SELECT * FROM Account_Info;
SELECT * FROM Card_Info;
SELECT * FROM Transaction;
SELECT * FROM Employee_Info;


SELECT Id_Number,Employee_name,Branch,Status from Employee_Info where salary >10000;

SELECT Account_number,Customer_Name,Customer_Address,Customer_Branch from Customer where Customer_Gender like 'Male';

SELECT Id_Number,Employee_name,Branch,Status,Salary from Employee_Info ORDER BY Salary;

SELECT MAX(Salary) FROM Employee_Info;

SELECT MIN(Salary) FROM Employee_Info;

SELECT SUM(Salary) FROM Employee_Info;

SELECT COUNT(Salary) FROM Employee_Info;

SELECT AVG(NVL(Salary,0)) from Employee_Info;

SELECT Account_Number,C.Customer_Name,C.Customer_Address,C.Customer_Branch,AI.Balance from Customer c natural join Account_Info AI;

SELECT Account_Number,C.Customer_Name,C.Customer_Address,C.Customer_Branch,CI.Card_number from Customer c natural join Card_Info CI;

SELECT Account_Number,Customer_Name,Customer_Address,Customer_Branch from Customer where Account_Number in (SELECT Account_Number from Account_Info where Balance>=15000);

select Id_Number,Employee_Name,Branch,Status,Salary from Employee_Info where Id_Number in ( select Customer_References from Customer where Customer_References=9);

Select Account_Number,Customer_Name,Customer_Address,Customer_Branch,Customer_References from Customer where Customer_References in ( Select Id_Number from Employee_Info where Id_Number = 9);


SELECT Customer_Name,Customer_Address from Customer where Customer_Branch='Fulbari' 
UNION 
SELECT Customer_Name,Customer_Address from Customer where
	Account_Number in (SELECT Account_Number from Account_Info where Account_Branch='KUET'); 


SELECT Customer_Name,Customer_Address from Customer where Customer_Branch='Fulbari' 
INTERSECT 
SELECT Customer_Name,Customer_Address from Customer where
	Account_Number in (SELECT Account_Number from Account_Info where Balance=14000); 




set serveroutput on

declare
	total_salary Employee_Info.Salary%type;

begin
	select sum(Salary) into total_salary from Employee_Info;

	dbms_output.put_line('The total salay should pay per month is :'||total_salary);
end;
/




set serveroutput on

declare
	total_Employee_of_KUET_Branch Employee_Info.Id_Number%type;

begin
	select COUNT(Id_Number) into total_Employee_of_KUET_Branch from Employee_Info where Branch ='KUET';

	dbms_output.put_line('Total Employee of KUET Branch is :'||total_Employee_of_KUET_Branch);
end;
/





SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE Upd_Employee_status (
id Employee_Info.Id_Number%TYPE,
jobtitle Employee_Info.Status%TYPE) IS
BEGIN 
update Employee_Info set Status=jobtitle where Id_Number=id;

	IF SQL%NOTFOUND THEN
	RAISE_APPLICATION_ERROR(-20202, 'No status updated.');
	END IF;

commit;
end Upd_Employee_status;
/
show errors;

begin
	Upd_Employee_status(1,'Manager');
	Upd_Employee_status(10,'Clerk');

end;
/




SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE Del_Employee_Info(

id Employee_Info.Id_Number%TYPE) IS
BEGIN 
DELETE FROM Employee_Info where Id_Number=id;

	IF SQL%NOTFOUND THEN
	RAISE_APPLICATION_ERROR(-20203, 'No jobs deleted.');
	END IF;

commit;
end Del_Employee_Info;
/
show errors;

BEGIN
	Del_Employee_Info(1);

END;
/





SET SERVEROUTPUT ON;

create or replace function get_annual_comp (
	id Employee_Info.Id_Number%type ) 
	return Employee_Info.Salary%type 
is
	calculate_salary Employee_Info.Salary%type;

begin
	select Salary*12 into calculate_salary from Employee_Info where Id_Number = id;
	return calculate_salary;
end;
/

show errors;


begin
	dbms_output.put_line('Monthly Salary: '||get_annual_comp(10));
end;
/




SET SERVEROUTPUT ON;

create or replace function get_Employee_Info (
	id Employee_Info.Id_Number%type)
	return varchar
is 
	jobtitle Employee_Info.Status%type;
begin
	select Status into jobtitle from Employee_Info where Id_Number=id;
	return jobtitle;
end;
/
show errors;

begin
	dbms_output.put_line('Job Title: '||get_Employee_Info(10));
end;
/

