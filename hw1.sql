--Создаю таблицу courses
create table courses(
	id SERIAL primary key,
	name VARCHAR(50),
	is_exam BOOL,
	min_grade INTEGER,
	max_grade INTEGER
);

--Создаю таблицу groups
create table groups(
	id SERIAL primary key,
	full_name VARCHAR(200),
	short_name VARCHAR(50),
	students_ids INTEGER[]
);

--Создаю таблицу students
create table students(
	id SERIAL primary key,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	group_id INTEGER
);

--Создаю таблицу machine_learning_course
create table machine_learning_course(
	student_id INTEGER,
	grade INTEGER,
	grade_str VARCHAR(1));

--Заполняю таблицу courses
insert into courses(name, is_exam, min_grade, max_grade) values
('Машинное обучение', true, 0, 100),
('Компьютерное зрение', true, 1, 5),
('Базы данных', true, 0, 100);

--Заполняю таблицу groups
insert into groups(full_name, short_name, students_ids) values
('Искусственный интеллект и наука о данных', 'ИИНоД', '{1, 2, 3}'),
('Прикладная математика и информатика', 'ПМИ', '{4, 5, 6}');

--Заполняю таблицу students
insert into students(first_name, last_name, group_id) values
('Николай', 'Григорьев', 1),
('Давид', 'Асатуров', 1),
('Вероника', 'Циунчик', 1),
('Егор', 'Ашхабеков', 2),
('Рина', 'Варламова', 2),
('София', 'Вилкова', 2);

--Заполняю таблицу machine_learning_course
insert into machine_learning_course(student_id, grade, grade_str) values
(1, 86, 'B'),
(2, 100, 'A'),
(3, 72, 'C');

--Вывод таблицы machine_learning_course при альтернативном оценивании grade_str
select 
	student_id, grade,
	case
		when grade >= 85 then 'A'
		when grade >= 70 then 'B'
		when grade >= 60 then 'C'
		when grade >= 50 then 'D'
		else 'F'
	end as grade_str
from machine_learning_course;
	
--Вывод среднего бала по дисциплине Машинное обучение
select AVG(grade) from machine_learning_course;

--Вывод всех студентов ИИНОД
select * from students where group_id=1;

--Вывод всех студентов, фамилия которых начинается на букву 'А'
select * from students WHERE last_name like 'А%';

--Вывод сех студентов, у которых балл по Машинному обучению больше 80
select * from machine_learning_course where grade >= 80;
