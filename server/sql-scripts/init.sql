-- drop relational tables first
drop table PARTICIPATESIN;
drop table LOCATEDIN;
drop table HASSPONSOR;
drop table GIVENBY;
drop table WINSAWARD;
drop table REFEREES;

-- drop entities (order may matter for PK/FKs)
drop table COACH;
drop table REFEREE;
drop table AWARDS;
drop table SPONSOR;
drop table INJURY;
drop table STATISTICS;
drop table ATHLETE;
drop table TEAM;
drop table VENUE;
drop table GAME;

-- drop DETAILS last
drop table POSITIONDETAILS;

/* Entities */

CREATE TABLE Venue(
	venue_address varchar(100),
	venue_name varchar(100) UNIQUE,
	capacity int,
	PRIMARY KEY(venue_address)
);

CREATE TABLE Team(
	team_name varchar(100),
	team_owner varchar(100),
	home_venue_address varchar(100) NOT NULL,
	PRIMARY KEY(team_name),
	FOREIGN KEY(home_venue_address) REFERENCES Venue(venue_address)
--         ON DELETE NO ACTION // not required
		/* ON UPDATE NO ACTION not supported will impl another way */
);

CREATE TABLE PositionDetails(
	jersey_num int,
	position varchar(100),
	PRIMARY KEY(jersey_num)
);

CREATE TABLE Athlete(
	person_id int,
	name varchar(100),
	birthdate date,
	height float,
	weight float,
	phone_number int8 UNIQUE,
	email varchar(100) UNIQUE,
	address varchar(100),
	date_started date,
    jersey_num int,
    current_team varchar(100) NOT NULL,
	salary int,
	PRIMARY KEY(person_id),
	FOREIGN KEY(current_team) REFERENCES Team(team_name),
--         ON DELETE NO ACTION, /* must point team to another team first*/ no required
		/* ON UPDATE CASCADE, not supported will impl another way */
	FOREIGN KEY(jersey_num) REFERENCES PositionDetails(jersey_num)
		ON DELETE CASCADE
		/* ON UPDATE CASCADE, not supported will impl another way */
);

CREATE TABLE Coach(
	person_id int,
	name varchar(100),
	birthdate date,
	height float,
	weight float,
	phone_number int8 UNIQUE,
	email varchar(100) UNIQUE,
	address varchar(100),
	date_started date,
    current_team varchar(100) NOT NULL,
    specialization varchar(100),
    PRIMARY KEY(person_id),
	FOREIGN KEY(current_team) REFERENCES Team(team_name)
--         ON DELETE NO ACTION /* must point team to another team first*/ // not required
		/* ON UPDATE CASCADE not supported will impl another way */
);

CREATE TABLE Referee(
	person_id int,
	name varchar(100),
	birthdate date,
	height float,
	weight float,
	phone_number int8 UNIQUE,
	email varchar(100) UNIQUE,
	address varchar(100),
	date_started date,
	certification_level int,
    PRIMARY KEY(person_id)
);

CREATE TABLE Game(
	game_id int,
	home varchar(100),
	away varchar(100),
	game_date date,
	PRIMARY KEY(game_id)
);

CREATE TABLE Statistics(
	stats_id int,
	person_id int NOT NULL,
	game_id int NOT NULL,
	goals int,
	shots_taken int,
	passes_attempted int,
	turnovers int,
	possession_percent float,
	PRIMARY KEY(stats_id),
    FOREIGN KEY (person_id) REFERENCES Athlete(person_id)
		ON DELETE CASCADE,
		/* ON UPDATE CASCADE not supported will impl another way */
	FOREIGN KEY (game_id) REFERENCES Game(game_id)
		ON DELETE CASCADE
		/* ON UPDATE CASCADE not supported will impl another way */
);

CREATE TABLE Awards(
	award_id int,
	year int,
	award_name varchar(50),
	PRIMARY KEY(award_id)
);

CREATE TABLE Sponsor(
	sponsor_name varchar(100),
	sponsor_email varchar(100) UNIQUE,
	money_granted int,
	PRIMARY KEY(sponsor_name)
);

CREATE TABLE Injury(
	injury_type varchar(100),
	injury_date date,
	injury_status int, /*0 is false, other is true*/
	person_id int,
	PRIMARY KEY(person_id, injury_type, injury_date),
	FOREIGN KEY(person_id) REFERENCES Athlete(person_id)
		ON DELETE CASCADE
		/* ON UPDATE CASCADE not supported will impl another way */
);

/* Relationship Tables */

CREATE TABLE ParticipatesIn(
	game_id int,
	team_1 varchar(100),
	team_2 varchar(100),
	PRIMARY KEY(game_id),
    FOREIGN KEY(team_1) REFERENCES Team(team_name)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE not supported will impl another way */
    FOREIGN KEY(team_2) REFERENCES Team(team_name)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE not supported will impl another way */
    FOREIGN KEY(game_id) REFERENCES Game(game_id)
        ON DELETE CASCADE
        /* ON UPDATE CASCADE not supported will impl another way */
);

CREATE TABLE LocatedIn(
	game_id int,
	venue_address varchar(100),
	PRIMARY KEY(game_id, venue_address),
    FOREIGN KEY(game_id) REFERENCES Game(game_id)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE not supported will impl another way */
    FOREIGN KEY(venue_address) REFERENCES Venue(venue_address)
        ON DELETE CASCADE
        /* ON UPDATE CASCADE not supported will impl another way */
);

CREATE TABLE HasSponsor(
	team_name varchar(100),
	sponsor_name varchar(100),
	PRIMARY KEY(team_name, sponsor_name),
    FOREIGN KEY(team_name) REFERENCES Team(team_name)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE not supported will impl another way */
    FOREIGN KEY(sponsor_name) REFERENCES Sponsor(sponsor_name)
        ON DELETE CASCADE
        /* ON UPDATE CASCADE not supported will impl another way */
);

CREATE TABLE GivenBy(
	sponsor_name varchar(100),
	award_id int,
	PRIMARY KEY(sponsor_name, award_id),
    FOREIGN KEY(sponsor_name) REFERENCES Sponsor(sponsor_name)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE not supported will impl another way */
    FOREIGN KEY(award_id) REFERENCES Awards(award_id)
        ON DELETE CASCADE
        /* ON UPDATE CASCADE not supported will impl another way */
);

CREATE TABLE WinsAward(
	award_id int,
	person_id int,
	team_name varchar(100),
	PRIMARY KEY(award_id),
    -- 	UNIQUE(person_id, team_name),
    FOREIGN KEY(award_id) REFERENCES Awards(award_id)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE not supported will impl another way */
    FOREIGN KEY(person_id) REFERENCES Athlete(person_id)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE not supported will impl another way */
    FOREIGN KEY(team_name) REFERENCES Team(team_name)
        ON DELETE CASCADE
        /* ON UPDATE CASCADE not supported will impl another way */
);

CREATE TABLE Referees(
    person_id int,
    game_id int,
    PRIMARY KEY(person_id, game_id),
    FOREIGN KEY(person_id) REFERENCES Referee(person_id)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE not supported will impl another way */
    FOREIGN KEY(game_id) REFERENCES Game(game_id)
        ON DELETE CASCADE
        /* ON UPDATE CASCADE not supported will impl another way */
);
/* INSERTS */

