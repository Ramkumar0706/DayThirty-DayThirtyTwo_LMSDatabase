-- 1- find all candidate having java technology
select * from hiredcandidate
 where id=(select candidate_id from candidatestackassignment
where requirement_id=(select id from companyrequirement
where tech_stack_id=(select id from techstack where Tech_Name='Java')));

-- 2- find all mentors and ideations have java technology
SELECT DISTINCT m.id, m.name, m.mentor_type, m.lab_id
FROM mentor m
JOIN mentorideationmap mim ON m.id = mim.mentor_id
JOIN companyrequirement cr ON cr.ideation_engg_id = m.id OR cr.buddy_engg_id = m.id
WHERE cr.tech_stack_id =(select id from techstack where Tech_Name='Java')
AND cr.status = 'Active'
AND mim.status = 'Active';

-- 7- find name of candidate which did not assign technology
SELECT f.CIC_ID, f.First_Name, f.Middle_Name, f.Last_Name
FROM fellowshipcandidate f
WHERE f.CIC_ID NOT IN (
    SELECT candidate_id
    FROM candidatestackassignment
)
UNION
SELECT h.Id, h.First_Name, h.Middle_Name, h.Last_Name
FROM hiredcandidate h
WHERE h.Id NOT IN (SELECT candidate_id
    FROM candidatestackassignment
);

-- 8- find name of cnadidate which is not submit documents 
SELECT h.Id, h.First_Name, h.Middle_Name, h.Last_Name
FROM hiredcandidate h
WHERE h.Id NOT IN (
    SELECT candidate_id
    FROM candidatedocuments
);

-- 9- find name of candidate which is not submit bank details
SELECT h.Id, h.First_Name, h.Middle_Name, h.Last_Name
FROM hiredcandidate h
WHERE h.Id NOT IN (
    SELECT candidate_id
    FROM candidatebankdetails
);

-- 10-find name of candidates which is joined in dec month
SELECT f.CIC_ID, f.First_Name, f.Middle_Name, f.Last_Name
FROM fellowshipcandidate f
WHERE f.Joining_Date >= 2023-12-01;

-- 11-find name of candidates which is end of couse in feb
SELECT f.CIC_ID, f.First_Name, f.Middle_Name, f.Last_Name
FROM fellowshipcandidate f
WHERE EXTRACT(MONTH FROM f.Joining_Date) = 11;
-- 12-find name of candidates which is ending date accounding to joining date if joining date is 22-02-2019
SELECT
    First_Name,
    Middle_Name, 
    Last_Name
FROM
    fellowshipcandidate
WHERE
    Joining_Date = DATE_SUB('2019-02-22', INTERVAL 3 MONTH);


-- 13-find all candidates which is passed out in 2019 year
SELECT
    CIC_ID,
    First_Name,
    Middle_Name,
    Last_Name,
    EmailId,
    Hired_Date
FROM
    fellowshipcandidate
WHERE
    Hired_Date >= '2019-01-01'
    AND Hired_Date < '2020-01-01';
    
-- 14-which technology assign to which candidates which is having MCA background
SELECT
    fc.CIC_ID AS Candidate_Id,
    fc.First_Name AS Candidate_First_Name,
    fc.Middle_Name AS Candidate_Middle_Name,
    fc.Last_Name AS Candidate_Last_Name,
    fc.Degree AS Candidate_Degree,
    ts.Tech_Name AS Assigned_Technology
FROM
    fellowshipcandidate fc
INNER JOIN
    candidatestackassignment csa ON fc.candidate_id = csa.candidate_id
INNER JOIN
    companyrequirement cr ON csa.requirement_id = cr.Id
INNER JOIN
    techstack ts ON cr.tech_stack_id = ts.Id
WHERE
    fc.Degree = 'B.A';
    
-- 15-how many candiates which is having last month
SELECT
    COUNT(*) AS Number_Of_Candidates
FROM
    fellowshipcandidate
WHERE
    (Joining_Date <= '2024-07-31' AND Joining_Date >= '2024-05-01');
    
