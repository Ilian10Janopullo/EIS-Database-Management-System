CREATE DATABASE eis;

USE eis;

CREATE TABLE family(
    family_id INT NOT NULL AUTO_INCREMENT,
    father_name VARCHAR(25) NOT NULL,
    father_phone_nr INT NOT NULL,
    father_profession VARCHAR(25) NOT NULL,
    mother_name VARCHAR(25) NOT NULL,
    mother_phone_nr INT NOT NULL,
    mother_profession VARCHAR(25) NOT NULL,
    PRIMARY KEY (family_id)
);


INSERT INTO family(father_name,father_phone_nr, father_profession, mother_name, mother_phone_nr, mother_profession)
VALUES
("Ralf", 0661122333, "Dressmaker", "Marita", 0662233111, "Company Director"),
("Madison", 0661221333, "Fitness Instructor", "Clara", 0662121311, "Artist"),
("Rayner", 0662111515, "Barber", "Jennifer", 0662213987, "Speech therapist"),
("Geoff", 0666789123, "Pathologist", "Jaylene", 0668118965, "Childcare worker"),
("Jefferson", 0668171233, "Dental hygienist", "Stephania", 0663453679, "Reporter"),
("Nikolas", 0669786324, "Auctioneer", "Jessalyn", 0665447821, "Market trader"),
("Finn", 0663298564, "Marketing Director", "Tracie", 0668990323, "Lawyer"),
("Klay", 0667216888, "Doctor", "Jena", 0669090233, "Television presenter"),
("Colbert", 0663423900, "HR", "Vivian", 0669132000, "Architect"),
("Dixon", 0667127984, "Minister", "Roxanna", 0669080192, "Minister");


CREATE TABLE study_program(
    program_id INT NOT NULL AUTO_INCREMENT,
    program_name VARCHAR(25) NOT NULL,
    degree_awarded VARCHAR(25) NOT NULL,
    faculty_name VARCHAR(45) NOT NULL,
    department_id INT NOT NULL,
    department_name VARCHAR(45) NOT NULL,
    tuition_fees INT NOT NULL,
    PRIMARY KEY(program_id)
);

ALTER TABLE study_program ADD INDEX study_program_index(department_id);

INSERT INTO study_program(program_name, faculty_name, department_id,department_name, tuition_fees, degree_awarded)
VALUES
("SWE","Architecture and Engineering", 1,"Computer Engineering", 4000, "Bachelor"),
("CEN","Architecture and Engineering", 1,"Computer Engineering", 3500, "Bachelor"),
("ECE", "Architecture and Engineering",1,"Computer Engineering", 3000, "Bachelor"),
("ARCH","Architecture and Engineering", 2,"Architecture", 4500, "Bachelor"),
("BINF","Economics and Administrative Sciences", 3,"Business Administration",3500, "Bachelor"),
("IML", "Economics and Administrative Sciences", 3,"Business Administration",3000, "Bachelor"),
("ECO", "Economics and Administrative Sciences", 4,"Economics", 3000, "Bachelor");

CREATE TABLE building(
	building_name char(1),
    class_name varchar(20) not null,
    class_type varchar(20) not null,
    nr_of_places int not null,
    primary key(class_name)
);

INSERT INTO building(building_name, class_name, class_type, nr_of_places)
VALUES
("A","A128","Lesson/Seminar",60),
("E","E012","Lesson",80),
("D","D301","Lesson",60),
("A","A130","Lesson/Seminar",60),
("E","LAB2","Lab",45),
("E","EB31","Lab",40),
("A","A140","Architecture class",40),
("E","E005","Office",2),
("E","E002","Office",2),
("E","E006","Office",2),
("E","E202","Office",2),
("E","E203","Office",2),
("A","A003","Office",2),
("A","A132","Office",2),
("A","A134","Office",2);

