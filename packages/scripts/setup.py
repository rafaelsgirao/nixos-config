#!/usr/bin/env python
from setuptools import setup

setup(
    name="scripts",
    version="1.0.0",
    py_modules=["portcheck"],
    entry_points={
        "console_scripts": [
            "portcheck = portcheck:main",
        ]
    },
)
