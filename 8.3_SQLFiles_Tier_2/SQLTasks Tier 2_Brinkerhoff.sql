/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */
SELECT name 
FROM Facilities
WHERE membercost = 0.0

/* Q2: How many facilities do not charge a fee to members? */
4

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT facid, name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost / monthlymaintenance < 0.2

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */
SELECT *
FROM Facilities
WHERE facid IN (1,5)


/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */
SELECT expense_label, name, monthlymaintenance
FROM Facilities
WHERE monthlymaintenance > 100


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */
SELECT firstname, surname
FROM Members
ORDER BY joindate DESC
LIMIT 1;

/* I'm not understanding why it's incorrect to use LIMIT here - what is the alternative?*/


/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
SELECT DISTINCT name AS Court, CONCAT(firstname, ' ', surname) AS Member_Name
FROM Bookings
INNER JOIN Facilities 
ON Bookings.facid = Facilities.facid
INNER JOIN Members
ON Members.memid = Bookings.memid
WHERE Bookings.facid IN (0,1)
ORDER BY Member_Name;


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
SELECT name AS facilty, CONCAT(firstname, ' ', surname) AS member_name, 
	CASE WHEN Bookings.memid > 0 THEN (Facilities.membercost * Bookings.slots)
    ELSE (Facilities.guestcost * Bookings.slots)
    END AS cost    
FROM Bookings
INNER JOIN Facilities 
ON Bookings.facid = Facilities.facid
INNER JOIN Members
ON Members.memid = Bookings.memid
WHERE Bookings.starttime LIKE '2012-09-14%'
HAVING cost > 30
ORDER BY cost DESC;


/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT name AS facilty, subquery.member_name, 
	CASE WHEN Bookings.memid > 0 THEN (Facilities.membercost * Bookings.slots)
    ELSE (Facilities.guestcost * Bookings.slots)
    END AS cost   
FROM Bookings
INNER JOIN Facilities 
ON Bookings.facid = Facilities.facid,
(SELECT CONCAT(firstname, ' ', surname) AS member_name, memid
FROM Members) AS subquery
WHERE Bookings.starttime LIKE '2012-09-14%'
AND subquery.memid = Bookings.memid
HAVING cost > 30
ORDER BY cost DESC;



/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.  


QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
SELECT subquery.name as Facility, SUM(subquery.revenue) as Revenue
FROM 
(SELECT name, CASE WHEN Bookings.memid > 0 THEN (Facilities.membercost * Bookings.slots)
    ELSE (Facilities.guestcost * Bookings.slots)
    END AS revenue
    FROM Bookings
	INNER JOIN Facilities
	ON Bookings.facid = Facilities.facid) as subquery

GROUP BY Facility
HAVING Revenue < 1000

ORDER BY Revenue


/* The below is the same as the above - just written with a CTE instead of a Subquery */
WITH bookings_revenue AS
(SELECT name, CASE WHEN Bookings.memid > 0 THEN (Facilities.membercost * Bookings.slots)
ELSE (Facilities.guestcost * Bookings.slots)
END AS revenue
FROM Bookings
INNER JOIN Facilities
ON Bookings.facid = Facilities.facid)

SELECT name AS Facility,SUM(revenue) AS Revenue 
FROM bookings_revenue
GROUP BY name
HAVING SUM(revenue) < 1000
ORDER BY Revenue



/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */
WITH recs AS
(SELECT m1.memid AS rec_id, m1.surname AS rec_surname,m1.firstname AS rec_firstname
FROM Members as m1
INNER JOIN Members as m2
ON m1.memid = m2.recommendedby
)

SELECT DISTINCT surname AS Member_surname, firstname AS Member_first_name, rec_surname AS Recommended_by_surname ,rec_firstname AS Recommended_by_first_name
FROM Members
INNER JOIN recs
ON Members.recommendedby = recs.rec_id
WHERE Members.memid <> 0
AND recs.rec_id <> 0
ORDER BY Member_surname


/* Q12: Find the facilities with their usage by member, but not guests */
SELECT name AS Facility ,COUNT(memid) AS Member_usage 
FROM Bookings
INNER JOIN Facilities
ON Bookings.facid = Facilities.facid
WHERE memid <> 0
GROUP BY Facility


/* Q13: Find the facilities usage by month, but not guests */
WITH july_use AS
(SELECT name ,COUNT(memid) AS july_usage
FROM Bookings
INNER JOIN Facilities
ON Bookings.facid = Facilities.facid
WHERE memid <> 0 AND
starttime LIKE '2012-07%'
GROUP BY name
),

aug_use AS
(SELECT name ,COUNT(memid) AS aug_usage
FROM Bookings
INNER JOIN Facilities
ON Bookings.facid = Facilities.facid
WHERE memid <> 0 AND
starttime LIKE '2012-08%'
GROUP BY name
),

sept_use AS
(SELECT name ,COUNT(memid) AS sept_usage
FROM Bookings
INNER JOIN Facilities
ON Bookings.facid = Facilities.facid
WHERE memid <> 0 AND
starttime LIKE '2012-09%'
GROUP BY name
)

SELECT j.name as Facility,j.July_usage AS July, a.aug_usage AS August, s.sept_usage AS September
FROM 
july_use as j
INNER JOIN
aug_use as a
ON j.name = a.name
INNER JOIN 
sept_use as s
ON j.name = s.name

GROUP BY j.name