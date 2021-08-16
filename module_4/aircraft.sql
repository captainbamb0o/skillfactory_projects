--4.1

SELECT a.city,

count(*) AS count_airport

FROM dst_project.airports AS a

GROUP BY 1

HAVING count(*) > 1;

-- Ответ: Moscow, Ulyanovsk

--4.2.1

SELECT count(DISTINCT f.status)

FROM dst_project.flights AS f;

-- Ответ: 6

--4.2.2

SELECT count(*)

FROM dst_project.flights AS f

WHERE f.status = 'Departed';

-- Ответ: 58

--4.2.3

SELECT count(*)

FROM dst_project.seats s

JOIN dst_project.aircrafts a ON a.aircraft_code = s.aircraft_code

WHERE a.aircraft_code = '773';

-- Ответ: 402

--4.2.4

SELECT count(*)

FROM dst_project.flights AS f

WHERE (f.actual_arrival BETWEEN '2017-04-01' AND '2017-09-01')

AND (f.status = 'Arrived');

-- Ответ: 74227

--4.3.1

SELECT count(*)

FROM dst_project.flights AS f

WHERE f.status = 'Cancelled';

-- Ответ: 437

--4.3.2

WITH boeing AS

(SELECT count(*) AS boeing

FROM dst_project.aircrafts AS a

WHERE a.model LIKE 'Boeing%'),

sukhoi_superjet AS

(SELECT count(*) AS sukhoi_superjet

FROM dst_project.aircrafts AS a

WHERE a.model LIKE 'Sukhoi Superjet%'),

airbus AS

(SELECT count(*) AS airbus

FROM dst_project.aircrafts AS a

WHERE a.model LIKE 'Airbus%')

SELECT *

FROM boeing,

sukhoi_superjet,

airbus;

-- Ответ: 3
-- Ответ: 1
-- Ответ: 3

--4.3.3

WITH Asia AS

(SELECT count(*) AS Asia

FROM dst_project.airports AS a

WHERE a.timezone LIKE 'Asia%'),

Europe AS

(SELECT count(*) AS Europe

FROM dst_project.airports AS a

WHERE a.timezone LIKE 'Europe%'),

Australia AS

(SELECT count(*) AS Australia

FROM dst_project.airports AS a

WHERE a.timezone LIKE 'Australia%')

SELECT *

FROM Asia,

Europe,

Australia;

-- Ответ: Europe, Asia

--4.3.4

SELECT f.flight_id

FROM dst_project.flights AS f

WHERE f.status = 'Arrived'

ORDER BY f.actual_arrival - f.scheduled_arrival DESC

LIMIT 1;

-- Ответ: 157571

--4.4.1

SELECT f.scheduled_departure

FROM dst_project.flights AS f

ORDER BY 1

LIMIT 1;

-- Ответ: 14.08.2016

--4.4.2

SELECT max(EXTRACT(HOUR FROM (f.scheduled_arrival - f.scheduled_departure)) * 60 +

EXTRACT(MINUTE FROM (f.scheduled_arrival - f.scheduled_departure))) AS flight_time

FROM dst_project.flights AS f;

-- Ответ: 530

--4.4.3

SELECT f.departure_airport,

f.arrival_airport

FROM dst_project.flights AS f

ORDER BY (EXTRACT(HOUR FROM (f.scheduled_arrival - f.scheduled_departure)) * 60 +

EXTRACT(MINUTE FROM (f.scheduled_arrival - f.scheduled_departure))) DESC

LIMIT 1;

-- Ответ: DME - UUS

--4.4.4

SELECT avg(EXTRACT(HOUR FROM (f.scheduled_arrival - f.scheduled_departure)) * 60 +

EXTRACT(MINUTE FROM (f.scheduled_arrival - f.scheduled_departure)))::int AS avg_flight_time

FROM dst_project.flights AS f;

-- Ответ: 128

--4.5.1

SELECT s.fare_conditions

FROM dst_project.seats AS s

WHERE s.aircraft_code = 'SU9'

GROUP BY 1

ORDER BY count(s.seat_no) DESC

LIMIT 1;

-- Ответ: Economy

--4.5.2

SELECT min(b.total_amount)

FROM dst_project.bookings AS b;

-- Ответ: 3400

--4.5.3

SELECT bp.seat_no

FROM dst_project.BOARDING_PASSES AS bp

JOIN dst_project.TICKETS AS t ON t.ticket_no = bp.ticket_no

WHERE t.passenger_id = '4313 788533';

-- Ответ: 2A

--5.1.1

SELECT count(*)

FROM dst_project.flights AS f

JOIN dst_project.airports AS a ON a.airport_code = f.arrival_airport

WHERE f.status = 'Arrived'

AND a.city = 'Anapa'

