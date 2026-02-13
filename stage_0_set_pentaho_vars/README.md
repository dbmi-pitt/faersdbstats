## [Stage 0 Wiki](../../../wiki/Stage-0-Setting-Pentaho-Vars)
## [Stage 1 Wiki](../../../wiki/Stage-1-Setup-Reference-and-Mapping-Data)

### check_and_source_config.sh helper

This repository includes a small helper script: `check_and_source_config.sh`.

- Purpose: ensure config files exist and that ETL variables are set before long-running or batch updates run.
- Location: `stage_0_set_pentaho_vars/check_and_source_config.sh`

Example usage in Shell steps inside KTR/KJB:

```
CONFIG_SCRIPT="${Internal.Transformation.Filename.Directory}/../../stage_0_set_pentaho_vars/check_and_source_config.sh"
CONFIG_PATH="${Internal.Transformation.Filename.Directory}/../../faers_config.config"
if [ -x "$CONFIG_SCRIPT" ]; then
	"$CONFIG_SCRIPT" "$CONFIG_PATH" "LOAD_NEW_YEAR,LOAD_NEW_QUARTER"
else
	echo "Warning: $CONFIG_SCRIPT missing — falling back to direct source"
	[ -f "$CONFIG_PATH" ] && . "$CONFIG_PATH"
fi
```

This pattern reduces the chance of DB insert/constraint failures due to null variables (e.g., `yr`, `qtr`, or `LOAD_NEW_YEAR`) when transforms run or when config files move.

Use-case (Vigi): to prevent the null `yr`/`qtr` insertion that caused the Pentaho failure in the logs, add this check into your job before the `z_qa_wc_import_log` insert step. Example:

```
CONFIG_SCRIPT="${Internal.Transformation.Filename.Directory}/../../stage_0_set_pentaho_vars/check_and_source_config.sh"
CONFIG_PATH="${Internal.Transformation.Filename.Directory}/../../vigi_config.config"
if [ -x "$CONFIG_SCRIPT" ]; then
	"$CONFIG_SCRIPT" "$CONFIG_PATH" "yr,qtr,LOG_FILENAME"
fi
```

This will cause the job to fail early with a descriptive message in the log if `yr` or `qtr` are not set, preventing the DB `NOT NULL` constraint from aborting the batch insert.