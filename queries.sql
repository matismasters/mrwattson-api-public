/* DIA ANTERIOR COMPARADO CON DIA ANTERIOR SEMANA PASADA */

WITH variable_data AS (
  SELECT  1 AS sensor,
  1 AS last_day,
  8 AS last_week
), avg_last_day AS (
  SELECT
    device_id,
    particle_id,
    round(SUM(end_read * (seconds_until_next_read )::FLOAT)/SUM(seconds_until_next_read)::FLOAT) AS dayly_avg
  FROM variable_data, reading_events
  INNER JOIN devices
    ON reading_events.device_id = devices.id
  WHERE
    date_trunc('day', reading_events.created_at) = date_trunc('day', now()::DATE - last_day) and
    sensor_id = sensor
  GROUP BY device_id, particle_id
), avg_last_week AS (
  SELECT
    device_id,
    particle_id,
    round(SUM(end_read * (seconds_until_next_read )::FLOAT)/SUM(seconds_until_next_read)::FLOAT) AS dayly_avg
  FROM variable_data, reading_events
  INNER JOIN devices
    ON reading_events.device_id = devices.id
  WHERE
    date_trunc('day', reading_events.created_at) = date_trunc('day', now()::DATE - last_week) and
    sensor_id = sensor
  GROUP BY device_id, particle_id
)

SELECT
  avg_last_week.device_id,
  avg_last_week.particle_id,
  avg_last_day.dayly_avg - avg_last_week.dayly_avg AS difference

FROM avg_last_day, avg_last_week
WHERE avg_last_day.device_id = avg_last_week.device_id AND avg_last_day.particle_id = avg_last_week.particle_id
ORDER BY device_id, particle_id

/* SEMANA ANTERIOR COMPARADA CON LA OTRA SEMANA */

WITH variable_data AS (
  SELECT  1 AS sensor,
  1 AS start_last_day,
  8 AS end_last_day,
  9 AS start_last_week,
  16 AS end_last_week
), avg_last_day AS (
  SELECT
    device_id,
    particle_id,
    round(SUM(end_read * (seconds_until_next_read )::FLOAT)/SUM(seconds_until_next_read)::FLOAT) AS dayly_avg
  FROM variable_data, reading_events
  INNER JOIN devices
    ON reading_events.device_id = devices.id
  WHERE
    date_trunc('day', reading_events.created_at) between date_trunc('day', now()::DATE - end_last_day) AND date_trunc('day', now()::DATE - start_last_day) and
    sensor_id = sensor
  GROUP BY device_id, particle_id
), avg_last_week AS (
  SELECT
    device_id,
    particle_id,
    round(SUM(end_read * (seconds_until_next_read )::FLOAT)/SUM(seconds_until_next_read)::FLOAT) AS dayly_avg
  FROM variable_data, reading_events
  INNER JOIN devices
    ON reading_events.device_id = devices.id
  WHERE
    date_trunc('day', reading_events.created_at) between date_trunc('day', now()::DATE - end_last_week) AND date_trunc('day', now()::DATE - start_last_week) and
    sensor_id = sensor
  GROUP BY device_id, particle_id
)

SELECT
  avg_last_week.device_id,
  avg_last_week.particle_id,
  avg_last_day.dayly_avg - avg_last_week.dayly_avg AS difference
FROM avg_last_day, avg_last_week
WHERE avg_last_day.device_id = avg_last_week.device_id AND avg_last_day.particle_id = avg_last_week.particle_id
ORDER BY device_id, particle_id

/* MES ANTERIOR COMPARADO CON EL OTRO MES */

WITH variable_data AS (
  SELECT  1 AS sensor
), avg_last_day AS (
  SELECT
    device_id,
    particle_id,
    round(SUM(end_read * (seconds_until_next_read )::FLOAT)/SUM(seconds_until_next_read)::FLOAT) AS dayly_avg
  FROM variable_data, reading_events
  INNER JOIN devices
    ON reading_events.device_id = devices.id
  WHERE
    date_trunc('month', reading_events.created_at) = date_trunc('month', now()::DATE - interval '1 month') and
    sensor_id = sensor
  GROUP BY device_id, particle_id
), avg_last_week AS (
  SELECT
    device_id,
    particle_id,
    round(SUM(end_read * (seconds_until_next_read )::FLOAT)/SUM(seconds_until_next_read)::FLOAT) AS dayly_avg
  FROM variable_data, reading_events
  INNER JOIN devices
    ON reading_events.device_id = devices.id
  WHERE
    date_trunc('month', reading_events.created_at) = date_trunc('month', now()::DATE - interval '2 month') and
    sensor_id = sensor
  GROUP BY device_id, particle_id
)

