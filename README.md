# symfio-contrib-bower

> Install components from the Bower repository to the public directory.

[![Build Status](http://teamcity.rithis.com/httpAuth/app/rest/builds/buildType:id:bt11,branch:master/statusIcon?guest=1)](http://teamcity.rithis.com/viewType.html?buildTypeId=bt11&guest=1)
[![Dependency Status](https://gemnasium.com/symfio/symfio-contrib-bower.png)](https://gemnasium.com/symfio/symfio-contrib-bower)

## Usage

```coffee
symfio = require "symfio"

container = symfio "example", __dirname
container.set "components", ["jquery", "bootstrap"]

loader = container.get "loader"
loader.use require "symfio-contrib-bower"

loader.load()
```

## Can be configured

* __public directory__ — Default is `public`.
* __components__ - Array of bower components for installation. Default is empty.
