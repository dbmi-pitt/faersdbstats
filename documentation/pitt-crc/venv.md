# Virtual Environments in the CRC

This guide outlines how to install packages with [`uv`](https://github.com/astral-sh/uv) in an interactive SLURM session on the [Pitt CRC Cluster](https://crc.pitt.edu/), especially when building packages like NumPy that require a modern compiler toolchain.

The below instructions will focus on `uv` but `venv` or `conda` will follow almost the exact steps with slight variation.

The Pitt CRC login nodes use an older default version of GCC, which is incompatible with moderm Python packages like NumPy 1.26+. To resolve this, you must:

1. Request an interactive job
2. Load a newer GCC module
3. Install the pakcages in the virtual environment


## Requesting an Interactive Shell

To request an interactive SLURM session:

```shell
srun -n1 -t02:00:00 --qos=short --pty bash # 1 core compute node with a 2-hour walltime
```

Tip: create an alias in your `.bashrc` file to more quickly access interactive shells:

```shell
alias sinteractive='srun -n1 -t02:00:00 --qos=short --pty bash'
```

## Setting Up the Build Environment

To setup the right build toolchain, find which version of gcc your packages need. The latest [available version of gcc](https://crc-pages.pitt.edu/user-manual/applications/software-list/) is usually a safe bet:

```shell
module load gcc/12.2.0
export CC=$(which gcc)
export CXX=$(which g++)
```

## Install the Package Manager

We're installing `uv` in this example, which isn't available as a module by the Pitt CRC. Luckily, `uv` is non-root software, so can be installed with:

```shell
curl -LsSf https://astral.sh/uv/install.sh | sh
```

## Installing Packages

Now you can install packages to the virtual environment with:

```shell
uv sync # OR `uv add ...` OR `uv pip install ...`
```

Once the package is installed, other SLURM sessions or even the login shell can use those packages by activating the virtual environment.
