create database pizza_app

use pizza_app

create table CUSTOMER(
						C_Id int NOT NULL,
						FName varchar(20) NOT NULL,
						MName varchar(20),
						LName varchar(20),
						Addr varchar(200) NOT NULL,
						C_Pho varchar(10) NOT NULL,
						C_mail varchar(50) NOT NULL,
						Gender char(1),
						primary key(C_Id),
						UNIQUE(C_Pho,C_mail)
)

create table EMPLOYEE(
						E_Id int NOT NULL,
						EName varchar(20) NOT NULL,
						Gender char(1) NOT NULL,
						DOB Date,
						E_Pho varchar(10) NOT NULL,
						E_mail varchar(50) NOT NULL,
						primary key(E_Id),
						UNIQUE(E_Pho,E_mail)
)


create table ORDERS(
						O_Id int NOT NULL,
						O_date Date NOT NULL,
						D_date Date NOT NULL,
						O_Price float,
						Payment varchar(30) NOT NULL,
						O_Status varchar(20) NOT NULL,
						C_Id int NOT NULL,
						E_Id int NOT NULL,
						primary key(O_Id),
						constraint fk1 foreign key(C_Id) references CUSTOMER(C_Id) ON DELETE CASCADE ON UPDATE CASCADE,
						constraint fk2 foreign key(E_Id) references EMPLOYEE(E_Id)ON DELETE CASCADE ON UPDATE CASCADE
)

create table PIZZA(
						P_Id int NOT NULL,
						PName varchar(30) NOT NULL,
						P_Image varchar(50) NOT NULL,
						Details varchar(255),
						Toppings varchar(50) NOT NULL,
						T_price float,
						Tarian varchar(20),
						primary key(P_Id),
						UNIQUE(PName,P_Image)
)

create table SIZE(
						S_Value varchar(30) NOT NULL,
						S_Details varchar(30) NOT NULL,
						S_Price float NOT NULL,
						primary key(S_Value)
)

create table CRUST(
						Cr_Name varchar(30) NOT NULL,
						Cr_Price float NOT NULL,
						primary key(Cr_Name)
)

create table CONTAIN(
						O_Id int NOT NULL,
						P_Id int NOT NULL,
						S_Value varchar(30) NOT NULL,
						Cr_Name varchar(30) NOT NULL,
						Quantity int NOT NULL,
						Q_Price float,
						primary key(O_Id,P_Id),
						constraint fk3 foreign key(O_Id) references ORDERS(O_Id) ON DELETE CASCADE ON UPDATE CASCADE,
						constraint fk4 foreign key(P_Id) references PIZZA(P_Id) ON DELETE CASCADE ON UPDATE CASCADE,
						constraint fk8 foreign key(S_Value) references SIZE(S_Value) ON DELETE CASCADE ON UPDATE CASCADE,
						constraint fk9 foreign key(Cr_Name) references CRUST(Cr_Name) ON DELETE CASCADE ON UPDATE CASCADE
)


create table MADE_OFF(
						P_Id int NOT NULL,
						S_Value varchar(30) NOT NULL,
						Cr_Name varchar(30) NOT NULL,
						TB_Price float NOT NULL,
						primary key(P_Id,S_Value,Cr_Name),
						constraint fk5 foreign key(P_Id) references PIZZA(P_Id),
						constraint fk6 foreign key(S_Value) references SIZE(S_Value) ON DELETE CASCADE ON UPDATE CASCADE,
						constraint fk7 foreign key(Cr_Name) references CRUST(Cr_Name) ON DELETE CASCADE ON UPDATE CASCADE
)

insert into CUSTOMER values(1,'Suresh','B','Rao','Udupi Karnataka','9945556631','sureshbrao@gmail.com','M')
insert into CUSTOMER values(2,'Ramesh','H','Kaur','Moga Punjab','9449678952','rameshkaur18@gmail.com','M')
insert into CUSTOMER values(3,'Glen','Henson','Fernandes','Kochi Kerala','8295778843','glenfernandes789@gmail.com','M')
insert into CUSTOMER values(4,'Mahesh','D','Shetty','Manglore Karnataka','9945662255','maheshshetty1990@gmail.com','M')
insert into CUSTOMER values(5,'Bhavana','J','Sharma','Mumbai Maharashtra','7349804369','bhavanasharma21@gmail.com','F')

insert into EMPLOYEE values(1,'Dhanish S Suvarna','M','2001-03-18','8073445263','dhanishssuvarna123@gmail.com')
insert into EMPLOYEE values(2,'Ashwin Mathew','M','2001-07-11','9986977590','ashwinmathew11@gmail.com')
insert into EMPLOYEE values(3,'Vaishnavi Hegde','F','2001-10-04','8976544351','vaishnavihegde21@gmail.com')

