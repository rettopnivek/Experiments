functions{
  real invgauss_log( real t, real kappa, real xi, real sigma ) {
    // Purpose:
    // Calculates the probability density function for the 
    // finishing time for the Wald distribution (or inverse
    // gaussian) using the parameterization for Brownian motion
    // Arguments:
    // t     - A reaction time (t >= 0)
    // kappa - The threshold towards which the evidence is accumulating 
    //         (k > 0)
    // xi    - The drift rate of the evidence accumulation (xi >= 0)
    // sigma - The coefficient of drift (typically fixed to 1 for 
    //         identifiability
    // Returns:
    // The log density
    
    // Variable declaration
    real p1; real p2; real p3;
    real out;
    
    // Initialize output
    out <- log( 0.0 );
    
    // Calculate log-density
    p1 <- ( kappa/sigma ) / pow( 2.0*pi()*pow( t, 3.0 ), 0.5 );
    p2 <- -pow( kappa/sigma, 2.0 )*pow( t - kappa/xi, 2.0 );
    p3 <- 2.0*pow( kappa/xi, 2.0 )*t;
    
    // Check for inadmissable values
    if ( (kappa > 0.0) && (xi > 0.0) && (sigma > 0.0) && (t > 0.0) ) {
      out <- log(p1) + p2/p3;
    }
    
    return( out );
  }
  real invgauss_cdf( real t, real kappa, real xi, real sigma ) {
    // Purpose:
    // Calculates the distribution function for the 
    // finishing time for the Wald distribution (or inverse
    // gaussian) using the parameterization for Brownian motion
    // Arguments:
    // t     - A reaction time (t >= 0)
    // kappa - The threshold towards which the evidence is accumulating 
    //         (k > 0)
    // xi    - The drift rate of the evidence accumulation (xi >= 0)
    // sigma - The coefficient of drift (typically fixed to 1 for 
    //         identifiability
    // Returns:
    // The value for the cumulative distribution function
    
    // Variable declaration
    real p1; real p2; real p3;
    real out;
  
    // Initialize output
    out <- 0.0;
    
    // Calculate CDF
    p1 <- Phi( kappa*( xi*t/kappa - 1.0)/( sigma*pow( t, 0.5 ) ) );
    p2 <- 2.0*xi*kappa/pow( sigma, 2.0 );
    p3 <- Phi( -kappa*( xi*t/kappa + 1.0)/( sigma*pow( t, 0.5 ) ) );
    
    // Check for inadmissable values
    if ( (kappa > 0.0) && (xi > 0.0) && (sigma > 0.0) && (t > 0.0) ) {
      out <- p1 + exp(p2)*p3;
    }
    
    return( out );
  }
  real invgauss_rng( real kappa, real xi, real sigma ) {
    // Purpose:
    // Generates a random finishing time for the the Wald 
    // distribution (or inverse gaussian) using the 
    // parameterization for Brownian motion
    // Arguments:
    // kappa - The threshold towards which the evidence is accumulating 
    //         (k > 0)
    // xi    - The drift rate of the evidence accumulation (xi >= 0)
    // sigma - The coefficient of drift (typically fixed to 1 for 
    //         identifiability
    // Returns:
    // A random draw from the distribution
    
    // Variable declaration
    real mu; real lambda;
    real v; real z; real y; real x;
    real p1; real p2; real p3;
    real out;
    
    // Convert into standard parameterization for
    // the wald distribution
    mu <- kappa/xi; lambda <- pow(kappa,2.0)/pow(sigma,2.0);
    
    // Check for illegal values
    if ( (mu<=0.0) || (lambda<=0.0) || (sigma<=0.0) ) {
      out <- not_a_number();
    } else {
      // Generate a random draw
      v <- normal_rng(0.0,1.0);
      z <- beta_rng(1.0,1.0);
      y <- pow(v,2.0);
      p1 <- mu + pow(mu,2.0)*y/(2.0*lambda);
      p2 <- mu/(2.0*lambda);
      p3 <- pow(4.0*mu*lambda*y + pow(mu*y,2.0),0.5);
      x <- p1+p2*p3;
      if (z <= mu/(mu+x)) {
        out <- x;
      } else {
        out <- pow( mu, 2.0 )/x;
      }
    }
    
    return(out);
  }
  real waldrace_log( vector x, vector param ) {
    // Purpose:
    // Calculates the log density of the Wald race model
    // (Logan et al., 2014)
    // Arguments:
    // x     - A vector with a response time 't' and choice 'y'
    // param - A vector of 8 elements:
    //         kappa[1] - The upper threshold for the accumulator for choice == 1
    //                    (kappa[1] > 0)
    //         xi[1]    - The drift rate of evidence accumulation for choice == 1
    //                    ( xi[1] > 0 )
    //         sigma[1] - The coefficient of drift for choice == 0 
    //                    (typically fixed to 1; sigma[1] > 0 )
    //         tau[1]   - The residual latency for choice == 1
    //                    ( 0 <= tau[1] < min( t | choice == 1 ) )
    //         kappa[0] - The upper threshold for the accumulator for choice == 0
    //                    (kappa[1] > 0)
    //         xi[0]    - The drift rate of evidence accumulation for choice == 0
    //                    ( xi[1] > 0 )
    //         sigma[0] - The coefficient of drift for choice == 0 
    //                    (typically fixed to 1; sigma[0] > 0 )
    //         tau[0]   - The residual latency for choice == 0
    //                    ( 0 <= tau[0] < min( t | choice == 0 ) )
    // Returns:
    // The log density for the Wald race model
    
    // Variable declarations
    vector[2] t; real y;
    vector[3] g; vector[3] G;
    real out; real cdf;
    
    // Extract responses
    y <- x[2];
    t[1] <- x[1] - y*param[4] - (1.0-y)*param[8]; // density
    t[2] <- x[1] - y*param[8] - (1.0-y)*param[4]; // cdf
    
    // Adjust parameters for winning racer based on choice
    g[1] <- y*(param[1]) + (1.0-y)*param[5];
    g[2] <- y*(param[2]) + (1.0-y)*param[6];
    g[3] <- y*(param[3]) + (1.0-y)*param[7];
    G[1] <- y*(param[5]) + (1.0-y)*param[1];
    G[2] <- y*(param[6]) + (1.0-y)*param[2];
    G[3] <- y*(param[7]) + (1.0-y)*param[3];
    
    // Calculate log density
    cdf <- 1.0;
    if ( t[2] > 0.0 ) cdf <- 1.0 - invgauss_cdf( t[2], G[1], G[2], G[3] );
    out <- invgauss_log( t[1], g[1], g[2], g[3] ) + log( cdf );
    
    return( out );
  }
  matrix param_est( matrix X, vector coef, vector fixed,
                    int[,] index, int[] parSel ) {
    // Purpose:
    // Calculates the linear combination of a design matrix and 
    // a set of coefficients to generate a parameter matrix over 
    // observations
    // Arguments:
    // X      - A V x N design matrix, where V is the number 
    //          of covariates and N is the number of observations
    // coef   - A vector of C coefficients
    // fixed  - A vector of fixed values
    // index  - An 2-dimensional array of integers indexing the position 
    //          in the parameter matrix that corresponds to the 
    //          coefficients, followed by the fixed values. The 
    //          final row gives the number of parameters P, and the 
    //          number of coefficients
    // parSel - An array of integers mapping the coefficients to their 
    //          indices
    // Returns:
    // A P x N matrix, a linear combination of coefficents and covariates
    
    // Variable declarations
    int N; int V; int  C; int L;
    int P; int finish;
    matrix[ index[ dims(index)[1], 1 ], rows(X) ] pm;
    matrix[ index[ dims(index)[1], 1 ], cols(X) ] out;
    
    N <- cols(X);
    V <- rows(X);
    C <- dims( parSel )[1];
    L <- dims(index)[1];
    P <- index[ L, 1 ];
    finish <- L - 1 - C;
    
    // Fill parameter matrix with zeros
    pm <- rep_matrix( 0.0, P, V );
    
    for (i in 1:C ) {
      pm[ index[i,1], index[i,2] ] <- coef[ parSel[i] ];
    }
    
    if ( finish > 0 ) {
      for (i in 1:finish) {
        pm[ index[i+C,1], index[i+C,2] ] <- fixed[i];
      }
    }
    
    out <- pm*X;
    
    return( out );
  }
}data {
  int Ns; // Number of subjects
  int No[Ns]; // Number of observations by subject
  int No_max; // Largest number of observations
  int V; // Number of covariates
  int K; // Number of mappings
  int U; // Number of fixed values
  int C[3]; // Number of coefficients
  matrix[V,No_max] X[Ns]; // Array of design matrices
  vector[U] fixed; // Fixed values
  int index[ V + 1, 2 ]; // Indices for filling parameter matrix
  int parSel[K]; // Mapping of coefficients to parameter matrix
  vector[2] Y[Ns,No_max]; // Array of RT and choice by subject
  real<lower=0> min_RT[ Ns, C[3] ]; // Smallest response time for each relevant condition
  matrix[ sum(C), 4 ]Priors; // Matrix of parameters for prior distributions
}
parameters {
  // Subject level
  vector<lower=0.0>[ C[1] ] kappa[Ns]; // Subject thresholds
  vector<lower=0.0>[ C[2] ] xi[Ns]; // Subject drift rates
  vector<lower=0.0,upper=1.0>[ C[3] ] theta[Ns]; // Proportion for residual latency by subject
  // Group level
  real<lower=0.0> kappa_mu[ C[1] ]; // Means for thresholds
  real<lower=0.0> kappa_sig[ C[1] ]; // Standard deviations for thresholds
  real<lower=0.0> xi_mu[ C[2] ]; // Means for thresholds
  real<lower=0.0> xi_sig[ C[2] ]; // Standard deviations for thresholds
  real<lower=0.0> theta_alpha[ C[3] ]; // 1st parameter for beta distribution (Residual latency)
  real<lower=0.0> theta_beta[ C[3] ]; // 2nd parameter for beta distribution (Residual latency)
}
transformed parameters {
  // Variable declaration
  vector<lower=0.0>[ C[3] ] tau[Ns]; // Raw residual latency by subject
  
  // Weight fastest RT by proportion for residual latency
  for ( ns in 1:Ns ) {
    for ( c in 1:C[3] ) tau[ns,c] <- min_RT[ns,c]*theta[ns,c];
  }
}
model {
  // Variable declaration
  vector[ sum(C) ] coef;
  matrix[ 8, No_max ] param;
  int inc[3]; // For incrementing over indices
  vector[ sum(No) ] summands;
  
  // Priors
  inc[1] <- 1;
  for (i in 1:C[1]) {
    kappa_mu[i] ~ normal( Priors[inc[1],1], Priors[inc[1],2] );
    kappa_sig[i] ~ cauchy( Priors[inc[1],3], Priors[inc[1],4] );
  }
  inc[1] <- inc[1] + C[1];
  for (i in 1:C[2]) {
    xi_mu[i] ~ normal( Priors[inc[1],1], Priors[inc[1],2] );
    xi_sig[i] ~ cauchy( Priors[inc[1],3], Priors[inc[1],4] );
  }
  inc[1] <- inc[1] + C[2];
  for (i in 1:C[3]) {
    theta_alpha[i] ~ normal( Priors[inc[1],1], Priors[inc[1],2] );
    theta_beta[i] ~ normal( Priors[inc[1],3], Priors[inc[1],4] );
  }
  
  // Loop over subjects
  inc[3] <- 1;
  for ( ns in 1:Ns ) {
    
    // Hierarchy
    kappa[ns] ~ normal( kappa_mu, kappa_sig );
    xi[ns] ~ normal( xi_mu, xi_sig );
    theta[ns] ~ beta( theta_alpha, theta_beta );
    
    // Fill in vector of coefficients
    inc[1] <- 1; inc[2] <- C[1];
    coef[ inc[1]:inc[2] ] <- kappa[ ns, 1:C[1] ];
    inc[1] <- inc[1] + C[1]; inc[2] <- inc[2] + C[2];
    coef[ inc[1]:inc[2] ] <- xi[ ns, 1:C[2] ];
    inc[1] <- inc[1] + C[2]; inc[2] <- inc[2] + C[3];
    coef[ inc[1]:inc[2] ] <- tau[ ns, 1:C[3] ];
    
    // Generate parameter matrix
    param <- param_est( X[ns], coef, fixed, index, parSel );
    
    // Likelihood
    for ( no in 1:No[ns] ) {
      summands[ inc[3] ] <- waldrace_log( Y[ns,no], col(param,no) );
      inc[3] <- inc[3] + 1;
    }
  }
  
  // Call to the sampler
  increment_log_prob( sum(summands) );
}
 