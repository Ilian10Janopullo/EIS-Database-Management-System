-- prints students information
SELECT s.student_name, s.student_surname, s.student_no, s.student_birthdate, s.student_birthplace, 
s.student_birthdate, s.student_gender, s.student_blood_group, s.student_marital_status,s.student_passport_number, 
s.student_id_card_number, s.student_primary_email, s.student_secondary_email, s.student_aptis, s.student_picture 
FROM student s
WHERE s.student_id = 1;

-- prints students family information
SELECT f.father_name, f.father_phone_nr, f.father_profession, f.mother_name, f.mother_phone_nr, f.mother_profession
FROM family f
INNER JOIN student s ON f.family_id = s.student_family_id
WHERE s.student_id = 1;

-- prints courses that are taken this semester
SELECT DISTINCT c.course_id, course_name, course_credits, course_ects, l.lecturer_name, cs.course_type
FROM course_student cs
INNER JOIN course_lecturer cl ON cs.course_id = cl.course_id
INNER JOIN student s ON cs.student_id = s.student_id
INNER JOIN course c ON c.course_id = cs.course_id
INNER JOIN lecturer l ON cl.lecturer_id = l.lecturer_id
WHERE cs.student_id = 1 AND cs.course_status = "Ongoing"
ORDER BY c.course_id;

-- prints information about the courses
SELECT DISTINCT cl.course_id, cl.lecturer_id, l.lecturer_name, sp.department_name, 
c.course_name, course_credits, course_ects, cs.course_description,course_objective,
course_basic_concepts,course_text_books,course_program
FROM course_lecturer cl
INNER JOIN course c ON c.course_id = cl.course_id
INNER JOIN course_syllabus cs ON c.course_id = cs.course_id
INNER JOIN lecturer l ON cl.lecturer_id = l.lecturer_id
INNER JOIN study_program sp ON sp.department_id = l.department_id 
WHERE c.course_id = "MTH207";

-- prints the information of a specific date of a course
SELECT DISTINCT c.course_id, a.week_of, a.topic, a.type_of, a.attended, a.hours_to_attend, a.date_of
FROM attendance a
LEFT JOIN course c ON c.course_id = a.course_id 
LEFT JOIN course_student cs ON c.course_id = cs.course_id
WHERE a.student_id = 1 AND cs.course_status = "Ongoing";


-- prints the attandace percentage of a student in courses that they are taking
SELECT c.course_id, c.course_name, ((SUM(a.attended)/SUM(a.hours_to_attend))*100) as attandance_percentage
FROM attendance a
INNER JOIN course c ON c.course_id = a.course_id
INNER JOIN course_student cs ON c.course_id = cs.course_id
WHERE a.student_id = 1 AND cs.course_status = "Ongoing"
GROUP BY a.course_id
ORDER BY a.course_id;

-- prints information about the debts of a student
SELECT s.student_name, sp.program_name, sp.tuition_fees, f.tuition_paid, (sp.tuition_fees - f.tuition_paid) AS debt
FROM finance f
LEFT JOIN student s ON s.student_id = f.student_id
LEFT JOIN study_program sp ON f.program_id = sp.program_id
LEFT JOIN transactions t ON f.student_id = t.student_id
WHERE f.student_id = 1;

-- prints information of all the transactions of a student
SELECT t.bank, t.account_name, t.account_currency, t.IBAN, t.SWIFT, t.description_of
FROM finance f
INNER JOIN transactions t ON t.student_id = f.student_id
WHERE t.student_id = 1;

-- first table of the transcript
SELECT s.student_name, student_surname, student_id, student_no, sp.faculty_name, department_name, program_name, degree_awarded
FROM student s
INNER JOIN study_program sp ON s.program_id = sp.program_id
WHERE s.student_id = 1;

-- prints information about the grades that a student has taken in his courses
SELECT c.course_id, c.course_name, se.quiz_grade, ce.quiz_evaluation 
AS Quiz_Weight, ((ce.quiz_evaluation / 100) * se.quiz_grade) AS Quiz_Perc, 
se.assignment_grade, ce.assignment_evaluation AS _Weight, ((ce.assignment_evaluation / 100) * se.assignment_grade) 
AS Assignment_Perc, se.participation_grade, ce.participation_evaluation AS Participation_Weight,
((ce.participation_evaluation / 100) * se.participation_grade) AS Participation_Perc, se.midterm_grade, ce.midterm_evaluation 
AS Midterm_Weight, ((ce.midterm_evaluation / 100) * se.midterm_grade) AS Midterm_Perc, se.final_grade, ce.final_evaluation AS 
Final_Weight, ((ce.final_evaluation / 100) * se.final_grade) AS Final_Perc, se.project_grade, ce.project_evaluation AS Project_Weight,
 ((ce.project_evaluation / 100) * se.project_grade) AS Project_Perc, se.research_paper_grade, ce.research_paper_evaluation AS 
 Research_Paper_Weight, ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade) AS Research_Paper_Perc, 
