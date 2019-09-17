CREATE MATERIALIZED VIEW all_morning_classes AS     
    SELECT *
    FROM 
        (SELECT courses.uuid, courses.name, courses.number, 
            CAST(start_time AS float) / 60 AS start_time_in_hours, 
            CAST(end_time AS float) / 60 AS end_time_in_hours,
            subjects.name AS subject_name
        FROM schedules
        JOIN sections ON schedules.uuid = sections.schedule_uuid 
        JOIN course_offerings AS c ON sections.course_offering_uuid = c.uuid
        JOIN courses ON c.course_uuid = courses.uuid
        JOIN subject_memberships ON sections.course_offering_uuid = subject_memberships.course_offering_uuid
        JOIN subjects on subject_memberships.subject_code = subjects.code 
        GROUP BY courses.uuid, courses.name, courses.number, subjects.name, start_time_in_hours, end_time_in_hours
        ORDER BY start_time_in_hours ASC
        ) AS morning_start_times_converted
    WHERE start_time_in_hours BETWEEN 0 AND 12 AND name != 'null';