insert into SIZE values('Regular','Serves 1',99)
insert into SIZE values('Medium','Serves 2',199)
insert into SIZE values('Large','Serves 4',299)

insert into CRUST values('Cheese Burst',129)
insert into CRUST values('Classic Hand Tossed',149)
insert into CRUST values('Wheat Thin Crust',99)

create trigger md_of on PIZZA
AFTER INSERT
AS

DECLARE @T_Price integer
DECLARE @p integer
DECLARE @p1 integer=0
DECLARE @p2 integer=0
DECLARE @p3 integer=0
DECLARE @p4 integer=0
DECLARE @p5 integer=0
DECLARE @p6 integer=0
DECLARE @p7 integer=0
DECLARE @p8 integer=0
DECLARE @p9 integer=0

SELECT @T_Price=i.T_price FROM inserted i
SELECT @p=i.P_Id FROM inserted i

SET @p1=99+129+@T_Price
SET @p2=99+149+@T_Price
SET @p3=99+99+@T_Price
SET @p4=199+129+@T_Price
SET @p5=199+149+@T_Price
SET @p6=199+99+@T_Price
SET @p7=299+129+@T_Price
SET @p8=299+149+@T_Price
SET @p9=299+99+@T_Price

INSERT INTO MADE_OFF values (@p, 'Regular', 'Cheese Burst', @p1)
INSERT INTO MADE_OFF values(@p, 'Regular', 'Classic Hand Tossed', @p2)
INSERT INTO MADE_OFF values(@p, 'Regular', 'Wheat Thin Crust', @p3)
INSERT INTO MADE_OFF values(@p, 'Medium', 'Cheese Burst', @p4)
INSERT INTO MADE_OFF values(@p, 'Medium','Classic Hand Tossed', @p5)
INSERT INTO MADE_OFF values(@p, 'Medium', 'Wheat Thin Crust', @p6)
INSERT INTO MADE_OFF values(@p, 'Large', 'Cheese Burst', @p7)
INSERT INTO MADE_OFF values(@p, 'Large', 'Classic Hand Tossed', @p8)
INSERT INTO MADE_OFF values(@p, 'Large', 'Wheat Thin Crust', @p9)

GO


create trigger cont on CONTAIN
AFTER INSERT
AS

declare @o INT
declare @p INT
declare @size varchar(30)
declare @crust varchar(30)
declare @q INT
declare @tot FLOAT
declare @op FLOAT

SELECT @o=i.O_Id FROM inserted i
SELECT @p=i.P_Id FROM inserted i
SELECT @size=i.S_Value FROM inserted i
SELECT @crust=i.Cr_Name FROM inserted i
SELECT @q=i.Quantity FROM inserted i

SELECT @tot=TB_Price*@q
FROM MADE_OFF
WHERE P_Id=@p and S_Value=@size and Cr_Name=@crust

UPDATE CONTAIN
SET Q_Price=@tot
WHERE O_Id=@o and P_Id=@p and S_Value=@size and Cr_Name=@crust

SELECT @op=SUM(Q_Price)
FROM CONTAIN
WHERE O_Id=@o

UPDATE ORDERS
SET O_Price=@op
WHERE O_Id=@o

GO


insert into PIZZA values(701,'Farm House','Farmhouse.jpg',
							'A pizza that goes ballistic on veggies! Check out this mouth watering overload of crunchy, crisp capsicum, succulent mushrooms and fresh tomatoes',
							'capsicum, mushrooms, tomatoes',100,'Veg')

insert into PIZZA values(702,'Peppy Paneer','Peppy_Paneer.jpg',
							'Chunky paneer with crisp capsicum and spicy red pepper - quite a mouthful!',
							'capsicum, paneer',140,'Veg')

insert into PIZZA values(703,'Mexican Green Wave','Mexican_Green_Wave.jpg',
							'A pizza loaded with crunchy onions, crisp capsicum, juicy tomatoes and jalapeno with a liberal sprinkling of exotic Mexican herbs.',
							'onions, capsicum, tomatoes, jalapeno',150,'Veg')

insert into PIZZA values(704,'Indi Tandoori Paneer','IndianTandooriPaneer.jpg',
							'It is hot. It is spicy. It is oh-so-Indian. Tandoori paneer with capsicum I red paprika I mint mayo',
							'paneer, capsicum',120,'Veg')

