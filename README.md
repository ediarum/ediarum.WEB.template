# ediarum.WEB.template

© 2022 by Berlin-Brandenburg Academey of Sciences and Humanities

Developed by TELOTA, a DH working group of the Berlin-Brandenburg Academey of Sciences and Humanities  
http://www.bbaw.de/telota  
telota@bbaw.de

For more infomation about **ediarum** see www.ediarum.org.

Lead Developer:

* Martin Fechner


## What does it do?

ediarum.WEB.template contains all files to start a new project with ediarum.WEB.

With the help of ediarum.WEB, developers can build an entire website or just a backend used for XML based digital editions. The different functions of the library support routing, api generation, and frontend templating.

## Documentation

For a full documentation of the features of ediarum.WEB see here: <https://github.com/ediarum/ediarum.WEB>.

An **introduction** how to use ediarum.WEB is available at https://www.ediarum.org/docs/ediarum-web-step-by-step/index.html.

## Development

### Start a new project

1. Create a new directory `ediarum.myproject.web`.
2. Copy all files from this repo into `ediarum.myproject.web`.
3. Update information in `build.properties` (project name, author, etc.)
4. Add information and API endpoints to `appconf.xml`.

### Build the application

Using `ant`

1. `ant build-xar`

Without `ant`

1. Add current information to `expath-pkg.xml`
2. zip root directory as `myproject_v0.1.0.xar`

### Deployment

1. Install the latest `ediarum.web.xar` via eXist-db Dashboard.
2. Install `myproject_v0.1.0.xar` via eXist-db Dashboard.

### Generate an API documentation in the OPENAPI format

## License

ediarum.WEB.template is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

ediarum.WEB.template is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU General Public License
along with ediarum.WEB.template.  If not, see <http://www.gnu.org/licenses/>.

## Third party licences

ediarum.WEB.template includes software from third parties, which are licensed seperately.

### Popper.js

Copyright (C) Federico Zivolo 2018

* Distributed under the MIT License (license terms are at http://opensource.org/licenses/MIT).
