--1 Creation and initialization of database

Create database PETDB
Use PETDB

--2 Creation of tables

create table Pets 
(PetID int not null primary key identity(1,1),
[Name] varchar(50),
Age int,
Breed varchar(50),
[Type] varchar(50),
AvailableForAdoption bit)

create table Shelters
(ShelterID int primary key not null identity(1,1),
[Name] varchar(50),
[Location] varchar(50))

create table Donations
(DonationID int primary key not null identity(1,1),
DonorName varchar(50),
DonationType varchar(50),
DonationAmount decimal,
DonationItem varchar(50),
DonationDate datetime)

create table AdoptionEvents
(EventID int primary key not null identity(1,1),
EventName varchar(50),
EventDate datetime,
[Location] varchar(50))

create table Participants
(ParticipantID int primary key not null identity(1,1),
ParticipantName varchar(50),
ParticipantType varchar(50),
EventID int,
Foreign key (EventID) references AdoptionEvents(EventID) on delete cascade)

INSERT INTO Pets VALUES 
('Max', 3, 'Labrador Retriever', 'Dog', 1),
('Whiskers', 2, 'Persian', 'Cat', 0),
('Buddy', 5, 'Golden Retriever', 'Dog', 1),
('Fluffy', 1, 'Maine Coon', 'Cat', 1),
('Oreo', 4, 'German Shepherd', 'Dog', 0)

INSERT INTO Shelters VALUES 
('Happy Paws Shelter', 'Main Street'),
('Cozy Critters Haven', 'Elm Avenue'),
('Forever Friends Rescue', 'Oak Lane'),
('Paws and Claws Sanctuary', 'Pine Road'),
('Furry Friends Haven', 'Maple Street')

INSERT INTO Donations VALUES 
('Alice Smith', 'Cash', 1000.00, NULL, '2024-03-08 10:00:00'),
('Bob Johnson', 'Item', NULL, 'Toys', '2024-03-07 15:30:00'),
('Emily Brown', 'Cash', 500.00, NULL, '2024-03-06 09:45:00'),
('David Wilson', 'Item', NULL, 'Pet Food', '2024-03-05 11:20:00'),
('Olivia Taylor', 'Cash', 750.00, NULL, '2024-03-04 14:15:00')

INSERT INTO AdoptionEvents VALUES 
('Pet Adoption Fair', '2024-03-10 13:00:00', 'Central Park'),
('Furry Friends Meetup', '2024-03-12 11:00:00', 'Community Center'),
('Paws', '2024-03-15 10:30:00', 'Local Pet Store'),
('Paw Park', '2024-03-18 12:00:00', 'Convention Center'),
('Rescue Roundup', '2024-03-20 14:00:00', 'City Park')

INSERT INTO Participants VALUES 
('Sarah', 'Shelter', 1),
('Ann Paul', 'Adopter', 2),
('Noa Mathew', 'Shelter', 1),
('Ashefa', 'Adopter', 3),
('Ashwin', 'Adopter', 4)

--3 Keys and constraints

alter table Donations add ShelterID int foreign key (ShelterID) references Shelters(ShelterID) on delete cascade
alter table Pets add ShelterID int foreign key (ShelterID) references Shelters(ShelterID) on delete cascade
alter table AdoptionEvents add ShelterID int foreign key (ShelterID) references Shelters(ShelterID) on delete cascade
alter table Pets add AdopterID int foreign key (AdopterID) references Participants(ParticipantID)

--4
if exists (select 1 from sys.databases where name = 'PETDB')
    PRINT 'Database already exists'

/*5. Write an SQL query that retrieves a list of available pets (those marked as available for adoption) from the "Pets" table. 
Include the pet's name, age, breed, and type in the result set. 
Ensure that the query filters out pets that are not available for adoption.*/

select [Name],Age,Breed,[Type] from Pets where AvailableForAdoption=1