SELECT
  avg_last_week.device_id,
  avg_last_week.particle_id,
  avg_last_day.dayly_avg - avg_last_week.dayly_avg AS difference
FROM avg_last_day, avg_last_week
WHERE avg_last_day.device_id = avg_last_week.device_id AND avg_last_day.particle_id = avg_last_week.particle_id
ORDER BY device_id, particle_id

/* GASTO DEL DIA */

WITH reading_events_for_sensor AS (
SELECT id, device_id, sensor_id,
CASE WHEN sensor_id = 1 THEN 1 ELSE 0 END AS read_count_sensor1,
CASE WHEN sensor_id = 2 THEN 1 ELSE 0 END AS read_count_sensor2,
CASE WHEN sensor_id = 3 THEN 1 ELSE 0 END AS read_count_sensor3,
CASE WHEN sensor_id = 4 THEN 1 ELSE 0 END AS read_count_sensor4,
CASE WHEN sensor_id = 1 THEN start_read ELSE 0 END AS start_read_sensor1,
CASE WHEN sensor_id = 2 THEN start_read ELSE 0 END AS start_read_sensor2,
CASE WHEN sensor_id = 3 THEN start_read ELSE 0 END AS start_read_sensor3,
CASE WHEN sensor_id = 4 THEN start_read ELSE 0 END AS start_read_sensor4,
CASE WHEN sensor_id = 1 THEN end_read ELSE 0 END AS end_read_sensor1,
CASE WHEN sensor_id = 2 THEN end_read ELSE 0 END AS end_read_sensor2,
CASE WHEN sensor_id = 3 THEN end_read ELSE 0 END AS end_read_sensor3,
CASE WHEN sensor_id = 4 THEN end_read ELSE 0 END AS end_read_sensor4,
CASE WHEN sensor_id = 1 THEN read_difference ELSE 0 END AS read_difference_sensor1,
CASE WHEN sensor_id = 2 THEN read_difference ELSE 0 END AS read_difference_sensor2,
CASE WHEN sensor_id = 3 THEN read_difference ELSE 0 END AS read_difference_sensor3,
CASE WHEN sensor_id = 4 THEN read_difference ELSE 0 END AS read_difference_sensor4,
CASE WHEN sensor_id = 1 THEN seconds_until_next_read ELSE 0 END AS seconds_until_next_read_sensor1,
CASE WHEN sensor_id = 2 THEN seconds_until_next_read ELSE 0 END AS seconds_until_next_read_sensor2,
CASE WHEN sensor_id = 3 THEN seconds_until_next_read ELSE 0 END AS seconds_until_next_read_sensor3,
CASE WHEN sensor_id = 4 THEN seconds_until_next_read ELSE 0 END AS seconds_until_next_read_sensor4,
created_at, updated_at
FROM reading_events
WHERE
  reading_events.created_at::DATE = NOW()::DATE-1
)
SELECT *
FROM
(
  SELECT
    device_id,
    particle_id,
    to_char((NOW()::DATE-1), 'DD/MM/YYYY') AS yesterday,
    ROUND((
      (SUM(end_read_sensor1 * (seconds_until_next_read_sensor1 ))/ (SUM(seconds_until_next_read_sensor1) + 1)::FLOAT) *
      (SUM(seconds_until_next_read_sensor1) / 3600.0) / 1000
    ) * 5) AS yesterday_spendings_sensor1,
    ROUND((
      (SUM(end_read_sensor2 * (seconds_until_next_read_sensor2 ))/ (SUM(seconds_until_next_read_sensor2) + 1)::FLOAT) *
      (SUM(seconds_until_next_read_sensor2) / 3600.0) / 1000
    ) * 5) AS yesterday_spendings_sensor2,
    ROUND((
      (SUM(end_read_sensor3 * (seconds_until_next_read_sensor3 ))/ (SUM(seconds_until_next_read_sensor3) + 1)::FLOAT) *
      (SUM(seconds_until_next_read_sensor3) / 3600.0) / 1000
    ) * 5) AS yesterday_spendings_sensor3,
    ROUND((
      (SUM(end_read_sensor4 * (seconds_until_next_read_sensor4 ))/ (SUM(seconds_until_next_read_sensor4) + 1)::FLOAT) *
      (SUM(seconds_until_next_read_sensor4) / 3600.0) / 1000
    ) * 5) AS yesterday_spendings_sensor4,
    ROUND(
      (SUM(end_read_sensor1 * (seconds_until_next_read_sensor1 ))/ (SUM(seconds_until_next_read_sensor1) + 1)::FLOAT) *
      (SUM(seconds_until_next_read_sensor1) / 3600.0) / 1000
    ) AS yesterday_spendings_sensor1_kwh,
    ROUND(
      (SUM(end_read_sensor2 * (seconds_until_next_read_sensor2 ))/ (SUM(seconds_until_next_read_sensor2) + 1)::FLOAT) *
      (SUM(seconds_until_next_read_sensor2) / 3600.0) / 1000
    ) AS yesterday_spendings_sensor2_kwh,
    ROUND(
      (SUM(end_read_sensor3 * (seconds_until_next_read_sensor3 ))/ (SUM(seconds_until_next_read_sensor3) + 1)::FLOAT) *
      (SUM(seconds_until_next_read_sensor3) / 3600.0) / 1000
    ) AS yesterday_spendings_sensor3_kwh,
    ROUND(
      (SUM(end_read_sensor4 * (seconds_until_next_read_sensor4 ))/ (SUM(seconds_until_next_read_sensor4) + 1)::FLOAT) *
      (SUM(seconds_until_next_read_sensor4) / 3600.0) / 1000
    ) AS yesterday_spendings_sensor4_kwh
  FROM reading_events_for_sensor
  INNER JOIN devices
    ON reading_events_for_sensor.device_id = devices.id
  GROUP BY device_id, particle_id
) AS results
INNER JOIN devices
 ON results.device_id = devices.id

