-- Create the table for 2017 data
CREATE TABLE spotify_history_2017 (
    ts TIMESTAMP,
    ms_played INT,
    master_metadata_track_name TEXT,
    master_metadata_album_artist_name TEXT,
    master_metadata_album_album_name TEXT
);

---

-- Load data from the CSV file into the table
COPY spotify_history_2017
FROM 'C:/Users/kcalo/Desktop/Bootcamp/My-Spotify-Extended-History/cleaned_data/csv/spotify_2017_fixed.csv'
WITH (FORMAT csv, HEADER, DELIMITER ',');

---

-- Check the total number of records
SELECT COUNT(*) FROM spotify_history_2017;

-- Preview the first 10 rows
SELECT * FROM spotify_history_2017 LIMIT 10;

-- Check for missing data
SELECT COUNT(*) 
FROM spotify_history_2017 
WHERE ts IS NULL OR ms_played IS NULL OR master_metadata_track_name IS NULL;

-- Listening Trends
-- Top 10 Most Played Songs (Total Play Count)
SELECT master_metadata_track_name, master_metadata_album_artist_name, 
       COUNT(*) AS total_play_count
FROM spotify_history_2017
GROUP BY master_metadata_track_name, master_metadata_album_artist_name
ORDER BY total_play_count DESC
LIMIT 10;

-- Get server IP address
SELECT inet_server_addr();

-- Top 10 Artists
SELECT master_metadata_album_artist_name, 
       COUNT(*) AS play_count, 
       SUM(ms_played) AS total_playtime_ms
FROM spotify_history_2017
GROUP BY master_metadata_album_artist_name
ORDER BY total_playtime_ms DESC
LIMIT 10;

-- Listening Behavior Analysis
-- Peak listening hours
SELECT EXTRACT(HOUR FROM ts) AS hour, COUNT(*) AS play_count
FROM spotify_history_2017
GROUP BY hour
ORDER BY hour; 

-- Peak listening hours categorized into time periods
SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM ts) BETWEEN 0 AND 5 THEN 'Late Night (12AM-5AM)'
        WHEN EXTRACT(HOUR FROM ts) BETWEEN 6 AND 11 THEN 'Morning (6AM-11AM)'
        WHEN EXTRACT(HOUR FROM ts) BETWEEN 12 AND 17 THEN 'Afternoon (12PM-5PM)'
        ELSE 'Evening (6PM-11PM)'
    END AS time_period,
    COUNT(*) AS play_count
FROM spotify_history_2017
GROUP BY time_period
ORDER BY play_count DESC;

-- Most Active Listening Days
SELECT TO_CHAR(ts, 'Day') AS day_of_week, COUNT(*) AS play_count
FROM spotify_history_2017
GROUP BY day_of_week
ORDER BY play_count DESC;

-- Weekends vs. Weekdays Listening Patterns
SELECT 
    CASE 
        WHEN EXTRACT(DOW FROM ts) IN (0, 6) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    EXTRACT(HOUR FROM ts) AS hour,
    COUNT(*) AS play_count
FROM spotify_history_2017
GROUP BY day_type, hour
ORDER BY day_type, hour;

-- Monthly Listening Trends
SELECT TO_CHAR(ts, 'YYYY-MM') AS month, COUNT(*) AS play_count
FROM spotify_history_2017
GROUP BY month
ORDER BY month;

-- My Top Songs of 2017
SELECT 
    master_metadata_track_name AS track, 
    master_metadata_album_artist_name AS artist, 
    COUNT(*) AS play_count
FROM spotify_history_2017
GROUP BY track, artist
ORDER BY play_count DESC
LIMIT 100;