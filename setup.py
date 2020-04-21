#!/usr/bin/env python3

import setuptools

with open("README.md") as f:
    long_description = f.read()

version = "0.1.0"
print("""------------------------
Installing dbpi version {}
------------------------
""".format(version))

setuptools.setup(
    name='dbpi',
    version=version,
    url='https://github.com/ohmeta/dbpi',
    license='GPLv3',
    author='Jie Zhu',
    author_email='zhujie@genomics.cn',
    description='a pipeline to construct a database catalogue for microbiome research',
    long_description=long_description,
    long_description_content_type='text/markdown',
    packages=['dbi'],
    package_data={'dbpi': ['dbpi/corer.py',
                           'dbpi/__init__.py'
                           ]},
    include_package_data=True,
    install_requires=['pandas', 'ruamel.yaml'],
    zip_safe=False,
    entry_points={
        'console_scripts': [
            'dbpi = dbpi.corer:main']
    },
    classifiers=[
        'Environment :: Console',
        'Intended Audience :: Developers',
        'Intended Audience :: Science/Research',
        'License :: OSI Approved :: GNU General Public License v3 (GPLv3)',
        'Natural Language :: English',
        'Operating System :: OS Independent',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Topic :: Scientific/Engineering :: Bio-Informatics',
    ],
    python_requires='>=3.5',
)

print("""
---------------------------------
dbpi installation complete!
---------------------------------
For help in running dbpi, please see the documentation available
at https://github.com/ohmeta/dbpi or run dbpi --help
""")
