############ PLEASE RUN THE FOLLOWING CODE ################
library("ape")
library("stats4")

LL.BD = function(tt, lambda, mu, rho){
  t1 = 1
  A = exp((mu-lambda)*tt)
  A1 = exp((mu-lambda)*t1)
  Prob.t = (rho*(lambda-mu))/(rho*lambda + (lambda*(1-rho) - mu) * A)
  Prob.t1 = (rho*(lambda-mu))/(rho*lambda + (lambda*(1-rho) - mu) * A1)
  vt1 = 1 - 1/rho*Prob.t1*A1
  p1 = (1/rho)*Prob.t^2*A
  gt = lambda*p1/vt1
  -sum(log(gt))
}


BD.density = function(t, birth.rate, death.rate, rho, root.age=1){
  A = exp((death.rate - birth.rate)*t)
  A1 = exp((death.rate - birth.rate)*root.age)
  Prob.t = (rho*(birth.rate - death.rate))/(rho*birth.rate + (birth.rate*(1-rho) - death.rate) * A)
  Prob.t1 = (rho*(birth.rate - death.rate))/(rho*birth.rate + (birth.rate*(1-rho) - death.rate) * A1)
  vt1 = 1 - 1/rho * Prob.t1*A1
  p1 = 1/rho * Prob.t^2 * A
  gt = birth.rate*p1 / vt1
  
  return(gt)
}


ddBD = function(tr, outgroup, root.time = 1){
  b.rate.try = seq(1,10,1)+0.1
  d.rate.try = seq(1,10,1)
  s.fr.try = c(0.001,0.01,0.1,0.5,0.9)
  paras.try = expand.grid(b.rate.try, d.rate.try, s.fr.try)
  paras.try = paras.try[-which(paras.try$Var1<paras.try$Var2), ] # force birth rate >= death rate
  
  tr = ape::drop.tip(tr, outgroup)
  t = ape::branching.times(tr)/max(ape::branching.times(tr))
  t[t<0] = 0
  t.den = density(t)
  t.den.x= t.den$x
  t.den.y = t.den$y
  t.den.x.2 = t.den.x[t.den.x>=0 & t.den.x<=1]
  t.den.y.2 = t.den.y[t.den.x>=0 & t.den.x<=1]
  
  err = numeric()
  
  for (i in 1:nrow(paras.try)){
    bd.density = BD.density(t = t.den.x.2, birth.rate = paras.try[i,1], death.rate = paras.try[i,2], rho = paras.try[i,3], root.age = 1)
    
    err = c(err, sqrt(sum((t.den.y.2-bd.density)^2)))
  }
  
  err.sort = sort(err)
  attempt = 0
  inf.paras = NULL
  
  while (is.null(inf.paras) && attempt <= 10){
    attempt = attempt + 1
    paras.start = paras.try[match(err.sort[attempt], err), ]
    names(paras.start) = c("lambda", "mu", "rho")
    
    inf.paras = tryCatch(stats4::mle(LL.BD, start = list(lambda = as.numeric(paras.start[1]), mu = as.numeric(paras.start[2]), rho = as.numeric(paras.start[3])),
                            fixed = list(tt = t), method = "L-BFGS-B", lower = c(0, 0, 0), upper = c(Inf, Inf, 1)), error=function(e){})
  }
  
  if (attempt >= 10){
    return("Sorry, the best parameter setting cannot be found.")
  }else{
    output = c(inf.paras@coef[1:2]/root.time, inf.paras@coef[3])
    return(output)
  }
  
}

