SET SCHEMA 'test_db';

CREATE TABLE test_table
(
    id   uuid        NOT NULL DEFAULT uuid_generate_v4(),
    name varchar(20) NOT NULL,
    CONSTRAINT id PRIMARY KEY (id)
);