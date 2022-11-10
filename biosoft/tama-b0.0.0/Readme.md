# Readme of `TAMA-b0.0.0`

The TAMA package is migrated from LabW GPU server (internal). Some piror information is as follows:

- The installation instruction specified in at [TAMA Wiki](https://github.com/GenomeRIK/tama.wiki) `27800b6a6b16b0e3ede00ceee1d95fafb54353f3` specified that this application should be run in Python 2.
- The top-level Python files `tama_collapse.py` and `tama_merge.py` have a mixed Python 2 and 3 syntax (e.g., use both `print` statement (Python 2) and `print()` function (Python 3); use `from StringIO import StringIO` (Python 2, in Python 3 should be `from io import StringIO`)).
- The debugged working version on LabW GPU server uses Python 3.

So, Python 3 was used with Python 2 statements removed manually. A patch file created by `git diff` is at `2022-02-24.patch`.