INSERT INTO PositionDetails (jersey_num, position) VALUES
    (1, 'Goalkeeper'),
    (2, 'Right Back'),
    (3, 'Left Back'),
    (4, 'Sweeper'),
    (5, 'Central Back'),
    (6, 'Defensive Midfielder'),
    (7, 'Winger'),
    (8, 'Central Midfielder'),
    (9, 'Striker'),
    (10, 'Central Attacking Midfielder'),
    (11, 'Outside Midfielder');

INSERT INTO Venue (venue_address, venue_name, capacity) VALUES
    ('5123 Main Street, Vancouver', 'Benz Stadium', 10000),
    ('5456 Oak Avenue, Richmond', 'Mountain View Stadium', 20000),
    ('5789 Elm Road, Burnaby', 'Evergreen Arena', 15000),
    ('5101 Maple Lane, Surrey', 'Harbor View Stadium', 5000),
    ('5234 Pine Street, Coquitlam', 'Sea View Arena', 34500),
    ('1923 River Road, Langley', 'Waterways Stadium', 17000);

INSERT INTO Team (team_name, team_owner, home_venue_address) VALUES
    ('Vancouver Vipers', 'John Wong', '5123 Main Street, Vancouver'),
    ('Richmond Thunder', 'Emily Johnson', '5456 Oak Avenue, Richmond'),
    ('Burnaby Warriors', 'Michael Brown', '5789 Elm Road, Burnaby'),
    ('Surrey Titans', 'Sarah Lee', '5101 Maple Lane, Surrey'),
    ('Coquitlam Sharks', 'Robert Davis', '5234 Pine Street, Coquitlam'),
    ('Langley Bears', 'Chris Huk', '1923 River Road, Langley');

