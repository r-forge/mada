\name{reitsma}
\alias{reitsma}
\alias{reitsma.default}

\concept{random effects model}
\concept{diagnostic meta-analysis}
\concept{meta-analysis}

\title{
Fit the bivariate model of Reitsma et al. (2005) and extensions.
}
\description{
The function fits the bivariate model of Reitsma et al. (2005) that Harbord et al. (2007) have shown to be equivalent to the HSROC of Rutter&Gatsonis (2001). We specify the model as a linear mixed model with known variances of the random effects, similar to the computational approach by Reitsma et al. (2005). Variance components are estimated by restricted maximum likelihood (REML) as a default but ML estimation is available as well. In addition meta-regression is possible and the use of other transformations than the logit, using the approach of Doebler et al. (2012).
}
\usage{
reitsma(data, ...)
\method{reitsma}{default}(data = NULL, subset=NULL, formula = NULL,
         TP="TP", FN="FN", FP="FP", TN="TN", 
         alphasens = 1, alphafpr = 1, 
         correction = 0.5, correction.control = "all",
         method = "reml",  
         control = list(), ...)
}
\arguments{
  \item{data}{any object that can be converted to a data frame with integer variables for observed frequencies of true positives, false negatives, false positives and true negatives. The names of the variables  are provided by the arguments \code{TP}, \code{FN}, \code{FP} and \code{TN} (see their defaults). Alternatively the data can be a matrix with column names including \code{TP}, \code{FN}, \code{FP} and \code{TN}. If no \code{data} is specified, the function will check the \code{TP}, \code{FN}, \code{FP} and \code{TN} arguments.
}
  \item{TP}{character or integer: name for vector of integers that is a variable of \code{data} or a vector of integers. If \code{data} is not \code{NULL}, names are expected, otherwise integers are.}
  \item{FN}{character or integer: name for vector of integers that is a variable of \code{data} or a vector of integers. If \code{data} is not \code{NULL}, names are expected, otherwise integers are.}
  \item{FP}{character or integer: name for vector of integers that is a variable of \code{data} or a vector of integers. If \code{data} is not \code{NULL}, names are expected, otherwise integers are.}
  \item{TN}{character or integer: name for vector of integers that is a variable of \code{data} or a vector of integers. If \code{data} is not \code{NULL}, names are expected, otherwise integers are.}
\item{subset}{the rows of \code{data} to be used as a subset in all calculations. If \code{NULL} (the default) then the complete data is considered.}  
 \item{formula}{Formula for meta-regression using standard \code{\link{formula}}. The left hand side of this formula must be \code{cbind(tsens, tfpr)} and if \code{formula} is \code{NULL} (the default), then the formula \code{cbind(tsens, tfpr) ~ 1} is used, i.e. a model without covariates.}
 \item{alphasens}{Transformation parameter for (continuity corrected) sensitivities, see details. If set to 1 (the default) the logit transformation is used.}
 \item{alphafpr}{Transformation parameter for (continuity corrected) false positive rates, see details}
  \item{correction}{numeric, continuity correction applied if zero cells}
  \item{correction.control}{character, if set to \code{"all"} (the default) the continuity correction is added to the whole data if only one cell in one study is zero. If set to \code{"single"} the correction is only applied to rows of the data which have a zero.}
  \item{method}{character, either \code{"fixed"}, \code{"ml"}, \code{"mm"}, \code{"vc"} or \code{"reml"} (the default)}
  \item{control}{a list of control parameters, see the documentation of \code{\link[mvmeta]{mvmeta}}}.
  \item{...}{arguments to be passed on to other functions, currently ignored}
}
\details{
In a first step the observed frequencies are continuity corrected if values of 0 or 1 would result for the sensitivity or false positive rate otherwise. Then the sensitivities and false positive rates are transformed using the transformation
\deqn{
x \mapsto t_\alpha(x) := \alpha\log(x) - (2-\alpha)\log(1-x).
}
Note that for \eqn{\alpha=1}, the default value, the logit transformation results, i.e. the approach of Reitsma et al. (2005). A bivariate random effects model is then fitted to the pairs of transformed sensitivities and false positive rates.

Parameter estimation makes use of the fact that the fixed effect parameters can be profiled in the likelihood. Internally the function \code{\link[mvmeta]{mvmeta}} is called. Currently only standard errors for the fixed effects are available. Note that when using \code{method = "mm"} or \code{method = "vc"}, no likelihood can be computed and hence no AIC or BIC values.

If you want other summary points like negative or positive likelihood ratios, see \code{\link{SummaryPts}}, while for positive or negative predictive values, see \code{\link{predv_r}} and \code{\link{predv_d}}.
}
\value{
An object of the class \code{reitsma} for which many standard methods are available. See \code{\link{reitsma-class}} for details.
}
\references{
Rutter, C., & Gatsonis, C. (2001). \dQuote{A hierarchical regression approach to meta-analysis of
diagnostic test accuracy evaluations.} \emph{Statistics in Medicine}, \bold{20}, 2865--2884.

Reitsma, J., Glas, A., Rutjes, A., Scholten, R., Bossuyt, P., & Zwinderman, A. (2005).
\dQuote{Bivariate analysis of sensitivity and specificity produces informative summary
measures in diagnostic reviews.} \emph{Journal of Clinical Epidemiology}, \bold{58}, 982--990.

Harbord, R., Deeks, J., Egger, M., Whiting, P., & Sterne, J. (2007). \dQuote{A unification of
models for meta-analysis of diagnostic accuracy studies.} \emph{Biostatistics}, \bold{8}, 239--251.

Doebler, P., Holling, H., Boehning, D. (2012) \dQuote{A Mixed Model Approach to Meta-Analysis of Diagnostic Studies with Binary Test Outcome.} \emph{Psychological Methods}, to appear
}
\author{
Philipp Doebler <philipp.doebler@googlemail.com>
}

\seealso{
\code{\link{reitsma-class}}, \code{\link{talpha}}, \code{\link{SummaryPts}}
}
\examples{
data(Dementia)
(fit <- reitsma(Dementia))
summary(fit)
plot(fit)

## Meta-Regression
data(smoking) # contains more than one 2x2-table
## reduce to subset of independent 2x2-tables by using the 
## first table from each study only
smoking1 <- subset(smoking, smoking$result_id == 1)
## use type of questionnaire as covariate
(fit <- reitsma(smoking1, formula = cbind(tsens, tfpr) ~ type))
summary(fit) ## sensitivities significantly lower for SAQ
}

\keyword{regression}