/* yesterday_spendings_sensor1|yesterday_spendings_sensor2|yesterday_spendings_sensor3|yesterday_spendings_sensor4|yesterday_spendings_sensor1_kwh|yesterday_spendings_sensor2_kwh|yesterday_spendings_sensor3_kwh|yesterday_spendings_sensor4_kwh|yesterday|sensor_1_label|sensor_2_label|sensor_3_label|sensor_4_label */

/* GASTO ENTRE LAS 17 y las 23 */

WITH reading_events_for_sensor AS (
SELECT id, device_id, sensor_id,
CASE WHEN sensor_id = 1 THEN start_read ELSE 0 END AS start_read_sensor1,
CASE WHEN sensor_id = 2 THEN start_read ELSE 0 END AS start_read_sensor2,
CASE WHEN sensor_id = 3 THEN start_read ELSE 0 END AS start_read_sensor3,
CASE WHEN sensor_id = 4 THEN start_read ELSE 0 END AS start_read_sensor4,
CASE WHEN sensor_id = 1 THEN end_read ELSE 0 END AS end_read_sensor1,
CASE WHEN sensor_id = 2 THEN end_read ELSE 0 END AS end_read_sensor2,
CASE WHEN sensor_id = 3 THEN end_read ELSE 0 END AS end_read_sensor3,
CASE WHEN sensor_id = 4 THEN end_read ELSE 0 END AS end_read_sensor4,
CASE WHEN sensor_id = 1 THEN read_difference ELSE 0 END AS read_difference_sensor1,
CASE WHEN sensor_id = 2 THEN read_difference ELSE 0 END AS read_difference_sensor2,
CASE WHEN sensor_id = 3 THEN read_difference ELSE 0 END AS read_difference_sensor3,
CASE WHEN sensor_id = 4 THEN read_difference ELSE 0 END AS read_difference_sensor4,
CASE WHEN sensor_id = 1 THEN seconds_until_next_read ELSE 0 END AS seconds_until_next_read_sensor1,
CASE WHEN sensor_id = 2 THEN seconds_until_next_read ELSE 0 END AS seconds_until_next_read_sensor2,
CASE WHEN sensor_id = 3 THEN seconds_until_next_read ELSE 0 END AS seconds_until_next_read_sensor3,
CASE WHEN sensor_id = 4 THEN seconds_until_next_read ELSE 0 END AS seconds_until_next_read_sensor4,
created_at, updated_at
FROM reading_events
WHERE
  (reading_events.created_at::DATE = NOW()::DATE-1) AND
  (EXTRACT(HOUR FROM reading_events.created_at) BETWEEN 17 AND 23)
)
SELECT *
FROM
(
  SELECT
    device_id,
    particle_id,
    to_char((NOW()::DATE-1), 'DD/MM/YYYY') AS yesterday,
    ROUND(((AVG(end_read_sensor1) * (SUM(seconds_until_next_read_sensor1) / 3600.0)) / 1000.00) * 5, 1) AS spendings_sensor1,
    ROUND(((AVG(end_read_sensor2) * (SUM(seconds_until_next_read_sensor2) / 3600.0)) / 1000.00) * 5, 1) AS spendings_sensor2,
    ROUND(((AVG(end_read_sensor3) * (SUM(seconds_until_next_read_sensor3) / 3600.0)) / 1000.00) * 5, 1) AS spendings_sensor3,
    ROUND(((AVG(end_read_sensor4) * (SUM(seconds_until_next_read_sensor4) / 3600.0)) / 1000.00) * 5, 1) AS spendings_sensor4,
    ROUND(((AVG(end_read_sensor1) * (SUM(seconds_until_next_read_sensor1) / 3600.0)) / 1000.00), 1) AS spendings_sensor1_kwh,
    ROUND(((AVG(end_read_sensor2) * (SUM(seconds_until_next_read_sensor2) / 3600.0)) / 1000.00), 1) AS spendings_sensor2_kwh,
    ROUND(((AVG(end_read_sensor3) * (SUM(seconds_until_next_read_sensor3) / 3600.0)) / 1000.00), 1) AS spendings_sensor3_kwh,
    ROUND(((AVG(end_read_sensor4) * (SUM(seconds_until_next_read_sensor4) / 3600.0)) / 1000.00), 1) AS spendings_sensor4_kwh,
    ROUND(ABS(((SUM(seconds_until_next_read_sensor1) / 21600.0) * 100) - 100)) AS error_percentage_sensor1,
    ROUND(ABS(((SUM(seconds_until_next_read_sensor2) / 21600.0) * 100) - 100)) AS error_percentage_sensor2,
    ROUND(ABS(((SUM(seconds_until_next_read_sensor3) / 21600.0) * 100) - 100)) AS error_percentage_sensor3,
    ROUND(ABS(((SUM(seconds_until_next_read_sensor4) / 21600.0) * 100) - 100)) AS error_percentage_sensor4
  FROM reading_events_for_sensor
  INNER JOIN devices
    ON reading_events_for_sensor.device_id = devices.id
  GROUP BY device_id, particle_id
) AS results
INNER JOIN devices
 ON results.device_id = devices.id

