# Web crawler

Crawls a website for all the internal links to provide guidance.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine 
for development and testing purposes.

### Quick set up

```bash
  docker build -t webcrawler .
  docker run webcrawler:latest "bin/clean_cache && bin/web_crawler --url https://b-social.com"
```

### Prerequisites

You'll need following tools installed:

* https://brew.sh/ or later on use https://dreampuf.github.io/GraphvizOnline/
* https://rvm.io/

### Usage

```bash
bin/clean_cache && bin/web_crawler --url https://b-social.com
```

This produces following:

* table of healthy pages
* table of pages that could use some looking into (non 200 pages)
* a dot file showing relationships between pages

In order to convert dot use run this or use https://dreampuf.github.io/GraphvizOnline/
```bash
dot -Tpng diagram.dot -o diagram.png
```

#### Example output

![Example ouput](docs/diagram.png)

### Installing

Project uses Ruby 2.5.1

Install Ruby and Bundler
```
rvm install $(cat .ruby-version )
gem install bundler
```

Install all dependencies

```
bundle install
```

That's it, now it's all set up!

## Running the tests

```bash
rspec
```

### And coding style tests

```
bundle exec rubocop
```

## Deployment

This is a demo project which is meant to be ran locally

## TODO

* cache per domain and per environment so that users don't have to think about cache that much
* figure out how to write integration tests that don't talk to internet (maybe running a tiny dockerized website?)
* cache system that persists after every batch
* dot takes ages on non trivial sites (didn't complete under couple of hours for Monzo and the dot file had only 1MB) maybe d3.js for visualization
* set up a CI pipeline