insert into PIZZA values(705,'Chicken Dominator','Dominator.jpg',
							'Treat your taste buds with Double Pepper Barbecue Chicken, Peri-Peri Chicken, Chicken Tikka & Grilled Chicken Rashers',
							'Barbecue Chicken, Peri-Peri Chicken, Chicken Tikka',220,'NonVeg')

insert into PIZZA values(706,'PEPPER BARBECUE & ONION','Pepper_Barbeque.jpg',
							'Pepper Barbecue Chicken and Onions',
							'Barbecue Chicken,Onions',180,'NonVeg')

insert into PIZZA values(707,'Indi Chicken Tikka','IndianChickenTikka.jpg',
							'The wholesome flavour of tandoori masala with Chicken tikka ,onion ,red paprika & mint mayo',
							'Chicken Tikka,onion',200,'NonVeg')

insert into ORDERS values(101,'2021-11-12','2021-11-13',NULL,'Mobile Banking','confirmed',3,2)
insert into ORDERS values(102,'2021-11-12','2021-11-13',NULL,'Debit Card','confirmed',4,3)
insert into ORDERS values(103,'2021-11-13','2021-11-14',NULL,'Mobile Banking','confirmed',1,2)
insert into ORDERS values(104,'2021-11-14','2021-11-15',NULL,'COD','cancel',5,1)
insert into ORDERS values(105,'2021-11-15','2021-11-16',NULL,'Credit Card','confirmed',2,1)
insert into ORDERS values(106,'2021-11-15','2021-11-16',NULL,'COD','pending',5,1)

insert into CONTAIN values(101,701,'Regular','Wheat Thin Crust',2,NULL)
insert into CONTAIN values(101,704,'Medium','Classic Hand Tossed',1,NULL)
insert into CONTAIN values(102,701,'Regular','Wheat Thin Crust',2,NULL)
insert into CONTAIN values(102,704,'Regular','Classic Hand Tossed',2,NULL)
insert into CONTAIN values(103,707,'Large','Classic Hand Tossed',1,NULL)
insert into CONTAIN values(104,705,'Medium','Cheese Burst',3,NULL)
insert into CONTAIN values(105,703,'Medium','Cheese Burst',2,NULL)
insert into CONTAIN values(105,705,'Medium','Wheat Thin Crust',1,NULL)
insert into CONTAIN values(105,701,'Regular','Classic Hand Tossed',3,NULL)
insert into CONTAIN values(106,703,'Large','Wheat Thin Crust',1,NULL)
insert into CONTAIN values(106,705,'Large','Wheat Thin Crust',1,NULL)

select * from CUSTOMER
select * from EMPLOYEE
select * from SIZE
select * from CRUST
select * from PIZZA
select * from MADE_OFF
select * from CONTAIN
select * from ORDERS

/*1. Retrieve the Pizza details ordered by customer with FName 'Bhavana'*/

SELECT O.O_Id, P.PName, CN.S_Value, CN.Cr_Name, CN.Quantity, CN.Q_Price
FROM CUSTOMER as C, ORDERS as O, PIZZA as P, CONTAIN as CN
WHERE C.C_Id=O.C_Id and O.O_Id=CN.O_Id and CN.P_Id=P.P_Id and C.FName='Bhavana'


/*2. Retrieve the Order number, Customer Name, C phoneNo, C Email, Delivery Adds, Delivery Date, Order Price, Payment method
of all the oders that need to be delivered By Employee 'Dhanish S Suvarna' only if the Order status is 'confirmed'*/

SELECT O.O_Id, C.FName, C.C_Pho, C.C_mail, C.Addr, O.D_date, O.O_Price, O.Payment
FROM ORDERS as O, EMPLOYEE as E, CUSTOMER as C
WHERE C.C_Id=O.C_Id and O.E_Id=E.E_Id and E.EName='Dhanish S Suvarna' and O.O_Status='confirmed'


/*3. Retrieve the number of people Who Ordered 'Chicken Dominator' Pizza*/

SELECT COUNT(DISTINCT C_Id) as No_Of_People_Ordered_ChickenDominator
FROM ORDERS
WHERE O_Id IN (
			SELECT C.O_Id
			FROM PIZZA as P, CONTAIN as C
			WHERE P.P_Id=C.P_Id and P.PName='Chicken Dominator'
			)


/*4. Retrieve all the Customer who have Ordered Pizzas of Price More Than 1200 and give them 20% Off due to Christmas New year PizzaSale*/

SELECT C.FName, C.MName, C.LName, O.O_Id, O.O_Price as Normal_Price, O.O_Price*0.8 as Discounted_Price
FROM ORDERS as O, CUSTOMER as C
WHERE O.C_Id=C.C_Id and O_Price>1200