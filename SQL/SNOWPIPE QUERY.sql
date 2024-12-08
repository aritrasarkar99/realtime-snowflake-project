// Creating external stage (create your own bucket)
CREATE OR REPLACE STAGE SCD_DEMO.SCD2.customer_ext_stage
    url='s3://realtime-snowflake-bucket/stream_data/'
    credentials=(aws_key_id='' aws_secret_key='');
   

CREATE OR REPLACE FILE FORMAT SCD_DEMO.SCD2.CSV
TYPE = CSV,
FIELD_DELIMITER = ","
SKIP_HEADER = 1;

SHOW STAGES;
LIST @customer_ext_stage;


CREATE OR REPLACE PIPE customer_s3_pipe
  auto_ingest = true
  AS
  COPY INTO customer_raw
  FROM @customer_ext_stage
  FILE_FORMAT = CSV
  ;

ALTER PIPE customer_s3_pipe SET PIPE_EXECUTION_PAUSED = TRUE;

SELECT count(*) FROM CUSTOMER_RAW;

show pipes;
select SYSTEM$PIPE_STATUS('customer_s3_pipe');

SELECT count(*) FROM customer_raw limit 10;

TRUNCATE  customer_raw;