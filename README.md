[![Build Status](https://travis-ci.org/Jose-Badeau/boomslang-core.svg?branch=master)](https://travis-ci.org/Jose-Badeau/boomslang-core)

# boomslang-core
## Overview
boomslang-core provides the grammar and all the technical infrastructure for the feature and mapping DSL that
are used to define UI tests in a BDD style.The feature DSL is used to define test cases in a BDD style while
re-using wireframesketcher screens to specify the UI on which the actions should happen. The second part of 
the boomslang-core is the grammar of the mapping DSL that is used to define technical locators for the 
elements modeled in the screen files and referenced by the feature files. After all three 
files (screen, feature, and mapping) files are available automated tests can be generated from this specification.
 Since there can be different generators for the same feature and mapping DSL in order to generate for different
 UI (test) frameworks (e.g. one for SWT and one for Web UIs) the generator is handled in a separate repository.
   

## Contribute
To contribute to the boomslang-core just check out the respective branch, import the projects into 
Eclipse using "Import Existing Maven Projects". From the "org.boomslang.targetplatform.remote" set the 
targetplatform. Finally, do a local maven clean install in the root folder. Now you are ready to go.

## Build
boomslang-core comes with a maven build that can be run locally using the standard maven installation.
Besides the local build there is also a travis-ci build engine running on the master branch.  
After a successful build the the repository is uploaded to a bintray repository. Before the upload is started the Directory Cleaner
tool (https://github.com/HBuender/DirectoryCleaner ) is run to delete the existing artifacts from the repository. In
future there might be a composite repository that can hold multiple versions.

## Installation
boomslang-core can be installed using the update-site at: https://dl.bintray.com/jose-badeau/boomslang-core/

## Further Information
Please find further information in the projects wiki at: https://github.com/Jose-Badeau/boomslang-core/wiki