# symfio-contrib-bower

> Install components from the Bower repository to the public directory.

[![Build Status](http://teamcity.rithis.com/httpAuth/app/rest/builds/buildType:id:bt11,branch:master/statusIcon?guest=1)](http://teamcity.rithis.com/viewType.html?buildTypeId=bt11&guest=1)
[![Dependency Status](https://gemnasium.com/symfio/symfio-contrib-bower.png)](https://gemnasium.com/symfio/symfio-contrib-bower)

## Usage

```coffee
symfio = require "symfio"

container = symfio "example", __dirname

container.set "components", ["jquery", "bootstrap"]

container.use require "symfio-contrib-bower"

container.load()
```

## Can be configured

* __componentsDirectory__ — Default is `public/bower_components` or
  `bower_components`.
* __components__ - Array of bower components for installation. Default is empty.