INSERT INTO Athlete (person_id, name, birthdate, height, weight, phone_number, email, address, date_started, jersey_num, current_team, salary) VALUES
    -- Vancouver Vipers
    (1, 'John Doe', '1989-12-05', 178, 77, 6041234567, 'john.doe@soccer.com', '123 Main St, Vancouver', '2006-11-30', 1, 'Vancouver Vipers', 60000),
    (2, 'Jane Smith', '1993-04-30', 170, 68, 8778980912, 'jane.smith@soccer.com', '123 Oak St, Vancouver', '2014-09-07', 2, 'Vancouver Vipers', 70000),
    (3, 'Mike Johnson', '1980-06-14', 188, 91, 6041820192, 'mike.johnson@soccer.com', '461 Fir St, Vancouver', '2000-04-18', 3, 'Vancouver Vipers', 120000),
    (4, 'Michelle Zhu', '1987-02-09', 178, 82, 7781920391, 'michell.zhu@soccer.com', '192 Oats Rd, Vancouver', '2010-10-10', 4, 'Vancouver Vipers', 100000),
    (5, 'Michael Dune', '1993-09-12', 203, 132, 6045129102, 'michael.dune@soccer.com', '101 Chem Drive, Vancouver', '2011-03-18', 5, 'Vancouver Vipers', 500000),
    (6, 'Serena Storm', '1985-11-20', 170, 56, 7889129301, 'serena.storm@soccer.com', '783 Balsam St, Vancouver', '2005-02-05', 6, 'Vancouver Vipers', 190000),
    (7, 'Daniel Kee', '1991-07-06', 178, 76, 6045919203, 'daniel.kee@soccer.com', '912 Mark Lane, Vancouver', '2018-08-14', 7, 'Vancouver Vipers', 1200000),
    (8, 'Emily Carr', '1988-03-19', 170, 86, 8778902183, 'emily.carr@soccer.com', '281 Fox St, Vancouver', '2002-12-22', 8, 'Vancouver Vipers', 80000),
    (9, 'Jason Bills', '1996-05-02', 130, 39, 7781029301, 'jason.bills@soccer.com', '292 Blue Drive, Vancouver', '2015-12-30', 9, 'Vancouver Vipers', 180000),
    (10, 'Rachel Jordan', '1982-07-16', 175, 67, 6045881923, 'rachel.jordan@soccer.com', '778 Phone St, Vancouver', '2004-06-03', 10, 'Vancouver Vipers', 175000),
    (11, 'Rick Tord', '1998-11-25', 183, 78, 7786758192, 'rick.tord@soccer.com', '182 Dubious Lane, Vancouver', '2009-07-12', 11, 'Vancouver Vipers', 250000),
    -- Richmond Thunder
    (12, 'Billy Bob', '1981-01-03', 198, 127, 6045557892, 'billy.bob@socer.com', '872 Fire Lane, Vancouver', '2007-09-27', 1, 'Richmond Thunder', 280000),
    (13, 'Danielle Chu', '1994-06-28', 163, 56, 7789901203, 'danielle.chu@soccer.com', '897 Key St, Vancouver', '2013-04-19', 2, 'Richmond Thunder', 3400000),
    (14, 'Darren Sam', '1989-08-11', 185, 84, 6045589102, 'darren.sam@soccer.com', '291 Bin Rd, Vancouver', '2001-08-09', 3, 'Richmond Thunder', 120000),
    (15, 'Cynthia Game', '1995-12-14', 168, 59, 6049012930, 'cynthia.game@soccer.com', '448 Elm Rd, Vancouver', '2016-01-07', 4, 'Richmond Thunder', 190000),
    (16, 'Mark Nguyen', '1984-02-28', 185, 82, 7781920192, 'mark.nguyen@soccer.com', '909 Flower Dr, Vancouver', '2003-09-14', 5, 'Richmond Thunder', 1700000),
    (17, 'Jillian Prim', '1990-04-10', 173, 51, 6047781029, 'jillian.prim@soccer.com', '180 Priority St, Vancouver', '2019-02-21', 6, 'Richmond Thunder', 2000000),
    (18, 'Simon Jones', '1986-10-21', 216, 44, 7786521829, 'simon.jones@soccer.com', '728 Current Dr, Vancouver', '2006-07-16', 7, 'Richmond Thunder', 70000),
    (19, 'Adora Park', '1992-02-03', 157, 45, 6045781029, 'adora.park@soccer.com', '182 Princeton Way, Vancouver', '2009-05-14', 8, 'Richmond Thunder', 900000),
    (20, 'Matt Dracos', '1983-08-26', 198, 94, 7785648189, 'matt.dracos@soccer.com', '994 Slogan Dr, Vancouver', '2017-08-25', 9, 'Richmond Thunder', 90000),
    (21, 'Heidi Gram', '1997-01-09', 173, 36, 6048891203, 'heidi.gram@soccer.com', '444 Dragon Rd, Vancouver', '2006-04-30', 10, 'Richmond Thunder', 170000),
    (22, 'Jeremy Lim', '1980-12-23', 170, 67, 7786541092, 'jeremy.lim@soccer.com', '182 Basket Way, Vancouver', '2014-11-07', 11, 'Richmond Thunder', 240000),
    -- Burnaby Warriors
    (23, 'Parker Fin', '1986-04-17', 168, 53, 6057810293, 'parker.fin@soccer.com', '982 Bingo St, Vancouver', '2000-11-18', 1, 'Burnaby Warriors', 170000),
    (24, 'Lauren Shim', '1992-09-15', 163, 40, 8778718211, 'lauren.shim@soccer.com', '821 Heart Way, Vancouver', '2008-10-01', 2, 'Burnaby Warriors', 256000),
    (25, 'Markus Duff', '1988-11-23', 203, 86, 6045579012, 'markus.duff@soccer.com', '192 Rock Lane, Vancouver', '2012-06-12', 3, 'Burnaby Warriors', 400000),
    (26, 'Fiora Moon', '1995-07-09', 170, 64, 7786541297, 'fiora.moon@soccer.com', '872 Piano Dr, Vancouver', '2005-08-23', 4, 'Burnaby Warriors', 187000),
    (27, 'Wolf Sun', '1982-03-26', 107, 61, 6045709908, 'wolf.sun@soccer.com', '126 Error Rd, Vancouver', '2017-04-05', 5, 'Burnaby Warriors', 80000),
    (28, 'MJ Heart', '1998-06-12', 168, 45, 7781112345, 'mj.heart@soccer.com', '988 Nest Way, Vancouver', '2003-02-14', 6, 'Burnaby Warriors', 190000),
    (29, 'Jordan Tan', '1987-08-28', 229, 70, 6048990765, 'jordan.tan@soccer.com', '444 Bike Lane, Vancouver', '2014-10-30', 7, 'Burnaby Warriors', 761000),
    (30, 'Ellie Howling', '1990-02-15', 115, 40, 7789912232, 'ellie.howling@soccer.com', '291 Desk Rd, Vancouver', '2009-03-01', 8, 'Burnaby Warriors', 19000),
    (31, 'Darius Wong', '1986-12-21', 216, 77, 7786098801, 'darius.wong@soccer.com', '321 Turn St, Vancouver', '2006-09-20', 9, 'Burnaby Warriors', 172000),
    (32, 'Delilah Kim', '1994-05-06', 168, 36, 6045578901, 'delilah.kim@soccer.com', '124 Function Rd, Vancouver', '2010-12-10', 10, 'Burnaby Warriors', 900000),
    (33, 'Francis David', '1983-07-01', 201, 101, 7786543389, 'francis.david@soccer.com', '127 Bacon St, Vancouver', '2001-01-15', 11, 'Burnaby Warriors', 876000),
    -- Surrey Titans
    (34, 'Adam Desmond', '1997-11-13', 178, 65, 6045578896, 'adam.desmond@soccer.com', '778 Philosophy Lane, Vancouver', '2015-07-17', 1, 'Surrey Titans', 178000),
    (35, 'Brittany Peterson', '1981-01-27', 137, 59, 7786129993, 'brittany.peterson@soccer.com', '560 Canuck St, Vancouver', '2004-11-08', 2, 'Surrey Titans', 200000),
    (36, 'Ryan Son', '1999-03-10', 231, 84, 6046678901, 'ryan.son@soccer.com', '329 Jensen Way, Vancouver', '2018-06-25', 3, 'Surrey Titans', 678000),
    (37, 'Georgia Cheng', '1984-07-21', 180, 59, 8778019812, 'georgia.cheng@soccer.com', '008 Armour Dr, Vancouver', '2007-03-03', 4, 'Surrey Titans', 192000),
    (38, 'Jared Sinew', '1991-04-03', 196, 139, 6040580095, 'jared.sinew@soccer.com', '776 Corpus Lane, Vancouver', '2012-08-14', 5, 'Surrey Titans', 70800),
    (39, 'Ashley Shu', '1996-09-17', 168, 54, 7783220119, 'ashley.shu@soccer.com', '887 Compass Rd, Vancouver', '2002-05-20', 6, 'Surrey Titans', 1000000),
    (40, 'Lucas Man', '1989-12-30', 203, 38, 6048571002, 'lucas.man@soccer.com', '812 Lead Dr, Vancouver', '2016-04-09', 7, 'Surrey Titans', 240000),
    (41, 'Sherry Van', '1993-05-15', 188, 50, 7780091435, 'sherry.van@soccer.com', '441 Floor Rd, Vancouver', '2008-01-12', 8, 'Surrey Titans', 700000),
    (42, 'Vincent Lu', '1980-07-29', 178, 43, 6044478990, 'vincent.lu@soccer.com', '128 Douglas Dr, Vancouver', '2011-09-27', 9, 'Surrey Titans', 860000),
    (43, 'Mary Jane', '1987-02-27', 180, 49, 7787563299, 'mary.jane@soccer.com', '888 Thunder Rd, Vancouver', '2005-06-22', 10, 'Surrey Titans', 978000),
    (44, 'Jason Billy', '1993-09-20', 180, 57, 6049890071, 'jason.billy@soccer.com', '449 Apple St, Vancouver', '2017-01-05', 11, 'Surrey Titans', 170000),
    -- Coquitlam Sharks
    (45, 'Harry Ford', '1985-11-18', 188, 71, 7786543090, 'harry.ford@soccer.com', '192 Falcon Dr, Vancouver', '2003-12-14', 1, 'Coquitlam Sharks', 16700000),
    (46, 'Ruth North', '1991-07-12', 137, 149, 6045589012, 'ruth,north@soccer.com', '514 Fox Way, Vancouver', '2014-07-30', 2, 'Coquitlam Sharks', 40000),
    (47, 'Luke Sky', '1988-03-25', 203, 241, 7786543998, 'luke.sky@soccer.com', '123 Force Lane, Vancouver', '2009-05-01', 3, 'Coquitlam Sharks', 990000),
    (48, 'Noon Locomotion', '1996-05-18', 137, 68, 7780091002, 'noon.locomotion@soccer.com', '443 Train Rd, Vancouver', '2006-10-20', 4, 'Coquitlam Sharks', 54600),
    (49, 'Parker Jones', '1982-07-26', 178, 190, 6041123009, 'parker.jones@soccer.com', '652 Stone Lane, Vancouver', '2011-01-10', 5, 'Coquitlam Sharks', 981000),
    (50, 'Jamie Flame', '1998-11-27', 180, 167, 7784439012, 'jamie.flame@soccer.com', '332 Yang St, Vancouver', '2001-02-15', 6, 'Coquitlam Sharks', 728000),
    (51, 'Dennis Honda', '1981-01-09', 195, 136, 6045589900, 'dennis.honda@soccer.com', '126 Arch Way, Vancouver', '2015-08-17', 7, 'Coquitlam Sharks', 971000),
    (52, 'Karina Allen', '1994-07-27', 178, 94, 7786519822, 'karina.allen@soccer.com', '349 Synchronization Lane, Vancouver', '2004-12-08', 8, 'Coquitlam Sharks', 144000),
    (53, 'John Under', '1989-09-15', 146, 119, 6045567124, 'john.under@soccer.com', '448 Dream Rd, Vancouver', '2018-07-25', 9, 'Coquitlam Sharks', 322900),
    (54, 'Alicia Yoo', '1995-11-18', 168, 120, 7781129945, 'alicia.yoo@soccer.com', '229 Ocean Rd, Vancouver', '2007-04-03', 10, 'Coquitlam Sharks', 890000),
    (55, 'Cameron Jonas', '1984-03-30', 185, 146, 7781009020, 'cameron.jones@soccer.com', '776 Sting St, Vancouver', '2012-09-14', 11, 'Coquitlam Sharks', 750000),
    -- Langley Bears
    (56, 'James Fort', '1990-07-17', 210, 156, 6049125567, 'james.fort@soccer.com', '554 Knob Rd, Vancouver', '2002-06-20', 1, 'Langley Bears', 150000),
    (57, 'Ivana Lee', '1986-09-02', 137, 144, 7786990001, 'ivana.lee@soccer.com', '447 Jelly Way, Vancouver', '2016-05-09', 2, 'Langley Bears', 800000),
    (58, 'Jim Gear', '1992-02-04', 180, 239, 6045578990, 'jim.gear@soccer.com', '761 Willow Drive, Vancouver', '2008-02-12', 3, 'Langley Bears', 60000),
    (59, 'Sophia Turn', '1983-08-23', 163, 129, 8786654888, 'sophia.turn@soccer.com', '551 Sunflower Way, Vancouver', '2011-10-27', 4, 'Langley Bears', 765000),
    (60, 'Andrew Lim', '1997-01-19', 196, 178, 6049980073, 'andrew.lim@soccer.com', '060 Focus St, Vancouver', '2005-07-22', 5, 'Langley Bears', 236000),
    (61, 'Evelyn Crow', '1980-12-03', 137, 144, 7786527778, 'evelyn.crow@soccer.com', '445 Gold Lane, Vancouver', '2017-02-05', 6, 'Langley Bears', 743000),
    (62, 'Tim Shore', '1986-04-15', 203, 345, 6045590087, 'tim.shore@soccer.com', '112 Plane Rd, Vancouver', '2004-01-14', 7, 'Langley Bears', 76500),
    (63, 'Rebecca Salvador', '1992-09-30', 157, 100, 6048891112, 'rebecca.salvador@soccer.com', '887 Leaf Way, Vancouver', '2015-07-30', 8, 'Langley Bears', 106700),
    (64, 'Jean Fargo', '1988-11-07', 168, 178,7782234778, 'jean.fargo@soccer.com', '119 Boar Dr, Vancouver', '2010-05-01', 9, 'Langley Bears', 178000),
    (65, 'Selena An', '1995-07-12', 144, 110, 6045009122, 'selena.an@soccer.com', '132 Stores Way, Vancouver', '2006-11-20', 10, 'Langley Bears', 1780000),
    (66, 'Ahmed Tom', '1982-03-06', 188, 143, 7786223489, 'ahmed.tom@soccer.com', '443 Manager St. Vancouver', '2011-02-10', 11, 'Langley Bears', 166500),
    -- Injured Athletes
    (67, 'Simon Fraser', '1988-07-12', 121, 106, 6049175567, 'simon.fraser@soccer.com', '888 Machine Rd, Vancouver', '2012-06-23', 1, 'Langley Bears', 170000),
    (68, 'Marie So', '2000-09-02', 181, 145, 7786990101, 'marie.so@soccer.com', '409 Pillar Lane, Vancouver', '2016-08-08', 2, 'Langley Bears', 600000),
    (69, 'Jayden Jay', '1998-12-04', 209, 59, 6045579990, 'jayden.jay@soccer.com', '561 Heather Drive, Vancouver', '2008-07-12', 3, 'Langley Bears', 60500),
    (70, 'Jordan Barber', '1963-08-24', 156, 89, 8778625488, 'jordan.barber@soccer.com', '760 Daisy Way, Vancouver', '2001-10-27', 4, 'Langley Bears', 795000),
    (71, 'Phil Robins', '1998-05-29', 197, 190, 6049980077, 'phil.robins@soccer.com', '440 Rogue Way, Vancouver', '2021-07-20', 5, 'Langley Bears', 341000),
    (72, 'Esther Swan', '1971-02-28', 147, 146, 7786527078, 'esther.swan@soccer.com', '822 Silver St, Vancouver', '2017-08-05', 6, 'Langley Bears', 980000);


