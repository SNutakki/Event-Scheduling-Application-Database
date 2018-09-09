/* -------------------- Queries -------------------- */

/* Primary author: Sashank Nutakki */
/* returns the names and usernames of everyone attending a particular event */
SELECT P.real_name, P.username
FROM Person P, Event E, Attending A
WHERE P.username = A.username
AND A.event_id = E.event_id
AND E.event_id = 'event1002';

/* Primary author: Sashank Nutakki */
/* returns the majors and number of students in each major who have taken or
are taking a particular course, where the number of students who have taken
the course in question exceeds 1 */
SELECT S.major, COUNT(DISTINCT S.student_id)
FROM Student S, CourseTaken CT, Course C
WHERE S.student_ID = CT.student_ID
AND CT.course_ID = C.course_ID
AND C.course_ID = 'course1001'
GROUP BY (S.major)
HAVING COUNT(S.student_id) > 1;

/* Primary author: Sashank Nutakki */
/* returns all first year undergraduates who are members within an organization */
SELECT O.username, O.email
FROM Student S, OrgMembers O
WHERE S.username = O.username
AND S.is_graduate_student IS 'FALSE'
AND S.current_year = 1;

/* Primary author: Bowen Jin */
/* returns all graduated students within majors currently having
fewer than 20 students */
SELECT GS.username, GS.major
FROM GraduatedStudents GS
GROUP BY GS.major
HAVING COUNT(GS.student_id) < 20;

/* Primary author: Sidhanth Panjwani */
/* returns all the personal events of a user */
SELECT Event.event_name, Event.description, Event.start_time, Event.end_time, Event.event_date
FROM Event NATURAL JOIN PersonalEvent NATURAL JOIN Attending
WHERE Attending.username = 'ben_user';



/* Primary author: David Liao */
/* returns all personal events of a user’s friend */
SELECT PE.event_id, E.event_name
FROM Event E, PersonalEvent PE, Friend F, Attending A
WHERE F.friend1 = 'amy_user'
AND F.friend2 = 'ben_user'
AND F.can_access_personal_sch IS 'TRUE'
AND PE.event_id = E.event_id
AND E.event_id = A.event_id
AND F.friend2 = A.username;

/* Primary author: Bowen Jin */
/* returns all members of a particular organization */
SELECT username, email
FROM OrgMembers
WHERE organization_name = 'DBMS appreciation club';

/* Primary author: Sid Panjwani */
/* returns the student IDs of all students who currently share at least one
class with a particular student*/
SELECT DISTINCT CT2.student_id
FROM CourseTaken CT1, CourseTaken CT2
WHERE CT1.student_id = 'dom_student1001'
AND CT1.student_id <> CT2.student_id
AND CT1.course_id = CT2.course_id
AND CT1.year = CT2.year
AND CT1.semester = CT2.semester
AND CT1.section = CT2.section
AND CT1.is_completed IS 'FALSE';

/* returns the course ID, course description, and number of students who have
taken or are currently enrolled in a particular course*/
/* Primary author: David Liao */

SELECT CT.course_id, C.description, COUNT(CT.student_id)
FROM Course C, CourseTaken CT, Student S
WHERE CT.student_id = S.student_id
AND C.course_id = CT.course_id
GROUP BY CT.course_id
HAVING COUNT(CT.student_ID) > 1;









/* students graduated per year ordered in descending order */
/* Primary Author: Sid Panjwani */

SELECT expected_date_of_graduation, count(*)
FROM Student
GROUP BY expected_date_of_graduation
ORDER BY expected_date_of_graduation DESC;

/* number of students per major in descending order */
/* Primary Author: Sid Panjwani */

SELECT major, count(*)
FROM Student
GROUP BY major
ORDER BY major DESC;

/* allows a particular student to see alumni who graduated with the same major with email & date graduated */
/*Primary Author: Sid Panjwani */

SELECT P.real_name, U.email, GS.expected_date_of_graduation as year_graduated
FROM Student S, GraduatedStudents GS, Person P, User U
WHERE S.student_id = 'ben_student1001' AND P.username = GS.username and U.username = P.username AND S.major = GS.major;

/* get all classes with more than 5 graduate students */
/* Primary Author: Sashank Nutakki */

SELECT C.course_ID, C.description, C.credit_hours, COUNT(S.student_id) as gradCount
FROM Course C, Student S, CourseTaken CT
WHERE S.is_graduate_student = 'TRUE' AND CT.course_id = C.course_id AND S.student_id = CT.student_id
GROUP BY C.course_id
HAVING gradCount >= 5;

/* get all friends of specific user attending a specific event */
/* Primary Author: Bowen Jin */

SELECT P2.real_name
FROM Friend F, Person P1, Person P2, Attending A1, Attending A2
WHERE P1.username = 'amy_user' AND F.friend1 = P1.username AND F.friend2 = P2.username AND A1.username = P1.username AND A2.username = P2.username AND A1.event_id = 'event1001' AND A1.event_id = A2.event_id;

/* get all organization events occurring on a specific date for organizations a specific user is registered for */
/* Primary Author: David Liao */