CREATE TABLE student(
    student_id INT NOT NULL AUTO_INCREMENT,
    student_name VARCHAR(25) NOT NULL,
    student_surname VARCHAR(25) NOT NULL,
    student_no VARCHAR(15) NOT NULL,
    program_id INT NOT NULL,
    student_birthdate DATE NOT NULL,
    student_enrollment_date DATE NOT NULL,
    student_birthplace VARCHAR(25) NOT NULL,
    student_gender VARCHAR(6) NOT NULL,
    student_blood_group CHAR(2),
    student_marital_status VARCHAR(10) NOT NULL,
    student_citizenship VARCHAR(25) NOT NULL,
    student_passport_number INT NOT NULL,
    student_id_card_number INT NOT NULL,
    student_primary_email VARCHAR(35) NOT NULL,
    student_secondary_email VARCHAR(35) NOT NULL,
    student_address VARCHAR(25) NOT NULL,
    student_family_id INT NOT NULL,
    student_staus VARCHAR(25) NOT NULL,
    student_picture VARCHAR(25) NOT NULL,
    student_aptis VARCHAR(2),
    FOREIGN KEY (program_id) REFERENCES study_program(program_id),
    FOREIGN KEY (student_family_id) REFERENCES family(family_id),
    PRIMARY KEY(student_id)
);

INSERT INTO student(student_name, student_surname, student_no, program_id, student_birthdate, student_gender,
student_blood_group, student_marital_status, student_citizenship, student_passport_number, student_id_card_number,
student_primary_email, student_secondary_email, student_address, student_family_id, 
student_picture, student_aptis, student_enrollment_date, student_birthplace, student_staus)
VALUES
("Walton", "Jinks", "02012245", 2, "2003-10-31", "Male", "B+", "Single", "Albania", 23890012, 23890012, 
"waltonjinks@gmail.com", "jwatkins22@epoka.edu.al", "London", 10, "photo1" ,"C1", "2022-02-09", "Tirane", "Current Student"),
("Sylvia", "Gardener", "02052226", 1, "2003-04-21", "Female", "B-", "Single", "Albania", 14692019, 14692019, 
"sylviagardener@gmail.com", "sgardener22@epoka.edu.al", "London", 3, "photo2" ,"C1", "2022-02-09", "Tirane", "Current Student"),
("Emmanuel", "Fishman", "02022212", 3, "2003-12-08", "Male", "A+", "Single", "Albania", 11349817, 11349817, 
"emmanuelfishman@gmail.com", "efishman22@epoka.edu.al", "Manchester", 2, "photo3", "C1", "2022-02-09", "Elbasan", "Current Student"),
("Bettie", "Marchand", "02042249", 4, "2004-01-22", "Female", "A-", "Single", "Albania", 20826092, 20826092, 
"bettiemarchand@gmail.com", "bmarchand22@epoka.edu.al", "London", 6, "photo4", "C1", "2022-02-09", "Tirane", "Current Student"),
("Justin", "Attwood", "01012207", 7, "2004-03-31", "Male", "B+", "Single", "Albania", 13499982, 13499982, 
"justinattwood@gmail.com", "jattwood22@epoka.edu.al", "London", 1, "photo5" ,"B2", "2022-02-09", "Durres", "Current Student"),
("Alexa", "Rounds", "01052332", 5, "2004-10-22", "Female", "0+", "Single", "Albania", 91099042, 91099042, 
"alexarounds@gmail.com", "arounds23@epoka.edu.al", "Liverpool", 8, "photo6" ,"C1", "2022-02-09", "Tirane", "Current Student"),
("David", "Lowell", "01032318", 6, "2004-07-15", "Male", "B+", "Single", "Albania", 32997500, 32997500, 
"davidlowell@gmail.com", "dlowell23@epoka.edu.al", "London", 9, "photo7" ,"C1", "2022-02-09", "Peqin", "Current Student"),
("Leona", "Carlyle", "02042395", 2, "2004-08-16", "Female", "B+", "Single", "Albania", 92730012, 92730012, 
"leonacarlyle@gmail.com", "lcarlyle23@epoka.edu.al", "London", 4, "photo8", "C1", "2022-02-09", "Ura Vajgurore", "Current Student"),
("Viego", "Lewin", "02052387", 1, "2004-10-01", "Male", "B+", "Single", "Albania", 88010347, 88010347, 
"viegolewin@gmail.com", "vlewin23@epoka.edu.al", "Southampton", 5, "photo9","B2", "2022-02-09", "Tirane", "Current Student"),
("Morgana", "Walmsley", "01052367", 2, "2004-11-19", "Female", "B+", "Single", "Albania", 61810012,61810012, 
"morganawalmsley@gmail.com", "mwalmsley23@epoka.edu.al", "Bristol", 7, "photo10", "C1", "2022-02-09", "Tirane", "Current Student");