INSERT INTO Injury (injury_type, injury_date, injury_status, person_id) VALUES
    ('Arm', '2022-04-20', 0, 67),
    ('ACL', '2023-10-15', 1, 68),
    ('Leg', '2022-09-21', 0, 69),
    ('Back', '2021-05-07', 0, 70),
    ('Head', '2021-10-30', 1, 71),
    ('Finger', '2022-01-22', 0, 72);

INSERT INTO Game (game_id, home, away, game_date) VALUES
    (1, 'Vancouver Vipers', 'Richmond Thunder', '2022-01-28'),
    (2, 'Burnaby Warriors', 'Surrey Titans', '2022-02-01'),
    (3, 'Coquitlam Sharks', 'Langley Bears', '2022-06-02'),
    (4, 'Vancouver Vipers', 'Burnaby Warriors', '2022-08-15'),
    (5, 'Richmond Thunder', 'Coquitlam Sharks', '2022-10-01'),
    (6, 'Surrey Titans', 'Langley Bears', '2022-11-27'),
    (7, 'Vancouver Vipers', 'Surrey Titans', '2022-12-18'),
    (8, 'Burnaby Warriors', 'Coquitlam Sharks', '2023-02-05'),
    (9, 'Richmond Thunder', 'Langley Bears', '2023-02-17'),
    (10, 'Vancouver Vipers', 'Coquitlam Sharks', '2023-03-13'),
    (11, 'Burnaby Warriors', 'Langley Bears', '2023-05-24'),
    (12, 'Richmond Thunder', 'Surrey Titans', '2023-08-16'),
    (13, 'Langley Bears', 'Vancouver Vipers', '2023-09-01'),
    (14, 'Richmond Thunder', 'Burnaby Warriors', '2023-09-08'),
    (15, 'Coquitlam Sharks', 'Surrey Titans', '2023-11-19');

INSERT INTO Sponsor (sponsor_name, sponsor_email, money_granted) VALUES
    ('Coca-Cola', 'sponsor@coca-colacompany.com', 50000),
    ('Adidas', 'sponsor@adidas.com', 40000),
    ('Visa', 'sponsor@visa.ca', 60000),
    ('UBC', 'sponsor@ubc.ca', 2000),
    ('Hyundai', 'sponsor@hyundaimotorgroup.com', 80000);

INSERT INTO Awards (award_id, year, award_name) VALUES
    (1, 2023, 'Offensive Player of the Year'),
    (2, 2023, 'Defensive Player of the Year'),
    (3, 2022, 'Offensive Player of the Year'),
    (4, 2022, 'Team of the Year'),
    (5, 2023, 'Team of the Year'),
    (6, 2021, 'Offensive Player of the Year');

