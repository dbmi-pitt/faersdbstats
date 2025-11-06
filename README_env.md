# README — Pentaho (PDI) 9.2: parameters, variables and environment

Compact reference for how parameters, variables and environment values work in Pentaho Data Integration (Spoon/Kettle/Pan/Kitchen) 9.2, plus recommended patterns.

Source / further reading (validated links)

- Official Pentaho documentation site (general product docs — browse to Data Integration and select version):
  - https://docs.pentaho.com/  (HTTP 200)

- Pentaho developer / product wiki (useful how-to and parameters pages):
  - https://pentaho-public.atlassian.net/wiki/  (HTTP 200)

- Hitachi Vantara community and product pages:
  - https://community.hitachivantara.com/ (community forum and articles)

- Archived Pentaho 9.2 documentation (stable fallback if vendor pages redirect/are unavailable):
  - https://web.archive.org/web/*/https://help.pentaho.com/Documentation/9.2/

Note: `help.pentaho.com` and `help.hitachivantara.com` occasionally redirect to maintenance/proxy pages or have TLS behaviors that can break scripted checks. For reproducible references use `docs.pentaho.com` or the Wayback Machine snapshots for the 9.2-specific pages.

## 1) Terminology: parameters vs variables
- Parameter: a declared input to a Job or Transformation (Settings → Parameters). Intended as explicit inputs set at runtime.
- Variable: a name/value pair referenced with ${NAME}. Variables can come from `kettle.properties`, job entries/steps (Set Variables), or be inherited/passed from parent jobs.

## 2) Where values come from (priority / lookup order)
When PDI resolves `${NAME}` the effective priority (high → low) is typically:

- Explicit parameters passed at runtime (Spoon run dialog or pan/kitchen parameter flags).
- Variables set by the calling job (Set Variables) or passed down from parent jobs via parameter mapping or "Pass all variables".
- Values defined in `kettle.properties` (user: `~/.kettle/kettle.properties` or installation-level kettle.properties).
- System environment variables (OS) — these are available only if you expose them (see below).

## 3) Declaring and using parameters
- In Spoon: Job/Transformation → Edit → Settings → Parameters. Give name, default value and description.
- Use in jobs/transforms as `${PARAM_NAME}`.
- Override at runtime:
  - Spoon run dialog: enter parameter values.
  - CLI: pass parameters to `pan`/`kitchen` (example below).

Best practice: use Parameters for inputs that change between runs (year, quarter, filenames, schemas). They create a clear contract.

## 4) `kettle.properties` (persistent variables)
- Location: typically `~/.kettle/kettle.properties` (or PDI installation conf folder). Values are available as `${NAME}`.
- Use for site/machine defaults (DB hosts, base paths). Changes require restarting Spoon or reloading the environment.

## 5) OS environment variables
- Pentaho runs in the JVM. OS env vars are not automatically mapped to PDI parameters. To make them available:
  - Add them to `kettle.properties` (set them when starting the job runner), or
  - Pass them explicitly as parameters to `pan`/`kitchen`, or
  - Map them into job parameters when invoking sub-jobs.

## 6) Setting variables at runtime
- Use the "Set Variables" job entry (or a step in a transform) to set variables during execution.
- Scope matters: Set Variables lets you control whether a variable is local to the transform, visible to the parent job, or set in the JVM.
- If a transform computes a value that the parent needs, prefer returning rows/results to the parent and let the parent set parameters/variables explicitly.

## 7) Passing values between parent and sub-job/transform
- Parent → sub-job: use the Job entry's parameter mapping or "Pass all variables" (use with caution).
- Sub-job → parent: use Copy rows to result / Get rows from result, or Set Variables with an appropriate scope so the parent can read them.

## 8) Common pitfalls and recommendations
- Don't rely on Set Variables to mutate declared parameters — treat parameters as inputs; return values to the parent instead.
- Avoid broad use of JVM-global variables; they make runs harder to reproduce.
- Prefer parameters + explicit mapping for reproducibility; `kettle.properties` for machine defaults only.
- When automating (cron/systemd/airflow), always pass parameters explicitly on the CLI.

## 9) Debugging tips
- Use Spoon's run dialog to preview parameter values.
- Add a small ExecSQL or Script step at the start of a job to log `${VAR}` values so you can confirm what was resolved.
- If behavior differs between Spoon and pan/kitchen, compare `kettle.properties` and the environment under which the process runs.

## 10) Examples
- Access parameter `LOAD_NEW_YEAR` in a transform: `${LOAD_NEW_YEAR}`
- Example `kettle.properties` entries:
```
DB_HOST=localhost
DB_PORT=5432
```
Use them as `${DB_HOST}` / `${DB_PORT}`.

- Example CLI parameter usage (adapt to your pan/kitchen wrapper):
```
# Run a transformation and set parameters (example)
pan.sh -file=/path/to/transform.ktr -param:LOAD_NEW_YEAR=2025 -param:LOAD_NEW_QTR=2

# Run a job and set parameters
kitchen.sh -file=/path/to/job.kjb -param:LOAD_NEW_YEAR=2025 -param:LOAD_NEW_QTR=2
```

## 11) Local example / want me to add repo-specific commands?
If you want, I can add a short local section with the exact `pan`/`kitchen` flags and the `kettle.properties` path used on this host, plus a mini example showing explicit parent→sub-job parameter mapping. Reply with "yes — add local examples" and I'll update this file.

---
_Last edited: Oct 15, 2025_

