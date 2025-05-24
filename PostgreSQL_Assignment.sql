-- Create Database
CREATE DATABASE conservation_db;
-- Create Rangers Table
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    region TEXT NOT NULL
);

-- Create Species Table
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name TEXT NOT NULL,
    scientific_name TEXT NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status TEXT NOT NULL
);

-- Create Sightings Table
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INTEGER REFERENCES rangers(ranger_id) ON DELETE CASCADE,
    species_id INTEGER REFERENCES species(species_id) ON DELETE CASCADE,
    location TEXT NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    notes TEXT
);

-- Insert sample data into rangers table
INSERT INTO rangers (name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');

-- Insert sample data into species table
INSERT INTO species (common_name,scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard','Panthera uncia','1775-01-01','Endangered'),
('Bengal Tiger','Panthera tigris','1758-01-01','Endangered'),
('Red Panda','Ailurus fulgens','1825-01-01','Vulnerable'),
('Asiatic Elephant','Elephas maximus indicus','1758-01-01','Endangered');

-- Insert sample data into sightings table
INSERT INTO sightings (species_id, ranger_id, sighting_time, location, notes) VALUES
(1, 1, '2024-05-10 07:45:00', 'Peak Ridge', 'Camera trap image captured'),
(2, 2, '2024-05-12 16:20:00', 'Bankwood Area', 'Juvenile seen'),
(3, 3, '2024-05-15 09:10:00', 'Bamboo Grove East', 'Feeding observed'),
(1, 2, '2024-05-18 18:30:00', 'Snowfall Pass', NULL);

-- Problem 1.
INSERT INTO rangers (name, region) VALUES
('Derek Fox','Coastal Plains');

-- Problem 2.
SELECT count(DISTINCT species_id) as unique_species_count FROM sightings;

-- Problem 3.
SELECT * FROM sightings WHERE location ILIKE '%Pass%';

-- Problem 4.
SELECT name, count(*) AS total_sightings FROM rangers 
JOIN sightings USING(ranger_id) GROUP BY ranger_id;

-- Problem 5.
SELECT common_name FROM species WHERE species_id NOT IN (
    SELECT species_id FROM sightings
);

-- Problem 6.
SELECT common_name, sighting_time, name FROM sightings
JOIN species USING(species_id)
JOIN rangers USING(ranger_id)
ORDER BY sighting_time DESC FETCH FIRST 2 ROWS ONLY;

-- Problem 7.
UPDATE species SET conservation_status = 'Historic' 
WHERE EXTRACT(YEAR FROM discovery_date) < 1800;

-- Problem 8.
CREATE OR REPLACE FUNCTION get_time_label(p_time FLOAT)
RETURNS TEXT
LANGUAGE PLPGSQL AS
$$
BEGIN
    IF(p_time < 12) THEN
        RETURN 'Morning';
    ELSEIF (p_time < 17) THEN
        RETURN 'Afternoon';
    ELSE 
        RETURN 'Evening';
    END IF;
END
$$;

SELECT sighting_id, 
get_time_label(EXTRACT(HOUR FROM sighting_time)) AS time_of_day 
FROM sightings;