INSERT INTO Statistics (stats_id, person_id, game_id, goals, shots_taken, passes_attempted, turnovers, possession_percent) VALUES
    (1, 1, 1, 0, 9, 68, 9, 4.03),
    (2, 1, 4, 0, 8, 37, 11, 2.87),
    (3, 1, 7, 0, 13, 42, 13, 0.94),
    (4, 1, 10, 0, 9, 73, 8, 8.39),
    (5, 1, 13, 0, 5, 43, 18, 3.31),
    (6, 2, 1, 1, 4, 38, 11, 4.43),
    (7, 2, 4, 0, 8, 27, 14, 2.22),
    (8, 2, 7, 0, 7, 55, 19, 6.13),
    (9, 2, 10, 0, 9, 22, 20, 0.61),
    (10, 2, 13, 0, 3, 79, 8, 1.75),
    (11, 3, 1, 0, 7, 49, 0, 7.67),
    (12, 3, 4, 0, 14, 40, 18, 4.44),
    (13, 3, 7, 0, 7, 57, 12, 2.64),
    (14, 3, 10, 0, 13, 75, 15, 1.21),
    (15, 3, 13, 0, 3, 66, 9, 5.24),
    (16, 4, 1, 0, 11, 31, 11, 0.95),
    (17, 4, 4, 0, 13, 75, 16, 3.05),
    (18, 4, 7, 2, 14, 47, 2, 1.02),
    (19, 4, 10, 0, 16, 26, 15, 3.55),
    (20, 4, 13, 0, 9, 33, 17, 6.99),
    (21, 5, 1, 0, 9, 47, 6, 7.75),
    (22, 5, 4, 0, 13, 78, 14, 4.99),
    (23, 5, 7, 0, 16, 50, 15, 6.64),
    (24, 5, 10, 0, 10, 81, 13, 5.62),
    (25, 5, 13, 0, 14, 35, 20, 3.86),
    (26, 6, 1, 0, 12, 71, 6, 0.95),
    (27, 6, 4, 0, 15, 75, 21, 4.81),
    (28, 6, 7, 0, 9, 10, 3, 2.64),
    (29, 6, 10, 0, 13, 36, 15, 3.03),
    (30, 6, 13, 0, 10, 70, 19, 7.64),
    (31, 7, 1, 0, 13, 4, 1, 2.77),
    (32, 7, 4, 0, 12, 79, 19, 3.97),
    (33, 7, 7, 0, 5, 29, 5, 3.66),
    (34, 7, 10, 0, 5, 16, 6, 6.23),
    (35, 7, 13, 2, 3, 66, 4, 9.11),
    (36, 8, 1, 1, 15, 53, 0, 5.78),
    (37, 8, 4, 0, 16, 44, 13, 2.5),
    (38, 8, 7, 0, 13, 33, 8, 2.98),
    (39, 8, 10, 0, 10, 53, 8, 3.2),
    (40, 8, 13, 0, 14, 39, 20, 1.56),
    (41, 9, 1, 0, 8, 63, 9, 6.49),
    (42, 9, 4, 0, 7, 18, 4, 4.62),
    (43, 9, 7, 0, 12, 68, 11, 5.28),
    (44, 9, 10, 1, 15, 31, 9, 7.27),
    (45, 9, 13, 1, 12, 77, 0, 0.09),
    (46, 10, 1, 0, 14, 56, 10, 1.03),
    (47, 10, 4, 0, 7, 74, 0, 2.03),
    (48, 10, 7, 0, 11, 48, 15, 3.75),
    (49, 10, 10, 0, 16, 26, 6, 8.3),
    (50, 10, 13, 0, 11, 11, 7, 1.01),
    (51, 11, 1, 1, 16, 57, 10, 1.66),
    (52, 11, 4, 0, 1, 58, 11, 7.86),
    (53, 11, 7, 0, 4, 58, 21, 6.81),
    (54, 11, 10, 0, 12, 27, 3, 0.87),
    (55, 11, 13, 0, 12, 28, 9, 0.83),
    (56, 12, 1, 0, 1, 20, 14, 4.03),
    (57, 12, 5, 0, 1, 20, 17, 1.26),
    (58, 12, 9, 0, 6, 13, 9, 0.66),
    (59, 12, 12, 0, 11, 28, 18, 1.79),
    (60, 12, 14, 0, 13, 60, 12, 0.31),
    (61, 13, 1, 0, 6, 22, 10, 4.43),
    (62, 13, 5, 1, 5, 52, 9, 3.44),
    (63, 13, 9, 0, 6, 66, 14, 3.41),
    (64, 13, 12, 0, 13, 64, 5, 7.83),
    (65, 13, 14, 0, 9, 34, 11, 9.85),
    (66, 14, 1, 0, 2, 77, 14, 7.67),
    (67, 14, 5, 0, 4, 45, 10, 1.6),
    (68, 14, 9, 0, 11, 11, 2, 7.77),
    (69, 14, 12, 0, 10, 35, 17, 0.09),
    (70, 14, 14, 2, 10, 39, 10, 0.1),
    (71, 15, 1, 2, 13, 59, 1, 0.95),
    (72, 15, 5, 0, 11, 80, 5, 4.7),
    (73, 15, 9, 0, 3, 38, 6, 7.39),
    (74, 15, 12, 0, 7, 31, 0, 9.06),
    (75, 15, 14, 0, 6, 58, 5, 5.03),
    (76, 16, 1, 0, 4, 48, 11, 7.75),
    (77, 16, 5, 0, 11, 76, 21, 1.72),
    (78, 16, 9, 0, 10, 55, 15, 6.54),
    (79, 16, 12, 0, 6, 75, 19, 8.68),
    (80, 16, 14, 0, 1, 59, 13, 1.36),
    (81, 17, 1, 0, 15, 30, 1, 0.95),
    (82, 17, 5, 0, 12, 58, 1, 0.57),
    (83, 17, 9, 0, 4, 8, 0, 7.96),
    (84, 17, 12, 0, 6, 26, 9, 7.45),
    (85, 17, 14, 0, 4, 64, 1, 1.68),
    (86, 18, 1, 0, 14, 72, 3, 2.77),
    (87, 18, 5, 0, 9, 45, 10, 5.61),
    (88, 18, 9, 1, 16, 64, 17, 1.23),
    (89, 18, 12, 1, 8, 14, 6, 4.53),
    (90, 18, 14, 0, 15, 22, 14, 1.99),
    (91, 19, 1, 0, 11, 63, 4, 5.78),
    (92, 19, 5, 0, 13, 66, 0, 2.52),
    (93, 19, 9, 0, 12, 46, 1, 1.14),
    (94, 19, 12, 1, 7, 55, 6, 8.96),
    (95, 19, 14, 0, 15, 73, 4, 8.6),
    (96, 20, 1, 1, 10, 31, 8, 6.49),
    (97, 20, 5, 2, 13, 79, 17, 6.07),
    (98, 20, 9, 0, 16, 40, 10, 1.23),
    (99, 20, 12, 0, 9, 20, 16, 4.25),
    (100, 20, 14, 0, 5, 78, 15, 2.83),
    (101, 21, 1, 1, 16, 76, 1, 1.03),
    (102, 21, 5, 0, 6, 56, 10, 1.6),
    (103, 21, 9, 0, 9, 25, 9, 4.27),
    (104, 21, 12, 2, 16, 48, 21, 3.4),
    (105, 21, 14, 0, 13, 9, 3, 5.97),
    (106, 22, 1, 1, 9, 23, 6, 1.66),
    (107, 22, 5, 0, 7, 34, 12, 2.29),
    (108, 22, 9, 0, 7, 28, 4, 7.2),
    (109, 22, 12, 1, 6, 26, 6, 4.43),
    (110, 22, 14, 0, 5, 15, 1, 4.09),
    (111, 23, 2, 2, 8, 29, 6, 5.31),
    (112, 23, 4, 1, 5, 57, 16, 2.87),
    (113, 23, 8, 0, 10, 13, 10, 5.68),
    (114, 23, 11, 0, 10, 77, 2, 2.22),
    (115, 23, 14, 0, 14, 75, 20, 0.31),
    (116, 24, 2, 0, 4, 42, 6, 3.89),
    (117, 24, 4, 1, 8, 67, 9, 2.22),
    (118, 24, 8, 0, 14, 77, 21, 9.61),
    (119, 24, 11, 0, 8, 24, 21, 0.36),
    (120, 24, 14, 2, 6, 19, 9, 9.85),
    (121, 25, 2, 0, 11, 16, 2, 4.79),
    (122, 25, 4, 0, 8, 17, 16, 4.44),
    (123, 25, 8, 0, 15, 60, 12, 7.86),
    (124, 25, 11, 0, 10, 77, 3, 2.58),
    (125, 25, 14, 0, 4, 7, 3, 0.1),
    (126, 26, 2, 0, 9, 48, 10, 5.69),
    (127, 26, 4, 0, 6, 24, 0, 3.05),
    (128, 26, 8, 0, 11, 26, 3, 8.52),
    (129, 26, 11, 0, 10, 46, 4, 7.17),
    (130, 26, 14, 0, 5, 35, 12, 5.03),
    (131, 27, 2, 0, 4, 21, 4, 6.29),
    (132, 27, 4, 0, 6, 18, 5, 4.99),
    (133, 27, 8, 0, 11, 74, 20, 3.82),
    (134, 27, 11, 0, 8, 58, 13, 6.38),
    (135, 27, 14, 0, 15, 73, 11, 1.36),
    (136, 28, 2, 0, 14, 16, 2, 1.72),
    (137, 28, 4, 0, 11, 49, 4, 4.81),
    (138, 28, 8, 0, 7, 39, 4, 3.06),
    (139, 28, 11, 0, 10, 9, 6, 6.46),
    (140, 28, 14, 0, 13, 52, 16, 1.68),
    (141, 29, 2, 0, 5, 36, 16, 6.66),
    (142, 29, 4, 0, 14, 37, 10, 3.97),
    (143, 29, 8, 2, 6, 45, 5, 4.8),
    (144, 29, 11, 0, 8, 37, 9, 3.44),
    (145, 29, 14, 0, 12, 55, 10, 1.99),
    (146, 30, 2, 0, 13, 23, 14, 4.94),
    (147, 30, 4, 0, 16, 75, 19, 2.5),
    (148, 30, 8, 0, 5, 57, 2, 8.41),
    (149, 30, 11, 0, 16, 76, 12, 4.95),
    (150, 30, 14, 0, 16, 21, 8, 8.6),
    (151, 31, 2, 0, 11, 51, 19, 2.02),
    (152, 31, 4, 0, 12, 20, 12, 4.62),
    (153, 31, 8, 0, 4, 77, 14, 3.49),
    (154, 31, 11, 0, 12, 61, 11, 1.51),
    (155, 31, 14, 0, 15, 20, 3, 2.83),
    (156, 32, 2, 0, 16, 52, 18, 6.14),
    (157, 32, 4, 0, 5, 14, 6, 2.03),
    (158, 32, 8, 0, 7, 27, 17, 0.22),
    (159, 32, 11, 0, 15, 58, 13, 4.95),
    (160, 32, 14, 0, 13, 50, 20, 5.97),
    (161, 33, 2, 1, 13, 53, 2, 4.94),
    (162, 33, 4, 0, 4, 48, 13, 7.86),
    (163, 33, 8, 0, 11, 55, 6, 9.83),
    (164, 33, 11, 0, 10, 42, 19, 5.81),
    (165, 33, 14, 0, 8, 37, 11, 4.09),
    (166, 34, 2, 0, 10, 28, 5, 5.31),
    (167, 34, 6, 0, 6, 14, 12, 7.5),
    (168, 34, 7, 0, 10, 21, 0, 0.94),
    (169, 34, 12, 0, 8, 44, 18, 1.79),
    (170, 34, 15, 0, 2, 60, 17, 4.92),
    (171, 35, 2, 0, 11, 52, 0, 3.89),
    (172, 35, 6, 0, 16, 25, 12, 6.83),
    (173, 35, 7, 0, 10, 46, 2, 6.13),
    (174, 35, 12, 1, 9, 76, 6, 7.83),
    (175, 35, 15, 0, 3, 60, 16, 3.57),
    (176, 36, 2, 1, 6, 46, 21, 4.79),
    (177, 36, 6, 0, 15, 48, 16, 1.17),
    (178, 36, 7, 0, 8, 68, 7, 2.64),
    (179, 36, 12, 0, 10, 78, 19, 0.09),
    (180, 36, 15, 2, 8, 18, 15, 0.96),
    (181, 37, 2, 0, 15, 67, 21, 5.69),
    (182, 37, 6, 3, 13, 66, 14, 7.92),
    (183, 37, 7, 0, 8, 37, 3, 1.02),
    (184, 37, 12, 0, 3, 81, 10, 9.06),
    (185, 37, 15, 0, 8, 75, 19, 8.68),
    (186, 38, 2, 0, 8, 39, 10, 6.29),
    (187, 38, 6, 0, 8, 32, 15, 1.25),
    (188, 38, 7, 0, 14, 24, 9, 6.64),
    (189, 38, 12, 0, 13, 68, 5, 8.68),
    (190, 38, 15, 0, 8, 65, 5, 1.64),
    (191, 39, 2, 0, 2, 19, 5, 1.72),
    (192, 39, 6, 0, 4, 69, 16, 2.17),
    (193, 39, 7, 0, 6, 49, 20, 2.64),
    (194, 39, 12, 1, 10, 11, 5, 7.45),
    (195, 39, 15, 1, 9, 49, 15, 3.28),
    (196, 40, 2, 0, 15, 39, 11, 6.66),
    (197, 40, 6, 0, 7, 46, 17, 5.83),
    (198, 40, 7, 0, 16, 57, 7, 3.66),
    (199, 40, 12, 0, 13, 63, 11, 4.53),
    (200, 40, 15, 0, 4, 47, 6, 5.01),
    (201, 41, 2, 0, 10, 24, 4, 4.94),
    (202, 41, 6, 0, 8, 5, 0, 4.25),
    (203, 41, 7, 0, 13, 76, 0, 2.98),
    (204, 41, 12, 0, 16, 52, 11, 8.96),
    (205, 41, 15, 0, 4, 78, 3, 6.27),
    (206, 42, 2, 0, 11, 62, 14, 2.02),
    (207, 42, 6, 1, 10, 25, 14, 7.75),
    (208, 42, 7, 0, 10, 69, 12, 5.28),
    (209, 42, 12, 2, 16, 14, 2, 4.25),
    (210, 42, 15, 0, 7, 63, 13, 7.04),
    (211, 43, 2, 0, 14, 66, 12, 6.14),
    (212, 43, 6, 0, 15, 24, 14, 8.25),
    (213, 43, 7, 0, 13, 66, 8, 3.75),
    (214, 43, 12, 0, 12, 4, 3, 3.4),
    (215, 43, 15, 0, 7, 39, 13, 0.96),
    (216, 44, 2, 0, 8, 65, 4, 4.94),
    (217, 44, 6, 0, 12, 39, 7, 4.42),
    (218, 44, 7, 0, 9, 71, 17, 6.81),
    (219, 44, 12, 0, 6, 45, 2, 4.43),
    (220, 44, 15, 2, 6, 59, 7, 5.79),
    (221, 45, 3, 0, 3, 42, 11, 2.93),
    (222, 45, 5, 0, 4, 59, 12, 1.26),
    (223, 45, 8, 0, 15, 37, 1, 5.68),
    (224, 45, 10, 0, 8, 73, 5, 8.39),
    (225, 45, 15, 0, 8, 19, 1, 4.92),
    (226, 46, 3, 0, 15, 57, 21, 5.59),
    (227, 46, 5, 0, 11, 77, 19, 3.44),
    (228, 46, 8, 1, 12, 40, 8, 9.61),
    (229, 46, 10, 0, 12, 46, 3, 0.61),
    (230, 46, 15, 0, 16, 61, 18, 3.57),
    (231, 47, 3, 0, 4, 31, 20, 0.35),
    (232, 47, 5, 1, 12, 16, 5, 1.6),
    (233, 47, 8, 0, 7, 74, 5, 7.86),
    (234, 47, 10, 0, 13, 29, 14, 1.21),
    (235, 47, 15, 0, 13, 55, 6, 0.96),
    (236, 48, 3, 1, 14, 75, 5, 1.33),
    (237, 48, 5, 0, 16, 18, 2, 4.7),
    (238, 48, 8, 0, 11, 73, 11, 8.52),
    (239, 48, 10, 2, 4, 63, 14, 3.55),
    (240, 48, 15, 0, 14, 72, 4, 8.68),
    (241, 49, 3, 0, 13, 61, 14, 0.89),
    (242, 49, 5, 0, 3, 63, 8, 1.72),
    (243, 49, 8, 0, 13, 74, 3, 3.82),
    (244, 49, 10, 2, 15, 59, 6, 5.62),
    (245, 49, 15, 0, 6, 51, 14, 1.64),
    (246, 50, 3, 0, 10, 15, 6, 7.19),
    (247, 50, 5, 0, 12, 77, 12, 0.57),
    (248, 50, 8, 0, 7, 51, 7, 3.06),
    (249, 50, 10, 1, 14, 37, 13, 3.03),
    (250, 50, 15, 0, 12, 48, 11, 3.28),
    (251, 51, 3, 0, 8, 37, 1, 2.93),
    (252, 51, 5, 0, 12, 67, 5, 5.61),
    (253, 51, 8, 0, 7, 45, 0, 4.8),
    (254, 51, 10, 0, 14, 48, 9, 6.23),
    (255, 51, 15, 0, 8, 48, 1, 5.01),
    (256, 52, 3, 0, 9, 69, 15, 7.1),
    (257, 52, 5, 0, 5, 19, 17, 2.52),
    (258, 52, 8, 0, 16, 29, 13, 8.41),
    (259, 52, 10, 0, 15, 20, 14, 3.2),
    (260, 52, 15, 0, 6, 13, 1, 6.27),
    (261, 53, 3, 0, 15, 63, 21, 7.1),
    (262, 53, 5, 1, 14, 81, 15, 6.07),
    (263, 53, 8, 0, 15, 15, 5, 3.49),
    (264, 53, 10, 1, 12, 26, 8, 7.27),
    (265, 53, 15, 0, 13, 56, 21, 7.04),
    (266, 54, 3, 0, 7, 64, 4, 4.08),
    (267, 54, 5, 0, 3, 43, 9, 1.6),
    (268, 54, 8, 0, 1, 69, 15, 0.22),
    (269, 54, 10, 0, 7, 31, 8, 8.3),
    (270, 54, 15, 0, 2, 49, 21, 0.96),
    (271, 55, 3, 0, 12, 25, 14, 6.74),
    (272, 55, 5, 0, 13, 11, 3, 2.29),
    (273, 55, 8, 0, 11, 38, 18, 9.83),
    (274, 55, 10, 0, 4, 77, 0, 0.87),
    (275, 55, 15, 0, 6, 68, 21, 5.79),
    (276, 56, 3, 0, 14, 78, 11, 2.93),
    (277, 56, 6, 0, 9, 62, 4, 7.5),
    (278, 56, 9, 0, 6, 42, 2, 0.66),
    (279, 56, 11, 0, 11, 42, 19, 2.22),
    (280, 56, 13, 0, 6, 54, 2, 3.31),
    (281, 57, 3, 0, 8, 81, 8, 5.59),
    (282, 57, 6, 0, 15, 12, 5, 6.83),
    (283, 57, 9, 0, 6, 51, 18, 3.41),
    (284, 57, 11, 1, 8, 56, 6, 0.36),
    (285, 57, 13, 0, 6, 57, 14, 1.75),
    (286, 58, 3, 3, 8, 10, 2, 0.35),
    (287, 58, 6, 3, 10, 19, 7, 1.17),
    (288, 58, 9, 0, 14, 78, 3, 7.77),
    (289, 58, 11, 0, 7, 28, 18, 2.58),
    (290, 58, 13, 0, 12, 81, 13, 5.24),
    (291, 59, 3, 0, 8, 32, 5, 1.33),
    (292, 59, 6, 0, 15, 24, 3, 7.92),
    (293, 59, 9, 0, 12, 17, 12, 7.39),
    (294, 59, 11, 0, 8, 58, 9, 7.17),
    (295, 59, 13, 0, 2, 80, 0, 6.99),
    (296, 60, 3, 0, 10, 26, 16, 0.89),
    (297, 60, 6, 2, 9, 33, 10, 1.25),
    (298, 60, 9, 0, 8, 24, 7, 6.54),
    (299, 60, 11, 0, 8, 57, 18, 6.38),
    (300, 60, 13, 0, 15, 56, 15, 3.86),
    (301, 61, 3, 0, 6, 21, 9, 7.19),
    (302, 61, 6, 0, 12, 23, 8, 2.17),
    (303, 61, 9, 0, 6, 54, 3, 7.96),
    (304, 61, 11, 0, 6, 81, 6, 6.46),
    (305, 61, 13, 1, 13, 71, 19, 7.64),
    (306, 62, 3, 0, 14, 14, 4, 2.93),
    (307, 62, 6, 0, 4, 14, 4, 5.83),
    (308, 62, 9, 0, 6, 34, 21, 1.23),
    (309, 62, 11, 0, 10, 26, 4, 3.44),
    (310, 62, 13, 0, 11, 32, 16, 9.11),
    (311, 63, 3, 0, 2, 44, 15, 7.1),
    (312, 63, 6, 0, 13, 20, 17, 4.25),
    (313, 63, 9, 2, 5, 58, 10, 1.14),
    (314, 63, 11, 0, 5, 77, 13, 4.95),
    (315, 63, 13, 0, 12, 73, 14, 1.56),
    (316, 64, 3, 3, 13, 44, 1, 7.1),
    (317, 64, 6, 0, 7, 33, 3, 7.75),
    (318, 64, 9, 3, 15, 45, 8, 1.23),
    (319, 64, 11, 0, 13, 72, 13, 1.51),
    (320, 64, 13, 0, 1, 41, 1, 0.09),
    (321, 65, 3, 0, 4, 24, 15, 4.08),
    (322, 65, 6, 0, 2, 36, 0, 8.25),
    (323, 65, 9, 0, 12, 10, 3, 4.27),
    (324, 65, 11, 0, 16, 81, 7, 4.95),
    (325, 65, 13, 0, 16, 79, 8, 1.01),
    (326, 66, 3, 0, 6, 52, 5, 6.74),
    (327, 66, 6, 0, 14, 49, 14, 4.42),
    (328, 66, 9, 0, 12, 44, 13, 7.2),
    (329, 66, 11, 0, 9, 46, 8, 5.81),
    (330, 66, 13, 0, 16, 36, 9, 0.83);