if(cs.course_status = "Taken",((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade), null) AS Final_Grade
FROM course_evaluation ce
INNER JOIN course c ON c.course_id = ce.course_id
INNER JOIN student s ON s.program_id= ce.study_degree_id
INNER JOIN course_student cs ON cs.course_id = ce.course_id AND cs.student_id = s.student_id
INNER JOIN student_evaluation se ON ce.course_id = se.course_id AND ce.study_degree_id = s.program_id
WHERE s.student_id = 1
ORDER BY cs.course_status;


-- second table of the transcript
SELECT 
	(SELECT 
	SUM(if(((ce.quiz_evaluation / 100) * se.quiz_grade) + (ce.assignment_evaluation / 100) * se.assignment_grade + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade) >= 90, 4*c.course_ects, 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) +
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>= 85, 3.5*c.course_ects, 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>= 80, 3*c.course_ects,
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) +
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>= 75, 2.5*c.course_ects,
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=70, 2*c.course_ects, 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=65, 1.5*c.course_ects,
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) +
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=60, 1*c.course_ects, 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) +
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=50, 0.5*c.course_ects, 0)))))))))
    /SUM(c.course_ects)
		FROM course_evaluation ce
		LEFT JOIN course c ON c.course_id = ce.course_id
		LEFT JOIN student s ON s.program_id= ce.study_degree_id
		LEFT JOIN course_student cs ON cs.course_id = ce.course_id AND cs.student_id = s.student_id
		LEFT JOIN student_evaluation se ON ce.course_id = se.course_id AND ce.study_degree_id = s.program_id
		WHERE s.student_id = 1 AND cs.course_status = "Taken"
        GROUP BY s.student_id) AS cgpa, s.student_enrollment_date, s.student_birthplace, s.student_citizenship, s.student_birthdate, f.father_name, f.mother_name, s.student_staus
FROM student s
INNER JOIN family f ON s.student_family_id = f.family_id
WHERE s.student_id = 1;

-- prints the information in the grey part of the transcript about the courses
SELECT cs.course_period AS Period, cs.course_id AS Course_Code, c.course_name AS Course_Title, c.course_credits 
AS Credits, c.course_ects AS ECTS, (SELECT (if(((ce.quiz_evaluation / 100) * se.quiz_grade) + 
(ce.assignment_evaluation / 100) * se.assignment_grade + ((ce.participation_evaluation / 100) * se.participation_grade) + 
((ce.midterm_evaluation / 100) * se.midterm_grade) + ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * 
se.project_grade) + ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade) >= 90, "AA", 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>= 85, "BA", 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) +
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>= 80, "BB",
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>= 75, "CB",
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) +
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) +
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=70, "CC", 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) +
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + ((ce.Research_Paper_evaluation / 100) * 
    se.Research_Paper_grade))>=65, "DC",
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=60, "DD", 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=50, "FD", "FF")))))))))
    FROM course_evaluation ce
		LEFT JOIN course c ON c.course_id = ce.course_id
		LEFT JOIN student s ON s.program_id= ce.study_degree_id
		LEFT JOIN course_student cs ON cs.course_id = ce.course_id AND cs.student_id = s.student_id
		LEFT JOIN student_evaluation se ON ce.course_id = se.course_id AND ce.study_degree_id = s.program_id
		WHERE s.student_id = 1 AND cs.course_status = "Taken") AS Grade
FROM course_student cs
INNER JOIN course c ON cs.course_id = c.course_id
INNER JOIN student s ON s.student_id = cs.student_id
WHERE s.student_id = 1 AND cs.course_status = "Taken"
ORDER BY cs.course_period AND cs.course_id; 