-- 16-how many week candidate completed in the bridgelabz since joining date candidate id is 3
SELECT
    c.CIC_ID,
    c.First_Name,
    c.Middle_Name,
    c.Last_Name,
    TIMESTAMPDIFF(WEEK, c.Joining_Date, CURDATE()) AS Weeks_Completed
FROM (
    SELECT CIC_ID, First_Name, Middle_Name, Last_Name, Joining_Date
    FROM fellowshipcandidate
    WHERE candidate_id = (select id from hiredcandidate where id=3)
) c;
-- 17-find joining date of candidate if candidate id is 3
SELECT CIC_ID, Joining_Date
FROM fellowshipcandidate
WHERE candidate_id = 3;
-- 18-how many week remaining of candidate in the bridglabz from today if candidate id is 5
SELECT
    c.CIC_ID,
    c.First_Name,
    c.Middle_Name,
    c.Last_Name,
    FLOOR(TIMESTAMPDIFF(DAY, CURDATE(), DATE_ADD(c.Joining_Date, INTERVAL 3 MONTH)) / 7) AS Weeks_Remaining
FROM (
    SELECT CIC_ID, First_Name, Middle_Name, Last_Name, Joining_Date
    FROM fellowshipcandidate
    WHERE candidate_id = (select id from hiredcandidate where id=5)
) c;

-- 19-how many days remaining of candidate in the bridgelabz from today if candidate is id 3

SELECT
    c.CIC_ID,
    c.First_Name,
    c.Middle_Name,
    c.Last_Name,
    FLOOR(TIMESTAMPDIFF(DAY, CURDATE(), DATE_ADD(c.Joining_Date, INTERVAL 3 MONTH)) / 7) AS Weeks_Remaining
FROM (
    SELECT CIC_ID, First_Name, Middle_Name, Last_Name, Joining_Date
    FROM fellowshipcandidate
    WHERE candidate_id = (select id from hiredcandidate where id=3)
) c;

-- 20-find candidates which is deployed
select  First_Name,Middle_Name,Last_Name  from fellowshipcandidate
WHERE candidate_id IN(SELECT candidate_id FROM candidatestackassignment
WHERE requirement_id IN(SELECT id FROM companyrequirement WHERE Requested_Month <='2024-11-20'));

-- 21-find name and other details and name of company which is assign to condidate.

SELECT
    c.CIC_ID,
    c.First_Name,
    c.Middle_Name,
    c.Last_Name,
    c.EmailId,
    c.Hired_City,
    c.Degree,
    c.Hired_Date,
    c.Mobile_Number,
    com.Name
FROM
    candidatestackassignment csa
JOIN
    fellowshipcandidate c ON c.candidate_id = csa.candidate_id
JOIN
    company com ON com.Id = csa.requirement_id;


-- 22-find all condidate and mentors which is related to lab= banglore/mumbai/pune.
SELECT First_Name,'student' FROM fellowshipcandidate WHERE Hired_Lab='mumbai'
UNION
SELECT Name,Mentor_Type
 FROM mentor WHERE lab_id=(select id from lab where Location='Mumbai');

-- 23-find buddy mentors and ideation mentor and which technology assign to perticular candidate if candidate id is 5
SELECT
    fc.CIC_ID AS Candidate_Id,
    fc.First_Name AS Candidate_First_Name,
    fc.Middle_Name AS Candidate_Middle_Name,
    fc.Last_Name AS Candidate_Last_Name,
    bm.Id AS Buddy_Mentor_Id,
    bm.Name AS Buddy_Mentor_Name,
    im.Id AS Ideation_Mentor_Id,
    im.Name AS Ideation_Mentor_Name,
    ts.Tech_Name AS Assigned_Technology
FROM
    candidatestackassignment csa
INNER JOIN
    fellowshipcandidate fc ON fc.candidate_id = csa.candidate_id
INNER JOIN
    companyrequirement cr ON cr.Id = csa.requirement_id
INNER JOIN
    mentor bm ON bm.Id = cr.buddy_engg_id
INNER JOIN
    mentor im ON im.Id = cr.ideation_engg_id
INNER JOIN
    techstack ts ON ts.Id = cr.tech_stack_id
WHERE
    fc.candidate_id = (select id from hiredcandidate where id=5);