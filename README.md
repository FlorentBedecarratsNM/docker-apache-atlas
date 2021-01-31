[![Atlas version](https://img.shields.io/badge/Atlas-2.1.0-brightgreen.svg)](https://github.com/sburn/docker-apache-atlas)
[![License: Apache 2.0](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0.html)

French UI version of Apache Atlas Docker image
=======================================

This is a modified version of the `Apache Atlas` [docker image developed by sburn](https://github.com/sburn/docker-apache-atlas). Please refer to the original image for the technical documentation and credits.
The purpose of this modification is to provided an user interface translated into French. The modifications are introduced by plain text substitutions using the `sed` Linux command directly in the docker file. We use this method to enable easy audit and maintenance of these modifications.
/!\ This docker image is meant for testing purposes. Like the original one by sburn, it runs with root privileges, which is not a good practice regarding safety in a production environment.
