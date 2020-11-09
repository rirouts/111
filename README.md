# Patient Data Manager - Backend Server

## About

This project is the backend for the Patient Data Manager.

## Quick Start

### System Requirements

 - Ruby, v2.6.3 or higher ([rvm](https://rvm.io/) is recommended for managing multiple versions of Ruby)
 - PostgreSQL, v9.4 or higher, running on port 5432

### Installation
```sh
gem install bundler
bundle install
bundle exec rake db:setup
```

### Running via Docker with a disposable database
```
export SECRET_KEY_BASE=`openssl rand -hex 64`
docker-compose -f docker-compose.yaml up
```

# finally, to confirm it worked -- should see "<#> runs, <#> assertions, 0 failures, 0 errors, 0 skips" at the end
bundle exec rake test
```

### Usage
```sh
bundle exec rails s
```

To optionally specify port: (default is 3000 if not specified)

```sh
bundle exec rails s --port 7001
```

To execute the test suite:

```sh
bundle exec rake test
```

### Configuring the front end

At present, the CORS headers required to run the front end on a different server are commented out. If the front end is running on a different web server, you will need to add back in the `Rack::Cors` middleware in `config/application.rb` before it will work.

## Contributing to PDM

We love your input! We want to make contributing to this project as easy and transparent as possible, whether it's:

* Reporting a bug
* Discussing the current state of the code
* Submitting a fix
* Proposing new features
* Becoming a maintainer

### We Develop with Github

We use github to host code, to track issues and feature requests, as well as accept pull requests.

### We Use [Github Flow](https://guides.github.com/introduction/flow/index.html), So All Code Changes Happen Through Pull Requests

Pull requests are the best way to propose changes to the codebase. We actively welcome your pull requests:

* Fork the repo and create your branch from master.
* If you've added code that should be tested, add tests.
* If you've changed APIs, update the documentation.
* Ensure the test suite passes.
* Make sure your code lints.
* Issue that pull request!

### Any contributions you make will be under the Apache 2 Software License

In short, when you submit code changes, your submissions are understood to be under the same Apache 2 license that covers the project. Feel free to contact the maintainers if that's a concern.

### Report bugs using Github's issues

We use GitHub issues to track public bugs. Report a bug by opening a new issue it's that easy!

### Write bug reports with detail, background, and sample code

Great Bug Reports tend to have:

* A quick summary and/or background
* Steps to reproduce
* Be specific!
* Give sample code if you can. 
* What you expected would happen
* What actually happens
* Notes (possibly including why you think this might be happening, or stuff you tried that didn't work)
* People love thorough bug reports. I'm not even kidding.

### Use a Consistent Coding Style

The PDM project uses Rubocop as a means to ensure code style consistency.  This is run as part of the test suite.  Contributions that do not pass the conformance tests will be rejected.

# License
Copyright 2018, 2019 The MITRE Corporation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
