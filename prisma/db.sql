-- Create enums
CREATE TYPE "UserSex" AS ENUM ('MALE', 'FEMALE');
CREATE TYPE "Day" AS ENUM ('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY');

-- Create tables
CREATE TABLE "Admin" (
  "id" TEXT NOT NULL,
  "username" TEXT NOT NULL,
  PRIMARY KEY ("id"),
  UNIQUE ("username")
);

CREATE TABLE "Grade" (
  "id" SERIAL NOT NULL,
  "level" INTEGER NOT NULL,
  PRIMARY KEY ("id"),
  UNIQUE ("level")
);

CREATE TABLE "Subject" (
  "id" SERIAL NOT NULL,
  "name" TEXT NOT NULL,
  PRIMARY KEY ("id"),
  UNIQUE ("name")
);

CREATE TABLE "Parent" (
  "id" TEXT NOT NULL,
  "username" TEXT NOT NULL,
  "name" TEXT NOT NULL,
  "surname" TEXT NOT NULL,
  "email" TEXT UNIQUE,
  "phone" TEXT NOT NULL UNIQUE,
  "address" TEXT NOT NULL,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("id"),
  UNIQUE ("username")
);

CREATE TABLE "Teacher" (
  "id" TEXT NOT NULL,
  "username" TEXT NOT NULL,
  "name" TEXT NOT NULL,
  "surname" TEXT NOT NULL,
  "email" TEXT UNIQUE,
  "phone" TEXT UNIQUE,
  "address" TEXT NOT NULL,
  "img" TEXT,
  "bloodType" TEXT NOT NULL,
  "sex" "UserSex" NOT NULL,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "birthday" TIMESTAMP(3) NOT NULL,
  PRIMARY KEY ("id"),
  UNIQUE ("username")
);

CREATE TABLE "Class" (
  "id" SERIAL NOT NULL,
  "name" TEXT NOT NULL,
  "capacity" INTEGER NOT NULL,
  "supervisorId" TEXT,
  "gradeId" INTEGER NOT NULL,
  PRIMARY KEY ("id"),
  UNIQUE ("name"),
  FOREIGN KEY ("supervisorId") REFERENCES "Teacher"("id"),
  FOREIGN KEY ("gradeId") REFERENCES "Grade"("id")
);

CREATE TABLE "Student" (
  "id" TEXT NOT NULL,
  "username" TEXT NOT NULL,
  "name" TEXT NOT NULL,
  "surname" TEXT NOT NULL,
  "email" TEXT UNIQUE,
  "phone" TEXT UNIQUE,
  "address" TEXT NOT NULL,
  "img" TEXT,
  "bloodType" TEXT NOT NULL,
  "sex" "UserSex" NOT NULL,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "parentId" TEXT NOT NULL,
  "classId" INTEGER NOT NULL,
  "gradeId" INTEGER NOT NULL,
  "birthday" TIMESTAMP(3) NOT NULL,
  PRIMARY KEY ("id"),
  UNIQUE ("username"),
  FOREIGN KEY ("parentId") REFERENCES "Parent"("id"),
  FOREIGN KEY ("classId") REFERENCES "Class"("id"),
  FOREIGN KEY ("gradeId") REFERENCES "Grade"("id")
);

CREATE TABLE "Lesson" (
  "id" SERIAL NOT NULL,
  "name" TEXT NOT NULL,
  "day" "Day" NOT NULL,
  "startTime" TIMESTAMP(3) NOT NULL,
  "endTime" TIMESTAMP(3) NOT NULL,
  "subjectId" INTEGER NOT NULL,
  "classId" INTEGER NOT NULL,
  "teacherId" TEXT NOT NULL,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("subjectId") REFERENCES "Subject"("id"),
  FOREIGN KEY ("classId") REFERENCES "Class"("id"),
  FOREIGN KEY ("teacherId") REFERENCES "Teacher"("id")
);

CREATE TABLE "Exam" (
  "id" SERIAL NOT NULL,
  "title" TEXT NOT NULL,
  "startTime" TIMESTAMP(3) NOT NULL,
  "endTime" TIMESTAMP(3) NOT NULL,
  "lessonId" INTEGER NOT NULL,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("lessonId") REFERENCES "Lesson"("id")
);

CREATE TABLE "Assignment" (
  "id" SERIAL NOT NULL,
  "title" TEXT NOT NULL,
  "startDate" TIMESTAMP(3) NOT NULL,
  "dueDate" TIMESTAMP(3) NOT NULL,
  "lessonId" INTEGER NOT NULL,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("lessonId") REFERENCES "Lesson"("id")
);

CREATE TABLE "Result" (
  "id" SERIAL NOT NULL,
  "score" INTEGER NOT NULL,
  "examId" INTEGER,
  "assignmentId" INTEGER,
  "studentId" TEXT NOT NULL,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("examId") REFERENCES "Exam"("id"),
  FOREIGN KEY ("assignmentId") REFERENCES "Assignment"("id"),
  FOREIGN KEY ("studentId") REFERENCES "Student"("id")
);

CREATE TABLE "Attendance" (
  "id" SERIAL NOT NULL,
  "date" TIMESTAMP(3) NOT NULL,
  "present" BOOLEAN NOT NULL,
  "studentId" TEXT NOT NULL,
  "lessonId" INTEGER NOT NULL,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("studentId") REFERENCES "Student"("id"),
  FOREIGN KEY ("lessonId") REFERENCES "Lesson"("id")
);

CREATE TABLE "Event" (
  "id" SERIAL NOT NULL,
  "title" TEXT NOT NULL,
  "description" TEXT NOT NULL,
  "startTime" TIMESTAMP(3) NOT NULL,
  "endTime" TIMESTAMP(3) NOT NULL,
  "classId" INTEGER,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("classId") REFERENCES "Class"("id")
);

CREATE TABLE "Announcement" (
  "id" SERIAL NOT NULL,
  "title" TEXT NOT NULL,
  "description" TEXT NOT NULL,
  "date" TIMESTAMP(3) NOT NULL,
  "classId" INTEGER,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("classId") REFERENCES "Class"("id")
);

-- Create many-to-many relations
CREATE TABLE "_SubjectToTeacher" (
  "A" INTEGER NOT NULL,
  "B" TEXT NOT NULL,
  UNIQUE ("A", "B"),
  FOREIGN KEY ("A") REFERENCES "Subject"("id"),
  FOREIGN KEY ("B") REFERENCES "Teacher"("id")
);

CREATE INDEX "_SubjectToTeacher_B_index" ON "_SubjectToTeacher"("B");
