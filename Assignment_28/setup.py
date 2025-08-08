from setuptools import setup, find_packages
from typing import List

def get_requirements(file_path: str) -> List[str]:

    """
    This function returns a list of requirements from the given file path.
    """
    requairements = []
    with open(file_path) as file_obj:
        requairements = file_obj.readlines()
        requairements = [req.replace("\n", "") for req in requairements]
        if '-e .' in requairements:
            requairements.remove('-e .')
    return requairements


setup(
    name='Crypto-ML',
    version='0.0.1',
    author='Gaurav',
    author_email="gaurabsin333@gmail.com",
    packages=find_packages(),
    install_requires=get_requirements('requirements.txt')
)