CREATE TABLE lecturer (
    lecturer_id INT NOT NULL AUTO_INCREMENT,
    lecturer_name VARCHAR(20) NOT NULL,
    lecturer_office CHAR(4) NOT NULL,
    lecture_office_hours VARCHAR(20) NOT NULL,
    department_id INT NOT NULL,
    FOREIGN KEY(department_id) REFERENCES study_program(department_id),
    FOREIGN KEY (lecturer_office) REFERENCES building (class_name),
    PRIMARY KEY (lecturer_id)
);


INSERT INTO lecturer (lecturer_name, department_id, lecturer_office, lecture_office_hours)
VALUES
("Florenc Skuka", 1, "E002", "9:00 - 11:00"),
("Sabrina Begaj", 1, "E006", "9:00 - 11:00"),
("Shkelqim Hajrulla",1, "A003", "10:00 - 11:00"),
("Hashmet Durmishi", 1,"E002", "9:00 - 11:00"),
("Ari Gjerazi",1, "E005", "9:00 - 11:00"),
("Igli Draci", 1,"E005","9:00 - 11:00"),
("Redjola Manaj",1, "A132", "9:00 - 11:00"),
("Ardita Dorti",3, "E203","9:00 - 11:00"),
("Aida Bitri",3, "E202","9:00 - 12:00"),
("Odeta Manahasa", 2, "A134", "13:00 - 14:00");

CREATE TABLE course(
    course_id CHAR(7) NOT NULL,
    course_name VARCHAR(85) NOT NULL,
    course_credits INT NOT NULL,
    course_ects INT NOT NULL,
    PRIMARY KEY(course_id)
);

INSERT INTO course(course_id,course_name,course_credits,course_ects)
VALUES
("MTH207","Fundamentals of Probability",3,6),
("CEN203","Database Management Systems",4,7),
("CEN215","Computer Organization",3,6),
("CEN219","OOP",4,7),
("MTH106","Discrete Mathematics",3,5),
("BINF101","Fundamentals of Information System",3,5),
("BINF251","Database Management Systems",3,6),
("ARCH121","Introduction to Architecture",4,7),
("PHY101","General Physics 1",6,7),
("CEN105","Linear Algebra",3,5);



CREATE TABLE course_student(
	course_id CHAR(7) NOT NULL,
	student_id INT NOT NULL,
    course_status VARCHAR(15) NOT NULL,
    course_period VARCHAR(20) NOT NULL,
    course_type VARCHAR(15) NOT NULL,
    FOREIGN KEY(course_id) REFERENCES course(course_id),
    FOREIGN KEY(student_id) REFERENCES student(student_id),
    PRIMARY KEY(course_id, student_id)
);

INSERT INTO course_student(course_id, student_id, course_status, course_period, course_type)
VALUES
("MTH207",1,"Ongoing","2023-2024 fall", "Compulsory"),
("MTH207",2,"Ongoing","2023-2024 fall", "Compulsory"),
("PHY101",9,"Ongoing","2023-2024 fall", "Elective"),
("CEN203",2,"Ongoing","2023-2024 fall", "Compulsory"),
("BINF251",10,"Ongoing","2023-2024 fall", "Compulsory"),
("MTH106",2,"Taken","2022-2023 spring", "Elective"),
("ARCH121",8,"Ongoing","2023-2024 fall", "Compulsory"),
("CEN105",9,"Ongoing","2023-2024 fall", "Compulsory"),
("BINF101",6,"Ongoing","2022-2023 fall", "Elective"),
("ARCH121",7,"Taken","2022-2023 fall", "Compulsory"),
("MTH106",1,"Taken","2022-2023 spring", "Compulsory");