SELECT E.event_name, E.description, E.start_time, E.end_time
FROM Person P, OrganizationEvent OE, Event E
WHERE P.username = 'earl_user' AND E.event_date = '01/10/2020' AND OE.event_id = E.event_id;

/* get all classes with 5 or more students who have taken it */
/* Primary Author: Sid Panjwani */

SELECT C.course_id, C.description, COUNT(*)
FROM Course C, CourseTaken CT
WHERE C.course_id = CT.course_id
GROUP BY CT.course_id
HAVING COUNT(*) >= 5;

/* get all personal and organization events in a specific schedule of current user*/
/* Primary Author: Sid Panjwani */

SELECT P.event_id, O.event_id
FROM PersonalEvent P, OrganizationEvent O, Person P, Attending A
WHERE P.username = "amy_user" AND A.username = P.username AND A.event_id = P.event_id OR A.event_id = O.event_id;

/* get all personal events of a user’s friend */
/* Primary author: Bowen Jin*/

SELECT PersonalEvent.event_id
FROM Event,PersonalEvent,Friend
WHERE Friend.friend2 = 'amy_user'
AND Friend.friend1 = 'ben_user'
AND Friend.can_access_personal_sch = 'TRUE'
AND PersonalEvent.event_creator = Friend.friend1
AND PersonalEvent.event_id = Event.event_id;
/* returns the usernames, names, and departments of all currently enrolled students who are TAs */
/* Primary author: David Liao */








/* returns the usernames, names, and departments of all currently enrolled students who are TAs */
/* Primary author: David Liao */

SELECT P.username, P.real_name, F.department
FROM Person P, Student S, Faculty F
WHERE P.username = S.username
AND S.username = F.username
AND S.has_graduated = 'FALSE'
ORDER BY ASC;

/* get all people that are invited to an event */
/*Primary author: David Liao */

SELECT Person.real_name
FROM Person NATURAL JOIN PersonalEventInvitation NATURAL JOIN PersonalEvent WHERE PersonalEvent.event_id = 'event1001';

/* deletes an event when the corresponding personal event is deleted */
/*Primary author: Sid Panjwani */

CREATE TRIGGER DeleteEvent  AFTER DELETE ON PersonalEvent REFERENCING OLD AS DeletedEvent BEGIN DELETE FROM Event WHERE event_id = DeletedEvent.event_id;
END;

/* registers all currently enrolled graduate students as TAs within the department
having the same name as their major */
/* Primary author: David Liao*/

INSERT INTO Faculty(username, faculty_id, department)
SELECT S.username, S.student_id, S.major
FROM Student S
WHERE S.is_graduate_student IS 'TRUE'
AND S.has_graduated IS 'FALSE'

/* following these two delete statements, course with ID 'course1001' should be deleted
from table Course */
/* Primary author: David Liao */

DELETE FROM Student
WHERE student_id = 'earl_student1001'

DELETE FROM Student
WHERE student_id = 'faye_student1001'

/* insert an event to the persons events when they are invited */
/*Primary author: Bowen Jin*/
CREATE TRIGGER InvitedToEvent
AFTER INSERT ON
PersonalEventInvitation 
BEGIN
INSERT INTO PersonalEvent VALUES(InsertedInvitation.event_id, InsertedInvitation.username);
END;

/* If a student is deleted from Student, then if this was the only student associated
with a course from CourseTaken, then that course is deleted from CourseTaken */
/* Primary author: David Liao */

CREATE TRIGGER DeleteLastStudentOfCourseTaken
AFTER DELETE ON Student
WHEN (NOT EXISTS (SELECT *
FROM Student S
WHERE S.student_id = OLD.student_id))
BEGIN
DELETE FROM CourseTaken WHERE student_id = OLD.student_id;
END;

/* allows for deletions on OrgMembers
   Primary Author: Sashank Nutakki
   Secondary Author: Sid Panjwani */

CREATE TRIGGER DeleteOnOrgMembers
INSTEAD OF DELETE ON OrgMembers
BEGIN
DELETE FROM Member 
WHERE member_username = Old.username AND organization_username = (SELECT username FROM Organization O where O.organization_name = Old.organization_name);
END;








/* --------------------DROP statements-------------------- */

DROP TABLE IF EXISTS Attending;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS CourseEvent;
DROP TABLE IF EXISTS CourseTaken;
DROP TABLE IF EXISTS Event;
DROP TABLE IF EXISTS Faculty;
DROP TABLE IF EXISTS Friend;
DROP TABLE IF EXISTS Member;
DROP TABLE IF EXISTS Organization;
DROP TABLE IF EXISTS OrganizationEvent;
DROP TABLE IF EXISTS OrganizationEventInvitation;
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS PersonalEvent;
DROP TABLE IF EXISTS PersonalEventInvitation;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS User;
DROP VIEW IF EXISTS OrgMembers;
DROP VIEW IF EXISTS GraduatedStudents;
DROP VIEW IF EXISTS ClassMembers;
DROP VIEW IF EXISTS AccessiblePersonalEvents;
DROP TRIGGER IF EXISTS DeleteLastStudentOfCourseTaken;
DROP TRIGGER IF EXISTS DeleteEvent;
DROP TRIGGER IF EXISTS InvitedToEvent;
DROP TRIGGER IF EXISTS DeleteOnOrgMembers;

