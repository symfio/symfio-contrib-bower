# symfio-contrib-bower

> Bower plugin for Symfio.

[![Build Status](https://travis-ci.org/symfio/symfio-contrib-bower.png?branch=master)](https://travis-ci.org/symfio/symfio-contrib-bower) [![Dependency Status](https://gemnasium.com/symfio/symfio-contrib-bower.png)](https://gemnasium.com/symfio/symfio-contrib-bower)

## Usage

```coffee
symfio = require "symfio"

container = symfio "example", __dirname

container.set "components", ["jquery", "bootstrap"]

container.inject require "symfio-contrib-express"
container.inject require "symfio-contrib-assets"
container.inject require "symfio-contrib-bower"
```

## Dependencies

* [contrib-assets](https://github.com/symfio/symfio-contrib-assets)

## Configuration

### `components`

Array of bower components for installation. Default is `[]`.

### `componentsDirectory`

Default is `public/bower_components`.

## Services

### `bower`

Original `bower` module.

### `installBowerComponents`

Function used to load fixtures after all plugins is loaded.
