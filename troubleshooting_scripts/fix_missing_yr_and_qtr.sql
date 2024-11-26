
--running now  
UPDATE faers.demo
SET
    yr = SUBSTRING(filename FROM 5 FOR 2)::int,
    qtr = SUBSTRING(filename FROM 8 FOR 1)::int
WHERE
    (qtr IS NULL OR yr IS NULL)
  AND filename ~ '^\w{4}\d{2}Q\d\.txt$'; -- Matches expected filename structure
--930154

UPDATE faers.drug
SET
    yr = SUBSTRING(filename FROM 5 FOR 2)::int,
    qtr = SUBSTRING(filename FROM 8 FOR 1)::int
WHERE
    (qtr IS NULL OR yr IS NULL)
  AND filename ~ '^\w{4}\d{2}Q\d\.txt$'; -- Matches expected filename structure


UPDATE faers.indi
SET
    yr = SUBSTRING(filename FROM 5 FOR 2)::int,
    qtr = SUBSTRING(filename FROM 8 FOR 1)::int
WHERE
    (qtr IS NULL OR yr IS NULL)
  AND filename ~ '^\w{4}\d{2}Q\d\.txt$'; -- Matches expected filename structure


UPDATE faers.reac
SET
    yr = SUBSTRING(filename FROM 5 FOR 2)::int,
    qtr = SUBSTRING(filename FROM 8 FOR 1)::int
WHERE
    (qtr IS NULL OR yr IS NULL)
  AND filename ~ '^\w{4}\d{2}Q\d\.txt$'; -- Matches expected filename structure


UPDATE faers.rpsr
SET
    yr = SUBSTRING(filename FROM 5 FOR 2)::int,
    qtr = SUBSTRING(filename FROM 8 FOR 1)::int
WHERE
    (qtr IS NULL OR yr IS NULL)
  AND filename ~ '^\w{4}\d{2}Q\d\.txt$'; -- Matches expected filename structure

UPDATE faers.ther
SET
    yr = SUBSTRING(filename FROM 5 FOR 2)::int,
    qtr = SUBSTRING(filename FROM 8 FOR 1)::int
WHERE
    (qtr IS NULL OR yr IS NULL)
  AND filename ~ '^\w{4}\d{2}Q\d\.txt$'; -- Matches expected filename structure