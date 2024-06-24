

```mermaid
erDiagram
    COURSE {
        int course_id PK
        string course_name
        float course_cost
        float professor_pay
    }
    
    PERSON {
        int person_id PK
        string first_name
        string last_name
        date date_of_birth
        string bank_account
        string national_id`
    }
    
    STUDENT {
        int student_id PK
        int person_id FK
        string student_number
        date enrollment_date
    }
    
    PROFESSOR {
        int professor_id PK
        int person_id FK
        string employee_number
        date hire_date
        float salary
    }
    
    STUDENT_COURSE {
        int student_id PK, FK
        int course_id PK, FK
        date signup_date
    }
    
    BANK_TRANSFER {
        int transfer_id PK
        int person_id
        float amount
        date transfer_date
        string description
        boolean incoming
    }
    
    PROFESSOR_COURSE {
        int professor_id PK, FK
        int course_id PK, FK
        int weekly_hours
    }

    PERSON ||--o{ STUDENT: inherits
    PERSON ||--o{ PROFESSOR: inherits
    PERSON ||--o{ BANK_TRANSFER: pays
    STUDENT ||--o{ STUDENT_COURSE: takes
    COURSE ||--o{ STUDENT_COURSE: includes
    COURSE ||--o{ PROFESSOR_COURSE: includes
    PROFESSOR ||--o{ PROFESSOR_COURSE: teaches
```


# Tables

- Course description: Professor salary, student cost
- Person: id, name
- Professor: department, tenure
- Student: College, Year
- Student sign ups: bank transfers from students for specific courses
- bank transfers
- Professor courses

```
I want to design a database for an accounting department of a university. I would like to make the following tables. 
1) a table which describes information about courses, how much they cost and how much a professor get's paid for teaching it. 
2) a table which describes a person (which includes a bank account and a national id)
3) a table which describes a student (which inherits a person)
4) a table which describes a professor (which inherits a person)
5) a table which describes a student taking a course (which includes the date he signed up and to which course)
6) a table which describes a bank transfer either from the university or to (based on a boolean value)
7) a table which describes a professor teaching a course (and how many weekly hours he teaches it)
feel free to add columns to make the tables more interesting, and please output the design in mermaid format
```


