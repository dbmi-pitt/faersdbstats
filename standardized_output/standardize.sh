#!/bin/sh

HOST="${POSTGRES_HOST}"
DATABASE=${POSTGRES_DATABASE}
USER="${POSTGRES_USER}"

export PGPASSWORD=${POSTGRES_PASSWORD}

psql -h ${HOST} -U ${USER} -f ./derive_standard_case_outcome_category.sql ${DATABASE}
psql -h ${HOST} -U ${USER} -f ./derive_standard_case_indication.sql ${DATABASE}
psql -h ${HOST} -U ${USER} -f ./derive_standard_case_outcome.sql ${DATABASE}
psql -h ${HOST} -U ${USER} -f ./derive_standard_drug_outcome_count.sql ${DATABASE}

psql -h ${HOST} -U ${USER} -f ./derive_standard_drug_outcome_contingency_table_1.sql ${DATABASE}

echo "run three time consuming queries concurrently"
psql -h ${HOST} -U ${USER} -f ./derive_standard_drug_outcome_contingency_table_2.sql ${DATABASE} &
pid1=$!

psql -h ${HOST} -U ${USER} -f ./derive_standard_drug_outcome_contingency_table_3.sql ${DATABASE} &
pid2=$!

psql -h ${HOST} -U ${USER} -f ./derive_standard_drug_outcome_contingency_table_4.sql ${DATABASE} &
pid3=$!

echo "Waiting approximately 30 hours for these three processes"

# wait for all the queries before running the last set
wait $pid1
wait $pid2
wait $pid3


echo "done waiting"

psql -h ${HOST} -U ${USER} -f ./derive_standard_drug_outcome_contingency_table_5.sql ${DATABASE}

psql -h ${HOST} -U ${USER} -f ./derive_standard_drug_outcome_statistics.sql ${DATABASE}

psql -h ${HOST} -U ${USER} -f ./map_meddra_to_snomed.sql ${DATABASE}

psql -h ${HOST} -U ${USER} -f ./derive_standard_drug_outcome_drilldown.sql ${DATABASE}

echo "Done! Check the tables"