INSERT INTO Referee (person_id, name, birthdate, height, weight, phone_number, email, address, date_started, certification_level) VALUES
    (1, 'Liam Taylor', '1991-03-18', 175, 69, 2361234567, 'liam.taylor@soccer.com', '567 Oak St, Vancouver', '2009-08-14', 1),
    (2, 'Ella Smith', '1996-08-22', 163, 61, 2362345678, 'ella.smith@soccer.com', '345 Elm St, Vancouver', '2017-05-25', 2),
    (3, 'Noah Johnson', '1989-12-05', 188, 87, 2363456789, 'noah.johnson@soccer.com', '678 Birch St, Vancouver', '2006-11-30', 3),
    (4, 'Mia Davis', '1993-04-30', 168, 68, 2364567890, 'mia.davis@soccer.com', '456 Cedar St, Vancouver', '2014-09-07', 4),
    (5, 'Oliver Anderson', '1980-06-14', 178, 81, 2365678901, 'oliver.anderson@soccer.com', '890 Pine St, Vancouver', '2000-04-18', 5);

INSERT INTO Coach (person_id, name, birthdate, height, weight, phone_number, email, address, date_started, current_team, specialization) VALUES
    (1, 'Daniel Lee', '1985-04-15', 178, 80, 6048234567, 'daniel.lee@soccer.com', '567 Birch St, Vancouver', '2000-07-10', 'Vancouver Vipers', 'Head Coach'),
    (2, 'Olivia Johnson', '1992-09-25', 168, 64, 7788345678, 'olivia.johnson@soccer.com', '890 Elm St, Vancouver', '2010-03-18', 'Vancouver Vipers', 'Assistant Coach'),
    (3, 'William Smith', '1988-11-03', 182, 84, 6048456789, 'william.smith@soccer.com', '123 Cedar St, Vancouver', '2005-12-05', 'Richmond Thunder', 'Head Coach'),
    (4, 'Sophia Brown', '1995-07-19', 170, 68, 7788567890, 'sophia.brown@soccer.com', '456 Fir St, Vancouver', '2018-02-14', 'Richmond Thunder', 'Assistant Coach'),
    (5, 'James Anderson', '1982-03-12', 188, 88, 6048678901, 'james.anderson@soccer.com', '789 Pine St, Vancouver', '2002-09-22', 'Burnaby Warriors', 'Head Coach'),
    (6, 'Simon Roach', '1998-05-29', 175, 64, 6045889120, 'simon.roach@soccer.com', '932 Red Oak St, Vancouver', '2015-06-30', 'Burnaby Warriors', 'Assistant Coach'),
    (7, 'Madeline Bills', '1987-08-14', 168, 58, 7781029391, 'madeline.bills@soccer.com', '402 Ocean View Rd, Vancouver', '2004-04-03', 'Surrey Titans', 'Head Coach'),
    (8, 'Rachel Chu', '1990-01-02', 170, 51, 7789203019, 'rachel.chu@soccer.com', '102 Panther Lane, Vancouver', '2009-11-12', 'Surrey Titans', 'Assistant Coach'),
    (9, 'Oscar Rodriguez', '1986-12-08', 206, 101, 7780192939, 'oscar.rodriguez@soccer.com', '882 Parker Drive, Vancouver', '2007-07-27', 'Coquitlam Sharks', 'Head Coach'),
    (10, 'Natalie Nguyen', '1994-04-23', 185, 81, 6047789102, 'natalie.nguyen@soccer.com', '721 Red Roof Way, Vancouver', '2013-01-19', 'Coquitlam Sharks', 'Assistant Coach'),
    (11, 'Robert Barns', '1983-06-17', 178, 102, 6042102939, 'robert.barns@soccer.com', '900 Frankfurt Rd, Vancouver', '2001-10-09', 'Langley Bears', 'Head Coach'),
    (12, 'Bill Bacon', '1997-10-30', 150, 71, 7781920392, 'bill.bacon@soccer.com', '562 Fox Den Lane, Vancouver', '2014-08-07', 'Langley Bears', 'Assistant Coach');


