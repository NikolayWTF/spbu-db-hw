--Домашнее задание №2

--Создаю промежуточную таблицу, связывающую студентов с курсами
CREATE TABLE student_courses(
	id SERIAL PRIMARY KEY,
	student_id INTEGER REFERENCES students(id),
	course_id  INTEGER REFERENCES courses(id),
	UNIQUE(student_id, course_id)
)


--Создаю промежуточную таблицу, связывающую группы с курсами
CREATE TABLE group_courses(
	id SERIAL PRIMARY KEY,
	group_id INTEGER REFERENCES groups(id),
	course_id  INTEGER REFERENCES courses(id),
	UNIQUE(group_id, course_id)
)


--Заполняю таблицу student_courses
INSERT INTO student_courses(student_id, course_id) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 2),
(6, 2),
(1, 3),
(2, 3),
(3, 3),
(4, 3),
(5, 3),
(6, 3);


--Заполняю таблицу group_courses
INSERT INTO group_courses(group_id, course_id) VALUES
(1, 1);


--Удаляю устаревшие поля с помощью ALTER TABLE
--Пока не понимаю какие поля следует удалять


--Добавляю в courses уникальность имени
ALTER TABLE courses
ADD UNIQUE(name);

--Создаю индекс на поле group_id в таблице students

--Индекс устанавливает соответствие между ключом и строками таблицы, в которых встречается этот ключ (ключ - id группы).
--Строки идентифицируются с помощью TID (tuple id). Поэтому зная ключ или некоторую информацию о нём, можно
--быстро прочитать нужные строки, не просматривая таблицу целиком
CREATE INDEX ON students(group_id)

--Запрос, показывающий список всех студентов с их курсами.
SELECT
    students.id AS student_id,
    students.first_name,
    students.last_name,
    courses.name AS course_name
FROM
    students
LEFT JOIN
    student_courses ON students.id = student_courses.student_id
LEFT JOIN
    courses ON student_courses.course_id = courses.id
   LIMIT 10;

 --Создаю таблицу data_base_courses
CREATE TABLE data_base_courses(
	student_id INTEGER REFERENCES students(id),
	grade INTEGER,
	grade_str VARCHAR(1));


--Заполняю таблицу data_base_courses
INSERT INTO data_base_courses(student_id, grade, grade_str) VALUES
(1, 81, 'B'),
(2, 72, 'C'),
(3, 92, 'A'),
(4, 67, 'D'),
(5, 78, 'C'),
(6, 91, 'A');

--Запрос, выводящий студентов, у которых средняя оценка по курсам выше, чем у любого другого студента в группе
WITH student_avg_grades AS (
    SELECT
        s.id AS student_id,
        s.group_id,
        AVG(grade) AS avg_grade
    FROM (
        SELECT
            student_id,
            grade
        FROM
            machine_learning_course
        UNION ALL
        SELECT
            student_id,
            grade
        FROM
            data_base_courses
    ) AS grades
    RIGHT JOIN
        students AS s ON s.id = grades.student_id
    GROUP BY
        s.id, s.group_id
)
SELECT
    s.student_id,
    st.first_name,
    st.last_name,
    s.group_id,
    s.avg_grade
FROM
    student_avg_grades AS s
JOIN
    students AS st ON s.student_id = st.id
WHERE
    s.avg_grade > ALL (
        SELECT
            other.avg_grade
        FROM
            student_avg_grades AS other
        WHERE
            other.group_id = s.group_id
            AND other.student_id != s.student_id
    )
   LIMIT 5;

--Запрос считающий количество студентов на каждом курсе
SELECT
    c.name AS course_name,
    COUNT(sc.student_id) AS student_count
FROM
    courses AS c
LEFT JOIN
    student_courses AS sc ON c.id = sc.course_id
GROUP BY
    c.name
LIMIT 10;


--Запрос находящий среднюю оценку на каждом курсе
SELECT
    course_name,
    AVG(grade) AS average_grade
FROM (
    SELECT
        'Машинное обучение' AS course_name,
        grade
    FROM
        machine_learning_course
    UNION ALL
    SELECT
        'Базы данных' AS course_name,
        grade
    FROM
        data_base_courses
) AS all_grades
GROUP BY
    course_name
LIMIT 10;