CREATE TABLE course_syllabus(
    course_id CHAR(7) NOT NULL,
    course_attendance_request INT NOT NULL,
    course_description VARCHAR(256) NOT NULL,
    course_objective VARCHAR(256) NOT NULL,
    course_basic_concepts VARCHAR(256) NOT NULL,
    course_text_books VARCHAR(256) NOT NULL,
    course_program VARCHAR(256) NOT NULL,
    FOREIGN KEY(course_id) REFERENCES course(course_id),
    PRIMARY KEY(course_id)
);

INSERT INTO course_syllabus(course_id,course_attendance_request, course_description, course_objective, 
course_basic_concepts, course_text_books, course_program)
VALUES
("CEN215",75,"Understanding of the inner-workings of modern computer systems and tradeoffs present at the 
hardware-software interface: .", "test", "test", "test","test"),
("CEN203",75,"This course aims to provide an introduction to the design and use of database systems. .", 
"test", "test", "test","test"),
("MTH207",75,"Fundamentals of Probability course provides a formal and systematic introduction to probability 
and probabilistic models.", "test", "test", "test","test"),
("CEN219",75,"This course calls on you to demonstrate: knowledge of programming techniques and the Java 
language and libraries in particular.", "test", "test", "test","test"),
("PHY101",75,"Solutions of nonlinear equations, Newton's method,fixed points and functional iterations,pivoting,norms.", "test", 
"test", "test","test"),
("MTH106",75,"MTH106 introduces students to the fundamental principles of discrete mathematics,that deals 
with countable,distinct structures.", "test", "test", "test","test"),
("BINF101",75,"An introductory course designed to provide students with a comprehensive understanding of 
Information Systems (IS) and their role in contemporary organizations.", "test", "test", "test","test"),
("BINF251",75,"Database design using entity-relationship model and relational data model,SQL,data integrity and integrity 
constraints,triggers,stored procedures,indexing and application development.", "test", "test", "test","test"),
("CEN105",75,"The objective of this course is to provide the necessary information about computer engineering 
and the computer engineering profession. ", "test", "test", "test","test"),
("ARCH121",75,"Architectural culture, presentation techniques, techniques of architectural analysis.", "test", "test", 
"test","test");


CREATE TABLE attendance(
    attendance_id INT NOT NULL AUTO_INCREMENT,
    course_id CHAR(7) NOT NULL,
    student_id INT NOT NULL,
    week_of INT NOT NULL,
    topic VARCHAR(35) NOT NULL,
    type_of VARCHAR(15) NOT NULL,
    attended INT NOT NULL,
    hours_to_attend INT NOT NULL,
    date_of DATE NOT NULL,
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    PRIMARY KEY (attendance_id)
);

INSERT INTO attendance(course_id,student_id,week_of,topic,type_of,attended,hours_to_attend, date_of)
VALUES
("MTH207",1,3,"Total Probability Rule", "Lesson", 1,2, "2023-10-22"),
("CEN203",2,4,"sql queries", "Lab", 1,3, "2023-11-04"),
("CEN215",2,3,"ALU", "Lesson", 0,2, "2023-10-04"),
("CEN105",9,7,"Matrix Addition", "Lesson", 0,2, "2023-11-20"),
("BINF101",6,1,"Introduction", "Lesson", 1,2, "2023-10-03"),
("PHY101",9,3,"Newton's law", "Lab", 0,3, "2023-10-24"),
("CEN219",2,11,"Java FX", "Lesson", 1,2, "2023-12-11"),
("MTH106",2,1,"Sets", "Lesson", 1,2, "2023-03-12"),
("BINF251",10,2,"ERD Diagram", "Lab", 0,2, "2023-10-13"),
("ARCH121",8,1,"Intro to course", "Lesson", 1,2, "2023-10-03");

CREATE TABLE course_evaluation(
    course_eval_id INT NOT NULL AUTO_INCREMENT,
    course_id CHAR(7) NOT NULL,
    study_degree_id INT NOT NULL,
    quiz_evaluation INT NULL,
    assignment_evaluation INT NULL,
    participation_evaluation INT NULL,
    midterm_evaluation INT NULL,
    final_evaluation INT NULL,
    project_evaluation INT NULL,
    research_paper_evaluation INT NULL,
    FOREIGN KEY(course_id) REFERENCES course(course_id),
    FOREIGN KEY(study_degree_id) REFERENCES study_program(program_id),
    PRIMARY KEY(course_eval_id)
);

INSERT INTO course_evaluation(course_id,study_degree_id,quiz_evaluation, assignment_evaluation, participation_evaluation,
midterm_evaluation, final_evaluation, project_evaluation, research_paper_evaluation)
VALUES
("MTH207",2,"15",0,0,"35","50",0,0),
("CEN203",1,0,0,"10",0,"55","35",0),
("CEN215",1,0,"15",0,"40","45",0,0),
("CEN105",3,"10","10",0,"35","45",0,0),
("BINF101",6,"10","5",0,"35","50",0,0),
("PHY101",1,0,0,0,"40","60",0,0),
("CEN219",1,"10",0,0,"30","40","20",0),
("MTH106",2,"15","5",0,"35","50",0,0),
("BINF251",1,"10","15",0,"30","45",0,0),
("ARCH121",4,0,"30",0,"20","30","20",0);

CREATE TABLE student_evaluation(
    student_eval_id INT NOT NULL AUTO_INCREMENT,
    course_id CHAR(7) NOT NULL,
    student_id INT NOT NULL,
    quiz_grade INT NULL,
    assignment_grade INT NULL,
    participation_grade INT NULL,
    midterm_grade INT NULL,
    final_grade INT NULL,
    project_grade INT NULL,
    research_paper_grade INT NULL,
    FOREIGN KEY(course_id) REFERENCES course(course_id),
    FOREIGN KEY(student_id) REFERENCES student(student_id),
    PRIMARY KEY(student_eval_id)
);
INSERT INTO student_evaluation(course_id, student_id, quiz_grade, 
assignment_grade, participation_grade, midterm_grade,
final_grade, project_grade, research_paper_grade)
VALUES
("MTH207",1,"90","0",0,"89","99",0,0),
("CEN203",2,0,0,"100",0,"88","100",0),
("CEN215",2,0,"100",0,"95","98",0,0),
("CEN105",9,"100","100",0,"90","92",0,0),
("BINF101",6,"90","100",0,"90","87",0,0),
("PHY101",9,0,0,0,"100","100",0,0),
("CEN219",2,"80",0,0,"100","90","100",0),
("MTH106",1,"82","100",0,"70","60",0,0),
("BINF251",10,"100","100",0,"91","99",0,0),
("ARCH121",4,0,100,0,100,100,100,0);

CREATE TABLE finance(
    finance_id INT NOT NULL AUTO_INCREMENT,
    student_id INT NOT NULL,
    program_id INT NOT NULL,
    tuition_paid INT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (program_id) REFERENCES study_program(program_id),
    PRIMARY KEY (finance_id)
);

INSERT INTO finance(student_id,program_id,tuition_paid)
VALUES
(1,2,3000),
(2,1,4000),
(3,3,2500),
(4,4,4500),
(5,7,2500),
(6,5,3500),
(7,6,3000),
(8,4,4500),
(9,2,3000),
(10,5,2000);

CREATE TABLE transactions(
    transaction_id INT NOT NULL AUTO_INCREMENT,
    student_id INT NOT NULL,
    bank VARCHAR(30) NOT NULL,
    account_name VARCHAR(40) NOT NULL,
    account_number INT NOT NULL,
    account_currency VARCHAR(6),
    IBAN CHAR(34) NOT NULL,
    SWIFT CHAR(8) NOT NULL,
    description_of VARCHAR(60) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    PRIMARY KEY(transaction_id)
);

INSERT INTO transactions(student_id,bank,account_name,account_number, account_currency, IBAN, SWIFT,description_of)
VALUES
(1,"INTESA","person1",0001,"LEK","ibantest","swiftex","payment"),
(2,"INTESA","person2",0002,"EUR","ibantest1","swiftex1","payment"),
(3,"INTESA","person3",0003,"EUR","ibantest2","swiftex2","payment"),
(4,"INTESA","person4",0004,"LEK","ibantest3","swiftex3","payment"),
(5,"INTESA","person5",0005,"LEK","ibantest4","swiftex4","payment"),
(6,"INTESA","person6",0006,"EUR","ibantest5","swiftex5","payment"),
(7,"INTESA","person7",0007,"LEK","ibantest6","swiftex6","payment"),
(8,"INTESA","person8",0008,"EUR","ibantest7","swiftex7","payment"),
(9,"INTESA","person9",0009,"LEK","ibantest8","swiftex8","payment"),
(10,"INTESA","person10",00010,"EUR","ibantest9","swiftex9","payment");

CREATE TABLE course_lecturer(
	course_id CHAR(7) NOT NULL,
	lecturer_id INT NOT NULL,
    program_id INT NOT NULL,
	FOREIGN KEY(course_id) REFERENCES course(course_id),
    FOREIGN KEY(lecturer_id) REFERENCES lecturer(lecturer_id),
    FOREIGN KEY(program_id) REFERENCES study_program(program_id),
    PRIMARY KEY(course_id, lecturer_id, program_id)
);

INSERT INTO course_lecturer(course_id, lecturer_id, program_id)
VALUES
("MTH207",7, 1),
("MTH207",7, 2),
("CEN203",5, 2),
("CEN203",5, 1),
("CEN215",1, 1),
("CEN215",1, 2),
("CEN219",6, 1),
("CEN219",6, 2),
("MTH106",7, 1),
("MTH106",7, 2),
("BINF101",8, 5),
("BINF101",9, 6),
("BINF251",8, 5),
("PHY101",4, 1),
("CEN105",3, 1);

CREATE INDEX family_id_index ON family(family_id);

CREATE INDEX program_id_index ON study_program(program_id);
CREATE INDEX faculty_name_index ON study_program(faculty_name);
CREATE INDEX program_name_index ON study_program(program_name);

CREATE INDEX building_name_index ON building(building_name);

CREATE INDEX student_id_index ON student(student_id);
CREATE INDEX program_id_index ON student(program_id);
CREATE INDEX student_family_id_index ON student(student_family_id);
CREATE INDEX student_status_index ON student(student_staus);

CREATE INDEX student_id_index ON transactions(student_id);

CREATE INDEX course_id_index ON course_lecturer(course_id);
CREATE INDEX lecturer_id_index ON course_lecturer(lecturer_id);
CREATE INDEX program_id_index ON course_lecturer(program_id);

CREATE INDEX lecturer_id_index ON lecturer(lecturer_id);
CREATE INDEX lecturer_name_index ON lecturer(lecturer_name);
CREATE INDEX lecturer_office_index ON lecturer(lecturer_office);
CREATE INDEX department_id_index ON lecturer(department_id);

CREATE INDEX course_id_index ON course(course_id);

CREATE INDEX course_id_index ON course_student(course_id);
CREATE INDEX student_id_index ON course_student(student_id);
CREATE INDEX course_status_index ON course_student(course_status);
CREATE INDEX course_period_index ON course_student(course_period);

CREATE INDEX course_id_index ON course_syllabus(course_id);

CREATE INDEX course_id_index ON attendance(course_id);
CREATE INDEX student_id_index ON attendance(student_id);

CREATE INDEX course_id_index ON course_evaluation(course_id);
CREATE INDEX study_degree_id_index ON course_evaluation(study_degree_id);
 
CREATE INDEX course_id_index ON student_evaluation(course_id);
CREATE INDEX student_id_index ON student_evaluation(student_id);

CREATE INDEX student_id_index ON finance(student_id);
CREATE INDEX program_id_index ON finance(program_id);