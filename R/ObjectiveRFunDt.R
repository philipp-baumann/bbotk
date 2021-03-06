#' @title Objective interface for basic R functions.
#'
#' @description
#' Objective interface where user can pass an R function that works on an `data.table()`.
#'
#' @template param_domain
#' @template param_codomain
#' @template param_xdt
#' @export
ObjectiveRFunDt = R6Class("ObjectiveRFunDt",
  inherit = Objective,
  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    #'
    #' @param fun (`function`)\cr
    #' R function that encodes objective and expects an `data.table()` as input
    #' whereas each point is represented by one row.
    #' @param id (`character(1)`).
    #' @param properties (`character()`).
    initialize = function(fun, domain, codomain = NULL, id = "function",
      properties = character()) {
      if (is.null(codomain)) {
        codomain = ParamSet$new(list(ParamDbl$new("y", tags = "minimize")))
      }
      private$.fun = assert_function(fun, "xdt")
      # asserts id, domain, codomain, properties
      super$initialize(id = id, domain = domain, codomain = codomain,
        properties = properties)
    },

    #' @description
    #' Evaluates multiple input values received as a list, converted to a `data.table()` on the
    #' objective function.
    #'
    #' @param xss (`list()`)\cr
    #'   A list of lists that contains multiple x values, e.g.
    #'   `list(list(x1 = 1, x2 = 2), list(x1 = 3, x2 = 4))`.
    #'
    #' @return [data.table::data.table()] that contains one y-column for single-criteria functions
    #' and multiple y-columns for multi-criteria functions, e.g.
    #' `data.table(y = 1:2)` or `data.table(y1 = 1:2, y2 = 3:4)`.
    eval_many = function(xss) {
      private$.fun(rbindlist(xss))
    },

    #' @description
    #' Evaluates multiple input values on the objective function supplied by the user.
    #'
    #' @return data.table::data.table()] that contains one y-column for single-criteria functions
    #' and multiple y-columns for multi-criteria functions, e.g.
    #' `data.table(y = 1:2)` or `data.table(y1 = 1:2, y2 = 3:4)`.
    eval_dt = function(xdt) {
      private$.fun(xdt)
    }
  ),

  active = list(

    #' @field fun (`function`)\cr
    #' Objective function.
    fun = function(lhs) {
      if (!missing(lhs) && !identical(lhs, private$.fun)) stop("fun is read-only")
      private$.fun
    }
  ),

  private = list(
    .fun = NULL
  )
)