/* Gasto desde el primer día del mes por pinza > 100kwh */

WITH reading_events_for_sensor AS (
SELECT id, device_id, sensor_id,
CASE WHEN sensor_id = 1 THEN 1 ELSE 0 END AS read_count_sensor1,
CASE WHEN sensor_id = 2 THEN 1 ELSE 0 END AS read_count_sensor2,
CASE WHEN sensor_id = 3 THEN 1 ELSE 0 END AS read_count_sensor3,
CASE WHEN sensor_id = 4 THEN 1 ELSE 0 END AS read_count_sensor4,
CASE WHEN sensor_id = 1 THEN start_read ELSE 0 END AS start_read_sensor1,
CASE WHEN sensor_id = 2 THEN start_read ELSE 0 END AS start_read_sensor2,
CASE WHEN sensor_id = 3 THEN start_read ELSE 0 END AS start_read_sensor3,
CASE WHEN sensor_id = 4 THEN start_read ELSE 0 END AS start_read_sensor4,
CASE WHEN sensor_id = 1 THEN end_read ELSE 0 END AS end_read_sensor1,
CASE WHEN sensor_id = 2 THEN end_read ELSE 0 END AS end_read_sensor2,
CASE WHEN sensor_id = 3 THEN end_read ELSE 0 END AS end_read_sensor3,
CASE WHEN sensor_id = 4 THEN end_read ELSE 0 END AS end_read_sensor4,
CASE WHEN sensor_id = 1 THEN read_difference ELSE 0 END AS read_difference_sensor1,
CASE WHEN sensor_id = 2 THEN read_difference ELSE 0 END AS read_difference_sensor2,
CASE WHEN sensor_id = 3 THEN read_difference ELSE 0 END AS read_difference_sensor3,
CASE WHEN sensor_id = 4 THEN read_difference ELSE 0 END AS read_difference_sensor4,
CASE WHEN sensor_id = 1 THEN seconds_until_next_read ELSE 0 END AS seconds_until_next_read_sensor1,
CASE WHEN sensor_id = 2 THEN seconds_until_next_read ELSE 0 END AS seconds_until_next_read_sensor2,
CASE WHEN sensor_id = 3 THEN seconds_until_next_read ELSE 0 END AS seconds_until_next_read_sensor3,
CASE WHEN sensor_id = 4 THEN seconds_until_next_read ELSE 0 END AS seconds_until_next_read_sensor4,
created_at, updated_at
FROM reading_events
WHERE
  reading_events.created_at::DATE <= NOW()::DATE-1 AND
  reading_events.created_at::DATE >= date_trunc('month', NOW())
)
SELECT *
FROM
(
  SELECT
    device_id,
    particle_id,
    to_char((NOW()::DATE-1), 'DD/MM/YYYY') AS yesterday,
    ROUND((
     (SUM(end_read_sensor1 * (seconds_until_next_read_sensor1 ))/ (SUM(seconds_until_next_read_sensor1) + 1)) *
     (SUM(seconds_until_next_read_sensor1) / 3600.0) / 1000
   ) * 5, 2) AS this_month_spendings_sensor1,
   ROUND((
     (SUM(end_read_sensor2 * (seconds_until_next_read_sensor2 ))/ (SUM(seconds_until_next_read_sensor2) + 1)) *
     (SUM(seconds_until_next_read_sensor2) / 3600.0) / 1000
   ) * 5, 2) AS this_month_spendings_sensor2,
   ROUND((
     (SUM(end_read_sensor3 * (seconds_until_next_read_sensor3 ))/ (SUM(seconds_until_next_read_sensor3) + 1)) *
     (SUM(seconds_until_next_read_sensor3) / 3600.0) / 1000
   ) * 5, 2) AS this_month_spendings_sensor3,
   ROUND((
     (SUM(end_read_sensor4 * (seconds_until_next_read_sensor4 ))/ (SUM(seconds_until_next_read_sensor4) + 1)) *
     (SUM(seconds_until_next_read_sensor4) / 3600.0) / 1000
   ) * 5, 2) AS this_month_spendings_sensor4,
   ROUND(
     (SUM(end_read_sensor1 * (seconds_until_next_read_sensor1 ))/ (SUM(seconds_until_next_read_sensor1) + 1)) *
     (SUM(seconds_until_next_read_sensor1) / 3600.0) / 1000, 2
   ) AS this_month_spendings_sensor1_kwh,
   ROUND(
     (SUM(end_read_sensor2 * (seconds_until_next_read_sensor2 ))/ (SUM(seconds_until_next_read_sensor2) + 1)) *
     (SUM(seconds_until_next_read_sensor2) / 3600.0) / 1000, 2
   ) AS this_month_spendings_sensor2_kwh,
   ROUND(
     (SUM(end_read_sensor3 * (seconds_until_next_read_sensor3 ))/ (SUM(seconds_until_next_read_sensor3) + 1)) *
     (SUM(seconds_until_next_read_sensor3) / 3600.0) / 1000, 2
   ) AS this_month_spendings_sensor3_kwh,
   ROUND(
     (SUM(end_read_sensor4 * (seconds_until_next_read_sensor4 ))/ (SUM(seconds_until_next_read_sensor4) + 1)) *
     (SUM(seconds_until_next_read_sensor4) / 3600.0) / 1000, 2
   ) AS this_month_spendings_sensor4_kwh
 FROM reading_events_for_sensor
 INNER JOIN devices
   ON reading_events_for_sensor.device_id = devices.id
 GROUP BY device_id, particle_id
) AS results
INNER JOIN devices
ON results.device_id = devices.id
WHERE (results.this_month_spendings_sensor1_kwh / 100) > 1

