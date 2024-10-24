#!/bin/bash

# Exit on error
set -e

# Update package index and install necessary packages
sudo apt-get update && \
    sudo apt-get install -y wget git

# Install Miniconda (if not already installed)
if ! command -v conda &> /dev/null; then
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    bash miniconda.sh -b -p $HOME/miniconda
    eval "$($HOME/miniconda/bin/conda shell.bash hook)"
    rm miniconda.sh
    # Initialize conda for the shell
    $HOME/miniconda/bin/conda init bash
fi

# Install Mamba using Conda
conda install -c conda-forge mamba -y

# Clone the PolyFun repository
if [ ! -d "/opt/polyfun" ]; then
    sudo git clone https://github.com/omerwe/polyfun.git /opt/polyfun
fi

# Set the working directory
cd /opt/polyfun

mv /opt/polyfun/polyfun.yml.lock /opt/polyfun/polyfun-lock.txt

# Create the Conda environment using the renamed file
mamba create --name polyfun-lock-env --file polyfun-lock.txt

# Initialize conda for your shell
conda init

# Restart your terminal or source your shell configuration
# For bash, you might need to run:
source ~/.bashrc

# Activate your environment
conda activate polyfun-lock-env