-- prints the information in the grey part of the transcript all courses combined about all ects, cts...
SELECT SUM(if(((ce.quiz_evaluation / 100) * se.quiz_grade) + (ce.assignment_evaluation / 100) * se.assignment_grade + 
((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + ((ce.Research_Paper_evaluation / 100) * 
se.Research_Paper_grade) >= 60 , c.course_credits, 0)) AS Cr_Att, SUM(c.course_credits) AS Credits_Comp, SUM(if(((ce.quiz_evaluation / 100) * se.quiz_grade) + 
(ce.assignment_evaluation / 100) * se.assignment_grade + ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * 
se.midterm_grade) + ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + ((ce.Research_Paper_evaluation / 100) * 
se.Research_Paper_grade) >= 60 , c.course_ects, 0)) AS ECTS_Att, SUM(c.course_ects) AS ECTS_Comp, 
	
    SUM(if(((ce.quiz_evaluation / 100) * se.quiz_grade) + (ce.assignment_evaluation / 100) * se.assignment_grade + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade) >= 90, 4*c.course_ects, 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>= 85, 3.5*c.course_ects, 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>= 80, 3*c.course_ects,
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) +
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>= 75, 2.5*c.course_ects,
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) +
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) +
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=70, 2*c.course_ects, 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=65, 1.5*c.course_ects,
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=60, 1*c.course_ects, 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) +
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=50, 0.5*c.course_ects, 0))))))))) AS Gr_Pts,
    
	SUM(if(((ce.quiz_evaluation / 100) * se.quiz_grade) + (ce.assignment_evaluation / 100) * se.assignment_grade +
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) +
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade) >= 90, 4*c.course_ects, 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>= 85, 3.5*c.course_ects, 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>= 80, 3*c.course_ects,
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>= 75, 2.5*c.course_ects,
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=70, 2*c.course_ects, 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=65, 1.5*c.course_ects,
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=60, 1*c.course_ects, 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=50, 0.5*c.course_ects, 0)))))))))
    /SUM(c.course_ects) AS CGPA 
	FROM course_evaluation ce
	LEFT JOIN course c ON c.course_id = ce.course_id
	LEFT JOIN student s ON s.program_id= ce.study_degree_id
	LEFT JOIN course_student cs ON cs.course_id = ce.course_id AND cs.student_id = s.student_id
	LEFT JOIN student_evaluation se ON ce.course_id = se.course_id AND ce.study_degree_id = s.program_id
	WHERE s.student_id = 1 AND cs.course_status = "Taken"
	GROUP BY s.student_id;

-- what the query above does but for seperate semesters
SELECT cs.course_period, SUM(if(((ce.quiz_evaluation / 100) * se.quiz_grade) + (ce.assignment_evaluation / 100) * 
se.assignment_grade + ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) 
* se.midterm_grade) + ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade)
 + ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade) >= 60 , c.course_credits, 0)) AS Cr_Att, SUM(c.course_credits) 
 AS Credits_Comp, SUM(if(((ce.quiz_evaluation / 100) * se.quiz_grade) + (ce.assignment_evaluation / 100) * se.assignment_grade + 
 ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
 ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + ((ce.Research_Paper_evaluation / 100) * 
 se.Research_Paper_grade) >= 60 , c.course_ects, 0)) AS ECTS_Att, SUM(c.course_ects) AS ECTS_Comp, 
	
	SUM(if(((ce.quiz_evaluation / 100) * se.quiz_grade) + (ce.assignment_evaluation / 100) * se.assignment_grade + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade) >= 90, 4*c.course_ects, 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>= 85, 3.5*c.course_ects, 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>= 80, 3*c.course_ects,
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>= 75, 2.5*c.course_ects,
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) +
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) +
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=70, 2*c.course_ects, 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) +
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=65, 1.5*c.course_ects,
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) +
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=60, 1*c.course_ects, 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=50, 0.5*c.course_ects, 0))))))))) AS Gr_Pts,
    
    SUM(if(((ce.quiz_evaluation / 100) * se.quiz_grade) + (ce.assignment_evaluation / 100) * se.assignment_grade + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) +
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade) >= 90, 4*c.course_ects, 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>= 85, 3.5*c.course_ects, 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>= 80, 3*c.course_ects,
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) +
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) +
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>= 75, 2.5*c.course_ects,
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=70, 2*c.course_ects, 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) +
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=65, 1.5*c.course_ects,
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) +
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=60, 1*c.course_ects, 
    if((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * se.assignment_grade) + 
    ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + 
    ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + 
    ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))>=50, 0.5*c.course_ects, 0)))))))))
    /SUM(c.course_ects) AS CGPA 
	FROM course_evaluation ce
	LEFT JOIN course c ON c.course_id = ce.course_id
	LEFT JOIN student s ON s.program_id= ce.study_degree_id
	LEFT JOIN course_student cs ON cs.course_id = ce.course_id AND cs.student_id = s.student_id
	LEFT JOIN student_evaluation se ON ce.course_id = se.course_id AND ce.study_degree_id = s.program_id
	WHERE s.student_id = 1 AND cs.course_status = "Taken"
	GROUP BY cs.course_period
    ORDER BY cs.course_period;

