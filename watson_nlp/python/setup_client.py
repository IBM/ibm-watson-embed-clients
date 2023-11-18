# *****************************************************************
#
# Licensed Materials - Property of IBM
#
# (C) Copyright IBM Corp. 2022. All Rights Reserved.
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
#
# *****************************************************************


"""A setuptools based setup module.

See:
https://packaging.python.org/guides/distributing-packages-using-setuptools/
https://github.com/pypa/sampleproject
"""

# (From https://github.com/pypa/sampleproject/blob/main/setup.py)

# Standard
import os
import re

# Third Party
# Always prefer setuptools over distutils
from setuptools import setup

# This wheel packages the generated client code for the runtime
version = os.getenv("PYTHON_RELEASE_VERSION")
lib_name = os.getenv("LIB_NAME")


def clean_library_name(lib_name):
    match = re.search(r"[\[\]0-9\.>=< ]+", lib_name)
    if match:
        return lib_name[: match.start()]
    return lib_name


# base directory (location of this file)
base_dir = os.path.dirname(os.path.realpath(__file__))

# read requirements from file
with open(os.path.join(base_dir, "requirements.txt")) as filehandle:
    requirements = filehandle.read().splitlines()

# In this case the source code sits in `generated` while we want the package to be named
# `{library}_runtime_client`. We use the `package_dir` map to tell setuptools to look in a
# different directory.
client_lib_name = f"{clean_library_name(lib_name)}_runtime_client"
package_dir = {
    client_lib_name: "generated",
    "watson_nlp_data_model": "generated/watson_nlp_data_model",
    "caikit_data_model": "generated/caikit_data_model",
    "caikit_data_model.common": "generated/caikit_data_model/common",
    "caikit_data_model.common.runtime": "generated/caikit_data_model/common/runtime",
    "caikit_data_model.runtime": "generated/caikit_data_model/runtime",
    "caikit.runtime.WatsonNlp": "generated/caikit/runtime/WatsonNlp",
}
packages=[client_lib_name,
          "caikit.runtime.WatsonNlp",
          "watson_nlp_data_model", 
          "caikit_data_model", 
          "caikit_data_model.runtime", 
          "caikit_data_model.common", 
          "caikit_data_model.common.runtime"]
setup(
    name=client_lib_name,
    version=version,
    description=f"Watson Embedded AI runtime client library for {lib_name.capitalize()}",
    install_requires=requirements,
    package_dir=package_dir,
    packages=packages,
    license="Apache 2.0",
    author="IBM Watson Embed",
    author_email="aifound@us.ibm.com",
    long_description="""
    # Watson Embedded AI runtime client libraries
    """,
    long_description_content_type="text/markdown",
    url="https://github.com/IBM/ibm-watson-embed-clients/",
    include_package_data=True,
    keywords="language, nlp, categories"
    + " classification, concepts,"
    + " detag, emotion, "
    + "entityMentions, langDetect, keywords, "
    + "nounPhrases, relations, sentiment, "
    + " syntax, watson, ibm, dialog, user modeling",
    # classifiers=[
    #     "Programming Language :: Python",
    #     "Programming Language :: Python :: 2",
    #     "Programming Language :: Python :: 3",
    #     "Development Status :: 5 - Production/Stable",
    #     "Intended Audience :: Developers",
    #     "License :: OSI Approved :: Apache Software License",
    #     "Operating System :: OS Independent",
    #     "Topic :: Software Development :: Libraries :: Python Modules",
    #     "Topic :: Software Development :: Libraries :: Application " "Frameworks",
    # ],
)
