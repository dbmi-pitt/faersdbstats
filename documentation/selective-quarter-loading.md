```mermaid
graph TD
A[stage_0_*
load .config vars] --qtr and YY in env--> B[stage_1_*
set aws credentials
download qtr data
upload to s3 bucket]
B -- download from s3 
into staged location--> C[stage_2_*
load from staged location]
C --> D[stage_3_*
load ]
D -->|load| E[stage_4_*]
E -->|load| F[stage_5_*]
F -->|load| G[stage_6_*]