-- shows information for a lecturer and his office
SELECT l.lecturer_name, b.building_name, b.class_name, l.lecture_office_hours 
FROM building b
INNER JOIN lecturer l ON b.class_name = l.lecturer_office
WHERE l.lecturer_name = "Sabrina Begaj";

-- shows all the lecturers in teh same office
SELECT l.lecturer_name, b.building_name, b.class_name, l.lecture_office_hours 
FROM building b
INNER JOIN lecturer l ON b.class_name = l.lecturer_office
WHERE b.class_name = "E002";

-- shows information about classes that are used for seminars and lessons
SELECT b.building_name, b.class_name, b.class_type, b.nr_of_places, FLOOR(b.nr_of_places/2) AS nr_of_places_exam
FROM building b
WHERE b.class_type != "Office";

-- prints the number of students in courses related to a specific degree on courses that are Ongoing
SELECT cs.course_id, c.course_name, COUNT(s.student_id) AS nr_of_students
FROM course_student cs
INNER JOIN course c ON c.course_id = cs.course_id
INNER JOIN student s ON s.student_id = cs.student_id
INNER JOIN study_program sp ON sp.program_id = s.program_id
WHERE cs.course_status = "Ongoing" AND sp.program_name = "CEN"
GROUP BY cs.course_id
ORDER BY cs.course_id;

-- prints the number of active students in each study program
SELECT sp.program_name, COUNT(distinct s.student_id) AS nr_of_students
FROM course_student cs
INNER JOIN course c ON c.course_id = cs.course_id
INNER JOIN student s ON s.student_id = cs.student_id
INNER JOIN study_program sp ON sp.program_id = s.program_id
WHERE cs.course_status = "Ongoing"
GROUP BY sp.program_name
ORDER BY sp.program_name;

-- prints the number of active students in each department
SELECT sp.department_name, COUNT(distinct s.student_id) AS nr_of_students
FROM course_student cs
INNER JOIN course c ON c.course_id = cs.course_id
INNER JOIN student s ON s.student_id = cs.student_id
INNER JOIN study_program sp ON sp.program_id = s.program_id
WHERE cs.course_status = "Ongoing"
GROUP BY sp.department_name
ORDER BY sp.department_name;

-- prints the number of active students in each faculty
SELECT  sp.faculty_name, COUNT(distinct s.student_id) AS nr_of_students
FROM course_student cs
INNER JOIN course c ON c.course_id = cs.course_id
INNER JOIN student s ON s.student_id = cs.student_id
INNER JOIN study_program sp ON sp.program_id = s.program_id
WHERE cs.course_status = "Ongoing"
GROUP BY sp.faculty_name
ORDER BY sp.faculty_name;

-- shows class average of the courses in a specific program id that has been taken in a specific time
SELECT cs.course_period, cs.course_id, c.course_name, AVG((((ce.quiz_evaluation / 100) * se.quiz_grade) +
 ((ce.assignment_evaluation / 100) * se.assignment_grade) + ((ce.participation_evaluation / 100) * se.participation_grade) + 
 ((ce.midterm_evaluation / 100) * se.midterm_grade) + ((ce.final_evaluation / 100) * se.final_grade) + 
 ((ce.project_evaluation / 100) * se.project_grade) + ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))) AS class_avg
FROM course_student cs
INNER JOIN course c ON cs.course_id = c.course_id
INNER JOIN course_evaluation ce ON ce.course_id = cs.course_id
INNER JOIN student_evaluation se ON se.course_id = cs.course_id AND se.student_id = cs.student_id
INNER JOIN study_program sp ON sp.program_id = ce.study_degree_id 
WHERE sp.program_name = "CEN" AND cs.course_period = "2022-2023 spring"
GROUP BY cs.course_id
ORDER BY cs.course_id;

-- shows class average of the courses in a specific program id that are being taken
SELECT cs.course_id, c.course_name, AVG((((ce.quiz_evaluation / 100) * se.quiz_grade) + 
((ce.assignment_evaluation / 100) * se.assignment_grade) + ((ce.participation_evaluation / 100) * se.participation_grade) + 
((ce.midterm_evaluation / 100) * se.midterm_grade) + ((ce.final_evaluation / 100) * se.final_grade) + 
((ce.project_evaluation / 100) * se.project_grade) + ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))) AS class_avg
FROM course_student cs
INNER JOIN course c ON cs.course_id = c.course_id
INNER JOIN course_evaluation ce ON ce.course_id = cs.course_id
INNER JOIN student_evaluation se ON se.course_id = cs.course_id AND se.student_id = cs.student_id
INNER JOIN study_program sp ON sp.program_id = ce.study_degree_id 
WHERE cs.course_status = "Ongoing" AND sp.program_name = "SWE"
GROUP BY cs.course_id
ORDER BY cs.course_id;

