--Создаю таблицу courses
CREATE TABLE courses(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	is_exam BOOL,
	min_grade INTEGER,
	max_grade INTEGER
);

--Создаю таблицу groups
CREATE TABLE groups(
	id SERIAL PRIMARY KEY,
	full_name VARCHAR(200),
	short_name VARCHAR(50),
	students_ids INTEGER[]
);

--Создаю таблицу students
CREATE TABLE students(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	group_id INTEGER
);

--Создаю таблицу machine_learning_course
CREATE TABLE machine_learning_course(
	student_id INTEGER REFERENCES students(id),
	grade INTEGER,
	grade_str VARCHAR(1));

--Заполняю таблицу courses
INSERT INTO courses(name, is_exam, min_grade, max_grade) VALUES
('Машинное обучение', true, 0, 100),
('Компьютерное зрение', true, 1, 5),
('Базы данных', true, 0, 100);

--Заполняю таблицу groups
INSERT INTO groups(full_name, short_name, students_ids) VALUES
('Искусственный интеллект и наука о данных', 'ИИНоД', '{1, 2, 3}'),
('Прикладная математика и информатика', 'ПМИ', '{4, 5, 6}');

--Заполняю таблицу students
INSERT INTO students(first_name, last_name, group_id) VALUES
('Николай', 'Григорьев', 1),
('Давид', 'Асатуров', 1),
('Вероника', 'Циунчик', 1),
('Егор', 'Ашхабеков', 2),
('Рина', 'Варламова', 2),
('София', 'Вилкова', 2);

--Заполняю таблицу machine_learning_course
INSERT INTO machine_learning_course(student_id, grade, grade_str) VALUES
(1, 86, 'B'),
(2, 100, 'A'),
(3, 72, 'C');

--Вывод таблицы machine_learning_course при альтернативном оценивании grade_str
SELECT
	student_id, grade,
	CASE
		WHEN grade >= 85 THEN 'A'
		WHEN grade >= 70 THEN 'B'
		WHEN grade >= 60 THEN 'C'
		WHEN grade >= 50 THEN 'D'
		ELSE 'F'
	END AS grade_str
FROM machine_learning_course LIMIT 5;

--Вывод среднего бала по дисциплине Машинное обучение
SELECT AVG(grade) FROM machine_learning_course;

--Вывод всех студентов ИИНОД
SELECT * FROM students WHERE group_id=1 LIMIT 5;

--Вывод всех студентов, фамилия которых начинается на букву 'А'
SELECT * FROM students WHERE last_name LIKE 'А%' LIMIT 5;

--Вывод сех студентов, у которых балл по Машинному обучению больше 80
SELECT * FROM machine_learning_course WHERE grade >= 80 LIMIT 5;