/* 6.Write an SQL query that retrieves the names of participants (shelters and adopters) registered for a specific adoption event.
Use a parameter to specify the event ID. Ensure that the query joins the necessary tables to retrieve the participant names and types.*/

declare @id int=1
select ParticipantName from Participants where EventID=@id

/* 7.Create a stored procedure in SQL that allows a shelter to update its information (name and location) in the "Shelters" table. 
Use parameters to pass the shelter ID and the new information. 
Ensure that the procedure performs the update and handles potential errors, such as an invalid shelter ID. */

create procedure update_shelter_details
@id int=4,@name varchar(50)='Paw Patrol',@location varchar(50)='Maple Road'
as
begin
  update Shelters set [Name]=@name,[Location]=@location where ShelterID=@id
end

execute update_shelter_details

/* 8.Write an SQL query that calculates and retrieves the total donation amount for each shelter (by shelter name) from the "Donations" table. 
The result should include the shelter name and the total donation amount. 
Ensure that the query handles cases where a shelter has received no donations.*/

select s.[Name],sum(d.DonationAmount) as Total from Shelters s full join Donations d on s.ShelterID=d.ShelterID
group by s.[Name]

/*9. Write an SQL query that retrieves the names of pets from the "Pets" table that do not have an owner (i.e., where "OwnerID" is null). 
Include the pet's name, age, breed, and type in the result set.*/

select [Name],Age,Breed,[Type] from Pets where AvailableForAdoption=0

/* 10.Write an SQL query that retrieves the total donation amount for each month and year (e.g., January 2023) from the "Donations" table.
The result should include the month-year and the corresponding total donation amount.
Ensure that the query handles cases where no donations were made in a specific month-year. */

select sum(DonationAmount) as [Sum],month(DonationDate) as month,year(DonationDate) as year from Donations 
group by grouping sets (month(DonationDate),year(DonationDate))

/*11. Retrieve a list of distinct breeds for all pets that are either aged between 1 and 3 years or older than 5 years.*/

select distinct Breed from Pets where age between 1 and 3 or age>5

/*12. Retrieve a list of pets and their respective shelters where the pets are currently available for adoption. */

select p.PetID,p.[Name],p.ShelterID,s.[Name] from Pets p join Shelters s on p.ShelterID=s.ShelterID 
where p.AvailableForAdoption=1

/*13. Find the total number of participants in events organized by shelters located in specific city. Example: City=Chennai */

select count(p.ParticipantID) as [No. of Participants] from Participants p join AdoptionEvents e on p.EventID=e.EventID 
join Shelters s on e.ShelterID=s.ShelterID
where s.[Location]='Main Street'

/*14. Retrieve a list of unique breeds for pets with ages between 1 and 5 years. */

select distinct Breed from Pets where age between 1 and 5

/*15. Find the pets that have not been adopted by selecting their information from the 'Pet' table. */

select PetID,[Name],Breed,Age from Pets where AvailableForAdoption=1

/*16. Retrieve the names of all adopted pets along with the adopter's name from the 'Adoption' and 'User' tables.*/

select p.[Name],u.[ParticipantName] from Pets p join Participants u on p.AdopterID=u.ParticipantID where p.AvailableForAdoption=0

--17. Retrieve a list of all shelters along with the count of pets currently available for adoption in each shelter.

select s.[Name],count(p.PetID) as Total from Shelters s join Pets p on s.ShelterID=p.ShelterID 
where p.AvailableForAdoption=1 group by s.[Name]

--18. Find pairs of pets from the same shelter that have the same breed.
select p2.[Name] from Pets p1 join Pets p2 on p1.ShelterID=p2.ShelterID and p1.Breed=p2.Breed 
and p1.PetID!=p2.PetID

-- 19.List all possible combinations of shelters and adoption events.

select * from Shelters cross join AdoptionEvents

--20. Determine the shelter that has the highest number of adopted pets.

select top 1 ShelterID,count(PetID) as total from Pets where AvailableForAdoption=0 group by ShelterID order by total DESC