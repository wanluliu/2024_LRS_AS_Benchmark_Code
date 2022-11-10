# `proc_profiler` -- A Python-Implemented Process Profiler for GNU/Linux

```{warning}
This application is for GNU/Linux **ONLY**.
```

**Markdown Compatibility Guide**: This readme is written in MyST-Flavor Markdown. If you have problem previewing it, please download Microsoft Visual Studio Code and install a plugin with ID [ExecutableBookProject.myst-highlight](https://marketplace.visualstudio.com/items?itemName=ExecutableBookProject.myst-highlight).

## Introduction

This is `proc_profiler`, a process-level general-purposed process profiler, which may record performance of a program written in arbitrary language.

This project is considered a part of GPMF -- General Purposed Maintenance Framework, but can be distributed by itself. The execution of this project do not need GPMF, while developing and maintenance of this project requires it as a submodule of current GPMF release.

The project is built at the top of [psutil](https://psutil.readthedocs.io/en/latest/).

## Dependencies

This project is coded under Python (CPython implementation) and R, so please install its interpreters. Recommended Python version >= 3.7 and R version >= 4.0.0.

## Installation

Build the simulator using:

```shell
python3 setup.py sdist
pip install dist/proc_profiler-0.3.2.tar.gz
```

## Quickstart: `proc_profiler`

`proc_profiler` is a Python module which may trace a command like `strace`.

### Using `bin/proc_profiler.sh` Wrapper

Usage: `python -m pid_monitor trace_cmd [CMD]`.

e.g. To monitor resource consumption in `xz -9 -T0 github_data_TGS.tar`, one can execute following command:

```shell
python -m pid_monitor trace_cmd xz -9 -T0 github_data_TGS.tar
```

You will get a output like:

```text
CPU%: 7.74%; VIRTUALMEM: AVAIL: 39.39GiB/62.49GiB=(63.03%), BUFFERED: 4.70GiB, SHARED: 1010.11MiB; SWAP: AVAIL: 0.00B/0.00B=(NA) 
+---------+---------+-------+----------+-------+----------+--------------+-------------+-------------------+
|   PID   |   PPID  |  NAME |   STAT   |  CPU% | CPU_TIME | RESIDENT_MEM | NUM_THREADS | NUM_CHILD_PROCESS |
+---------+---------+-------+----------+-------+----------+--------------+-------------+-------------------+
| 2883092 | 2883045 | xz    | sleeping | 2814% |  12.96   |  956.00MiB   |      36      |         0         |
+---------+---------+-------+----------+-------+----------+--------------+-------------+-------------------+
```

which clears and repeats for several time, with output data in a directory like `proc_profiler_sleep_a38699b2-2755-4347-9e38-699c546df1dc/`.


```{warning}
Do not use this application to trace Shell Built-ins like `echo` or `time` in GNU Bash.
```

## FAQ

- Q: `python: No module named proc_monitor` with exit value 1.
- A: Please make sure that you have correctly installed the module. You may chack whether the Python you called is the same as `pip` called.
