#include <cmath>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>

// smithlab headers
#include "smithlab_os.hpp"
#include "smithlab_utils.hpp"  //for SMITHLAB_exception

// headers for local code
#include "gsl_fitter.hpp"
#include "loglikratio_test.hpp"
#include "pipeline.hpp"
#include "regression.hpp"
#include "table_row.hpp"

// using block
using std::cerr;
using std::endl;
using std::istringstream;
using std::string;
using std::vector;

int main(int argc, const char** argv) {
  Design full_design(design_encoding);

  vector<string> factor_names = full_design.factor_names();
  // Factors are identified with their indexes to simplify naming.
  size_t test_factor = test_factor_it - factor_names.begin();

  Regression full_regression(full_design);
  Design null_design = full_design;
  null_design.remove_factor(test_factor);
  Regression null_regression(null_design);

  std::vector<size_t> meth_counts;
  std::vector<size_t> total_counts;

  full_regression.set_response(total_counts, meth_counts);
  gsl_fitter(full_regression);

  null_regression.set_response(total_counts, meth_counts);
  gsl_fitter(null_regression);

  double pval = loglikratio_test(
      null_regression.maximum_likelihood(),
      full_regression.maximum_likelihood());
}