-- shows the avergae of the students in each study program
SELECT sp.program_name, AVG((((ce.quiz_evaluation / 100) * se.quiz_grade) + 
((ce.assignment_evaluation / 100) * se.assignment_grade) + ((ce.participation_evaluation / 100) * 
se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + ((ce.final_evaluation / 100) *
 se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + ((ce.Research_Paper_evaluation / 100) * 
 se.Research_Paper_grade))) AS class_avg
FROM course_student cs
INNER JOIN course c ON cs.course_id = c.course_id
INNER JOIN course_evaluation ce ON ce.course_id = cs.course_id
INNER JOIN student_evaluation se ON se.course_id = cs.course_id AND se.student_id = cs.student_id
INNER JOIN study_program sp ON sp.program_id = ce.study_degree_id 
INNER JOIN student s ON cs.student_id = s.student_id
WHERE s.student_staus = "Current Student"
GROUP BY sp.program_name
ORDER BY sp.program_name;

-- shows the avergae of the students in each department
SELECT sp.department_name, AVG((((ce.quiz_evaluation / 100) * se.quiz_grade) + ((ce.assignment_evaluation / 100) * 
se.assignment_grade) + ((ce.participation_evaluation / 100) * se.participation_grade) + ((ce.midterm_evaluation / 100)
 * se.midterm_grade) + ((ce.final_evaluation / 100) * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) 
 + ((ce.Research_Paper_evaluation / 100) * se.Research_Paper_grade))) AS class_avg
FROM course_student cs
INNER JOIN course c ON cs.course_id = c.course_id
INNER JOIN course_evaluation ce ON ce.course_id = cs.course_id
INNER JOIN student_evaluation se ON se.course_id = cs.course_id AND se.student_id = cs.student_id
INNER JOIN study_program sp ON sp.program_id = ce.study_degree_id 
INNER JOIN student s ON cs.student_id = s.student_id
WHERE s.student_staus = "Current Student"
GROUP BY sp.department_name
ORDER BY sp.department_name;

-- shows the avergae of the students in each faculty
SELECT sp.faculty_name, AVG((((ce.quiz_evaluation / 100) * se.quiz_grade)
 + ((ce.assignment_evaluation / 100) * se.assignment_grade) + ((ce.participation_evaluation / 100)
 * se.participation_grade) + ((ce.midterm_evaluation / 100) * se.midterm_grade) + ((ce.final_evaluation / 100) 
 * se.final_grade) + ((ce.project_evaluation / 100) * se.project_grade) + ((ce.Research_Paper_evaluation / 100) * 
 se.Research_Paper_grade))) AS class_avg
FROM course_student cs
INNER JOIN course c ON cs.course_id = c.course_id
INNER JOIN course_evaluation ce ON ce.course_id = cs.course_id
INNER JOIN student_evaluation se ON se.course_id = cs.course_id AND se.student_id = cs.student_id
INNER JOIN study_program sp ON sp.program_id = ce.study_degree_id 
INNER JOIN student s ON cs.student_id = s.student_id
WHERE s.student_staus = "Current Student"
GROUP BY sp.faculty_name
ORDER BY sp.faculty_name;

-- prints nr of lecturers for each study program
SELECT sp.program_name,  COUNT(l.lecturer_id) AS nr_of_lecturers
FROM lecturer l
INNER JOIN courSE_lecturer cl ON cl.lecturer_id = l.lecturer_id
INNER JOIN course_student cs ON cl.course_id = cs.course_id
INNER JOIN study_program sp ON sp.program_id = cl.program_id
WHERE cs.course_status = "Ongoing"
GROUP BY sp.program_name
ORDER BY sp.program_name;

-- prints nr of lecturers for each department
SELECT sp.department_name, COUNT(DISTINCT l.lecturer_id) AS nr_of_lecturers
FROM lecturer l
LEFT JOIN study_program sp ON sp.department_id = l.department_id
GROUP BY sp.department_name
ORDER BY sp.department_name;


-- prints nr of lecturers for each faculty
SELECT sp.faculty_name, COUNT(DISTINCT l.lecturer_id) AS nr_of_lecturers
FROM lecturer l
INNER JOIN study_program sp ON sp.department_id = l.department_id
GROUP BY sp.faculty_name
ORDER BY sp.faculty_name;