AND extract(YEAR

FROM f.actual_arrival) = 2017;

-- Ответ: 486

--5.1.2

SELECT count(*)

FROM dst_project.flights AS f

JOIN dst_project.airports AS a ON a.airport_code = f.departure_airport

WHERE f.status in ('Arrived',

'Departed')

AND a.city = 'Anapa'

AND ((date_part('month', f.actual_departure) IN (1,

2,

12))

AND (date_part('year', f.actual_departure) = 2017));

-- Ответ: 127

--5.1.3

SELECT count(*)

FROM dst_project.flights AS f

JOIN dst_project.airports AS a ON a.airport_code = f.departure_airport

WHERE f.status = 'Cancelled'

AND a.city = 'Anapa';

-- Ответ: 1

--5.1.4

SELECT count(*)

FROM dst_project.flights AS f

WHERE f.departure_airport in

(SELECT f.departure_airport

FROM dst_project.flights AS f

JOIN dst_project.airports AS a ON a.airport_code = f.departure_airport

WHERE a.city = 'Anapa' )

AND f.arrival_airport not in

(SELECT f.departure_airport

FROM dst_project.flights AS f

JOIN dst_project.airports AS a ON a.airport_code = f.departure_airport

WHERE a.city = 'Moscow' );

-- Ответ: 453

--5.1.5

SELECT a.model,

count(DISTINCT s.seat_no)

FROM dst_project.flights f

JOIN dst_project.aircrafts a ON a.aircraft_code = f.aircraft_code

JOIN dst_project.seats s ON a.aircraft_code = s.aircraft_code

JOIN dst_project.airports ap ON ap.airport_code = f.departure_airport

WHERE ap.city = 'Anapa'

GROUP BY a.model,

f.departure_airport

ORDER BY 2 DESC;

-- Ответ: Boeing 737-300

-- Финальная задача

WITH main_table AS

  (SELECT f.flight_id,
          f.flight_no,
          f.aircraft_code,
          f.departure_airport,
          f.arrival_airport,
          f.actual_departure,
          f.actual_arrival,
          EXTRACT(HOUR FROM (f.actual_arrival - f.actual_departure)) * 60 +
          EXTRACT(MINUTE FROM (f.actual_arrival - f.actual_departure)) AS flight_time,
          EXTRACT(HOUR FROM (f.actual_departure - f.scheduled_departure)) * 60 +
          EXTRACT(MINUTE FROM (f.actual_departure - f.scheduled_departure)) AS last_departure
   FROM dst_project.flights AS f
   WHERE departure_airport = 'AAQ'
     AND (date_trunc('month', scheduled_departure) IN ('2017-01-01','2017-02-01', '2017-12-01'))
     AND status NOT IN ('Cancelled')
      ),
     count_seats AS

  (SELECT s.aircraft_code,
          count(CASE WHEN s.fare_conditions = 'Business' THEN s.fare_conditions END) AS seat_business,
          count(CASE WHEN s.fare_conditions = 'Economy' THEN s.fare_conditions END) AS seat_economy,
          count(*) AS seat_total
   FROM dst_project.seats AS s
   GROUP BY 1
      ),
     sold_tickets AS

  (SELECT t.flight_id,
          count(CASE WHEN t.fare_conditions = 'Business' THEN t.fare_conditions END) AS sold_business,
          count(CASE WHEN t.fare_conditions = 'Economy' THEN t.fare_conditions END) AS sold_economy,
          count(*) AS sold_total,
          sum(CASE WHEN t.fare_conditions = 'Economy' THEN t.amount END) AS amount_economy,
          sum(CASE WHEN t.fare_conditions = 'Business' THEN t.amount END) AS amount_business,
          sum(t.amount) AS amount_total
   FROM dst_project.ticket_flights AS t
   GROUP BY 1
      )

SELECT m.flight_id,
 m.flight_no,
 a.model,
 apd.city AS departure_city,
 ap.city AS arrival_city,
 m.actual_departure,
 m.actual_arrival,
 m.flight_time,
 m.last_departure,
 ct.seat_business,
 ct.seat_economy,
 ct.seat_total,
 ct.aircraft_code,
 st.sold_business,
 st.sold_economy,
 st.sold_total,
 st.amount_economy,
 st.amount_business,
 st.amount_total

FROM main_table AS m
LEFT JOIN dst_project.aircrafts AS a ON m.aircraft_code = a.aircraft_code
LEFT JOIN dst_project.airports AS ap ON ap.airport_code = m.arrival_airport
LEFT JOIN dst_project.airports apd ON m.departure_airport = apd.airport_code
LEFT JOIN count_seats AS ct ON ct.aircraft_code = m.aircraft_code
LEFT JOIN sold_tickets AS st ON st.flight_id = m.flight_id
ORDER BY 5