INSERT INTO GivenBy (sponsor_name, award_id) VALUES
    ('Adidas', 1),
    ('Coca-Cola', 2),
    ('Visa', 3),
    ('Adidas', 4),
    ('UBC', 5);

INSERT INTO HasSponsor (team_name, sponsor_name) VALUES
    ('Vancouver Vipers', 'Adidas'),
    ('Richmond Thunder', 'Coca-Cola'),
    ('Burnaby Warriors', 'Visa'),
    ('Surrey Titans', 'Adidas'),
    ('Coquitlam Sharks', 'UBC');

INSERT INTO LocatedIn (game_id, venue_address) VALUES
    (1, '5123 Main Street, Vancouver'),
    (2, '5789 Elm Road, Burnaby'),
    (3, '5234 Pine Street, Coquitlam'),
    (4, '5123 Main Street, Vancouver'),
    (5, '5456 Oak Avenue, Richmond'),
    (6, '5101 Maple Lane, Surrey'),
    (7, '5123 Main Street, Vancouver'),
    (8, '5789 Elm Road, Burnaby'),
    (9, '5456 Oak Avenue, Richmond'),
    (10, '5123 Main Street, Vancouver'),
    (11, '5789 Elm Road, Burnaby'),
    (12, '5456 Oak Avenue, Richmond'),
    (13, '1923 River Road, Langley'),
    (14, '5456 Oak Avenue, Richmond'),
    (15, '5234 Pine Street, Coquitlam');

