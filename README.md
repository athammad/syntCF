

# syntCF  <img src="logoSCF.png" width="400"  align="right"/>


### Version `r read.dcf("DESCRIPTION", "Version")`


<!-- badges: start -->
[![img](https://img.shields.io/badge/Lifecycle-Stable-97ca00)](https://github.com/bcgov/repomountie/blob/8b2ebdc9756819625a56f7a426c29f99b777ab1d/doc/state-badges.md)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![R build status](https://github.com/bcgov/bcmaps/workflows/R-CMD-check/badge.svg)](https://github.com/bcgov/bcmaps/actions)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/bcmaps)](https://cran.r-project.org/package=bcmaps) [![CRAN Downloads](https://cranlogs.r-pkg.org/badges/bcmaps?color=brightgreen)](https://CRAN.R-project.org/package=bcmaps) 
<!-- badges: end -->



## Overview

`syntCF`is an [R](https://www.r-project.org) package that provides a set of tools to estimate the effect of a program or a policy using a robust time series synthetic counterfactual approach coupled with the double difference estimator within a Machine Learning framework. The package is inspired by the methods proposed in following contributions:


- [ ] [Grange, S. K., Carslaw, D. C., Lewis, A. C., Boleti, E., & Hueglin, C. (2018)](https://acp.copernicus.org/articles/18/6223/2018/)
- [ ] [Petetin, H., Bowdalo, D., Soret, A., Guevara, M., Jorba, O., Serradell, K., & Pérez García-Pando, C. (2020)](https://acp.copernicus.org/articles/20/11119/2020/#abstract)
- [ ] [Granella F., Reis L. A., Bosetti V. & Tavoni M. (2020)](https://iopscience.iop.org/article/10.1088/1748-9326/abd3d2)
- [ ] [Hammad, A. T., Falchetta, G., & Wirawan, I. B. M. (2021)](https://iopscience.iop.org/article/10.1088/2515-7620/abffa4)

The library encapsulates different ML algorithms, favoring quantile models to account for uncertainty in the predicted counterfactual time seires.
Classic ML metrics such as RMSE,MAPE and R2, are acompagnied with additional metrics specifically designed to evaluate the goodness of the prediction intervals based on the work of [Gneiting, T., & Raftery, A. E. (2007)](https://viterbi-web.usc.edu/~shaddin/cs699fa17/docs/GR07.pdf).

The final effect estimation is based on a difference-in-difference (DID) to account for any systematic error in the chosen model.

The library is built around `Caret` and `CaretEsamble` to provide the user with a wide variety of algorithms and speeding up training time. 

## Features
**Training & Testing**

**Estimation**

**Stacking**

**Plotting**

For a worked example please refer to the R package documentation where you will find examples and method reference.
## Installation

You can install `syntCF` from CRAN:
```{r, echo=TRUE, eval=FALSE}
install.packages("syntCF")
```

To install the development version of the `syntCF` package, you need to install the `remotes` package then the `syntCF` package.

```{r, echo=TRUE, eval=FALSE}
install.packages("remotes")
remotes::install_github("athammad/syntCF")
```

## Usage

To see the layers that are available, run the `available_layers()` function:
```{r, echo=FALSE, warning=FALSE}
library(bcmaps)
```

```{r, eval=FALSE}
library(bcmaps)
available_layers()
```

Most layers are accessible by a shortcut function by the same name as the object. 
Then you can use the data as you would any `sf` or `Spatial` object. The first time
you run try to access a layer, you will be prompted for permission to download that layer
to your hard drive. Subsequently that layer is available locally for easy future access. For example:

```{r}
library(sf)
bc <- bc_bound()
plot(st_geometry(bc))
```

### Vignettes

After installing the package you can view vignettes by typing `browseVignettes("syntCF")` in your R session.

## Getting Help or Reporting an Issue

To report bugs/issues/feature requests, please file an [issue](https://github.com/athammad/syntCF/issues/).


## Licence

    # Copyright 2022 Province of British Columbia
    # 
    # Licensed under the Apache License, Version 2.0 (the "License");
    # you may not use this file except in compliance with the License.
    # You may obtain a copy of the License at
    # 
    # http://www.apache.org/licenses/LICENSE-2.0
    # 
    # Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
    # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    # See the License for the specific language governing permissions and limitations under the License.