/*
this_month_spendings_sensor1|this_month_spendings_sensor2|this_month_spendings_sensor3|this_month_spendings_sensor4|this_month_spendings_sensor1_kwh|this_month_spendings_sensor2_kwh|this_month_spendings_sensor3_kwh|this_month_spendings_sensor4_kwh|yesterday|sensor_1_label|sensor_2_label|sensor_3_label|sensor_4_label

El día {{yesterday}} has alcanzado los 100 kWh de consumo, contando desde el primer día de este mes.

A continuación podrás ver el detalle de cuanto se gastó en cada una de las zonas de tu casa que están siendo medidas por cada sensor, durante este período de tiempo. La diferencia entre el gasto sumado de los sensores 2, 3 y 4, y el gasto del sensor principal, corresponde al consumo del resto de la casa que no está siendo medido por ningún sensor.

- Sensor 2 ({{sensor_2_label}}): 
	- ${{this_month_spendings_sensor2}} ({{this_month_spendings_sensor2_kwh}} kWh)
- Sensor 3 ({{sensor_3_label}}):
	- ${{this_month_spendings_sensor3}} ({{this_month_spendings_sensor3_kwh}} kWh)
- Sensor 4 ({{sensor_4_label}}):
	- ${{this_month_spendings_sensor4}} ({{this_month_spendings_sensor4_kwh}} kWh)

Por mas detalles sobre los cálculos de costos dirigirse a la sección de consejos.
*/
