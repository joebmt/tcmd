# tcmd - Functional Test Program and Framework

Simple Shell unit and functional test framework and examples.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

You will need to install the python click library:

```
pip install -r inc/requirements.txt
```

### Installing

Install the framework by running git clone or downloading the zip file.

```
git clone https://github.com/joebmt/tcmd.git
```

## Running the tests

Run the functional tests for tcmd and the prg.sh template:

```
cd tests
test_tcmd.sh
test_prg.sh
```

To run the unit tests in prg.sh template:

```
cd inc
prg_functions.sh
```
### Break down into end to end tests

There are two example tests to use as templates for tcmd:

```
./tests/test_tcmd.sh
./tests/test_prg.sh
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

The framework and description looks like this:

```
.
├── bin
│   ├── b     (utility to backup files recursively)
│   └── tcmd  (functional python test tool to test any command line program)
├── inc
│   ├── prg_functions.sh (include file for prg.sh to run)
│   ├── requirements.txt ("pip install -r requirements.txt" for tcmd python dependencies to install)
│   └── test_utils.sh    (include file for tests/test_prg.sh to run some utility functions)
├── prg.sh    (template for a bash script; source inc/prg_functions.sh)
├── readme.md (this readme.md file)
└── tests
    ├── test_prg.sh      (functional tests for prg.sh using tcmd functional test tool)
    └── test_tcmd.sh     (functional tests for tcmd functional test tool)
```

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Joe Orzehoski** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the Apache License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* stackoverflow

