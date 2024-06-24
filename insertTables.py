from faker import Faker
import random

departments = [
    "Accounting", "Aerospace Engineering", "Agriculture", "Anthropology", "Applied Mathematics",
    "Architecture", "Art History", "Astronomy", "Biochemistry", "Biology", "Biomedical Engineering",
    "Business Administration", "Chemical Engineering", "Chemistry", "Civil Engineering", "Classics",
    "Communication", "Computer Science", "Criminal Justice", "Cultural Studies", "Dance", "Dentistry",
    "Design", "Earth Sciences", "Ecology", "Economics", "Education", "Electrical Engineering",
    "English", "Environmental Science", "Film Studies", "Finance", "Fine Arts", "Forestry", "Geography",
    "Geology", "Health Sciences", "History", "Hospitality Management", "Human Resources", "Industrial Engineering",
    "Information Technology", "International Relations", "Journalism", "Law", "Library Science", "Linguistics",
    "Management", "Marketing", "Materials Science", "Mathematics", "Mechanical Engineering", "Medicine",
    "Microbiology", "Music", "Neuroscience", "Nursing", "Nutrition", "Occupational Therapy", "Pharmacy",
    "Philosophy", "Physics", "Political Science", "Psychology", "Public Administration", "Public Health",
    "Religious Studies", "Robotics", "Social Work", "Sociology", "Software Engineering", "Special Education",
    "Speech Pathology", "Sports Management", "Statistics", "Supply Chain Management", "Sustainability Studies",
    "Theatre", "Urban Planning", "Veterinary Medicine", "Visual Arts", "Women's Studies", "Zoology",
    "Bioinformatics", "Biotechnology", "Cognitive Science", "Data Science", "Ethnic Studies", "Forensic Science",
    "Genetics", "Gerontology", "Horticulture", "Human Development", "Marine Biology", "Meteorology",
    "Public Policy", "Renewable Energy", "Seismology", "Systems Engineering", "Toxicology", "Transportation Engineering"
]

majors = ["Arts", "Science", "Fine Arts", "Business Administration", "Engineering", "Architecture", "Education", 
           "Music", "Laws", "Medicine", "Dental Surgery", "Pharmacy", "Nursing", "Social Work", "Computer Science", 
           "Information Technology", "Public Health", "Environmental Science", "Psychology", "Communication", 
           "Design", "Hospitality Management", "International Relations", "Journalism", "Liberal Arts", 
           "Sports Management", "Urban Planning", "Veterinary Science", "Biotechnology", "Data Science"]

fake = Faker()

LEN_LISTS = 400
STUDENTS_PRECENTAGE = 0.8

person_ids = list(range(LEN_LISTS))
course_ids = list(range(LEN_LISTS))

sqls = list()

# Generate and print SQL statements for STUDENT table
student_ids = random.sample(person_ids, int(LEN_LISTS * STUDENTS_PRECENTAGE))
for student_id in student_ids:
    enrollment_date = fake.date_between(start_date='-4y', end_date='today')
    major = random.choice(majors)
    sql = f"""INSERT INTO STUDENT (person_id, enrollment_date, major) VALUES ({student_id}, '{enrollment_date}', '{major}');"""
    print(sql)
    sqls.append(sql)

# Generate and print SQL statements for PROFESSOR table
professor_ids = [pid for pid in person_ids if pid not in student_ids]
for professor_id in professor_ids:
    hire_date = fake.date_between(start_date='-10y', end_date='today')
    department = random.choice(departments)
    sql = f"""INSERT INTO PROFESSOR (person_id, hire_date, department) VALUES ({professor_id}, '{hire_date}', '{department}');"""
    print(sql)
    sqls.append(sql)


# Generate and print SQL statements for STUDENT_COURSE table
for student_id in student_ids:
    for _ in range(random.randint(1, 5)):  # each student enrolls in 1 to 5 courses
        course_id = random.choice(course_ids)
        signup_date = fake.date_between(start_date='-4y', end_date='today')
        sql = f""" INSERT INTO STUDENT_COURSE (student_id, course_id, signup_date) VALUES ({student_id}, {course_id}, '{signup_date}');"""
        print(sql)
        sqls.append(sql)


# Generate and print SQL statements for PROFESSOR_COURSE table
for professor_id in professor_ids:
    for _ in range(random.randint(1, 3)):  # each professor teaches 1 to 3 courses
        course_id = random.choice(course_ids)
        weekly_hours = random.randint(1, 10)
        sql = f""" INSERT INTO PROFESSOR_COURSE (professor_id, course_id, weekly_hours) VALUES ({professor_id}, {course_id}, {weekly_hours});"""
        print(sql)
        sqls.append(sql)


with open("sqls_python_output.txt", 'w') as file:
    file.write('\n'.join(sqls))