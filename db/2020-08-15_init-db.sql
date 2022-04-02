DROP TABLE IF EXISTS person;

CREATE TABLE person (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    company_name VARCHAR NOT NULL
);

DROP TABLE IF EXISTS location;
CREATE TABLE location (
    id SERIAL PRIMARY KEY,
    person_id INT NOT NULL,
    coordinate GEOMETRY NOT NULL,
    creation_time TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (person_id) REFERENCES person(id)
);

DROP INDEX IF EXISTS coordinate_idx;
CREATE INDEX coordinate_idx ON location (coordinate);

DROP INDEX IF EXISTS creation_time_idx;
CREATE INDEX creation_time_idx ON location (creation_time);