INSERT INTO ParticipatesIn (game_id, team_1, team_2) VALUES
    (1, 'Vancouver Vipers', 'Richmond Thunder'),
    (2, 'Burnaby Warriors', 'Surrey Titans'),
    (3, 'Coquitlam Sharks', 'Langley Bears'),
    (4, 'Vancouver Vipers', 'Burnaby Warriors'),
    (5, 'Richmond Thunder', 'Coquitlam Sharks'),
    (6, 'Surrey Titans', 'Langley Bears'),
    (7, 'Vancouver Vipers', 'Surrey Titans'),
    (8, 'Burnaby Warriors', 'Coquitlam Sharks'),
    (9, 'Richmond Thunder', 'Langley Bears'),
    (10, 'Vancouver Vipers', 'Coquitlam Sharks'),
    (11, 'Burnaby Warriors', 'Langley Bears'),
    (12, 'Richmond Thunder', 'Surrey Titans'),
    (13, 'Langley Bears', 'Vancouver Vipers'),
    (14, 'Richmond Thunder', 'Burnaby Warriors'),
    (15, 'Coquitlam Sharks', 'Surrey Titans');

INSERT INTO WinsAward (award_id, person_id, team_name) VALUES
    (1, 2, NULL),
    (2, 32, NULL),
    (3, 25, NULL),
    (4, NULL, 'Coquitlam Sharks'),
    (5, NULL, 'Surrey Titans'),
    (6, 2, NULL);

INSERT INTO Referees (person_id, game_id) VALUES
    -- Ref 1
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (1, 6),
    (1, 7),
    (1, 8),
    (1, 9),
    (1, 10),
    (1, 11),
    (1, 12),
    (1, 13),
    (1, 14),
    (1, 15),
    -- Ref 2
    (2, 1),
    (2, 3),
    (2, 8),
    (2, 15),
    -- Ref 3
    (3, 4),
    (3, 5),
    (3, 11),
    (3, 15),
    -- Ref 4
    (4, 1),
    (4, 2),
    (4, 3),
    (4, 4),
    (4, 5),
    (4, 6),
    (4, 7),
    (4, 8),
    (4, 9),
    (4, 10),
    (4, 11),
    (4, 12),
    (4, 13),
    (4, 14),
    (4, 15),
    -- Ref 5
    (5, 2),
    (5, 7),
    (5, 12),
    (5, 14);
