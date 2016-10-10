/* DIA ANTERIOR COMPARADO CON DIA ANTERIOR SEMANA PASADA */

WITH variable_data as (
  SELECT  1 as sensor,
  1 as last_day,
  8 as last_week
), avg_last_day as (
  SELECT
    device_id,
    particle_id,
    round(SUM(end_read * (seconds_until_next_read )::FLOAT)/SUM(seconds_until_next_read)::FLOAT) as dayly_avg
  FROM variable_data, reading_events
  INNER JOIN devices
    ON reading_events.device_id = devices.id
  WHERE
    date_trunc('day', reading_events.created_at) = date_trunc('day', now()::DATE - last_day) and
    sensor_id = sensor
  GROUP BY device_id, particle_id
), avg_last_week as (
  SELECT
    device_id,
    particle_id,
    round(SUM(end_read * (seconds_until_next_read )::FLOAT)/SUM(seconds_until_next_read)::FLOAT) as dayly_avg
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
  avg_last_day.dayly_avg - avg_last_week.dayly_avg as difference

FROM avg_last_day, avg_last_week
WHERE avg_last_day.device_id = avg_last_week.device_id and avg_last_day.particle_id = avg_last_week.particle_id
ORDER by device_id, particle_id

/* SEMANA ANTERIOR COMPARADA CON LA OTRA SEMANA */

WITH variable_data as (
  SELECT  1 as sensor,
  1 as start_last_day,
  8 as end_last_day,
  9 as start_last_week,
  16 as end_last_week
), avg_last_day as (
  SELECT
    device_id,
    particle_id,
    round(SUM(end_read * (seconds_until_next_read )::FLOAT)/SUM(seconds_until_next_read)::FLOAT) as dayly_avg
  FROM variable_data, reading_events
  INNER JOIN devices
    ON reading_events.device_id = devices.id
  WHERE
    date_trunc('day', reading_events.created_at) between date_trunc('day', now()::DATE - end_last_day) and date_trunc('day', now()::DATE - start_last_day) and
    sensor_id = sensor
  GROUP BY device_id, particle_id
), avg_last_week as (
  SELECT
    device_id,
    particle_id,
    round(SUM(end_read * (seconds_until_next_read )::FLOAT)/SUM(seconds_until_next_read)::FLOAT) as dayly_avg
  FROM variable_data, reading_events
  INNER JOIN devices
    ON reading_events.device_id = devices.id
  WHERE
    date_trunc('day', reading_events.created_at) between date_trunc('day', now()::DATE - end_last_week) and date_trunc('day', now()::DATE - start_last_week) and
    sensor_id = sensor
  GROUP BY device_id, particle_id
)

SELECT
  avg_last_week.device_id,
  avg_last_week.particle_id,
  avg_last_day.dayly_avg - avg_last_week.dayly_avg as difference
FROM avg_last_day, avg_last_week
WHERE avg_last_day.device_id = avg_last_week.device_id and avg_last_day.particle_id = avg_last_week.particle_id
ORDER by device_id, particle_id

/* MES ANTERIOR COMPARADO CON EL OTRO MES */

WITH variable_data as (
  SELECT  1 as sensor
), avg_last_day as (
  SELECT
    device_id,
    particle_id,
    round(SUM(end_read * (seconds_until_next_read )::FLOAT)/SUM(seconds_until_next_read)::FLOAT) as dayly_avg
  FROM variable_data, reading_events
  INNER JOIN devices
    ON reading_events.device_id = devices.id
  WHERE
    date_trunc('month', reading_events.created_at) = date_trunc('month', now()::DATE - interval '1 month') and
    sensor_id = sensor
  GROUP BY device_id, particle_id
), avg_last_week as (
  SELECT
    device_id,
    particle_id,
    round(SUM(end_read * (seconds_until_next_read )::FLOAT)/SUM(seconds_until_next_read)::FLOAT) as dayly_avg
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
  avg_last_day.dayly_avg - avg_last_week.dayly_avg as difference
FROM avg_last_day, avg_last_week
WHERE avg_last_day.device_id = avg_last_week.device_id and avg_last_day.particle_id = avg_last_week.particle_id
ORDER by device_id, particle_id
