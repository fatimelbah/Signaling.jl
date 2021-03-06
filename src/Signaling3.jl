module Signaling3
export errmktclear_regions, equil_regions, f_regions, indif_regions

#This file create the numerical simulations used to generate the right panel of figure 7
function indif_regions(pi::Any,cH::Any)
        
    global cL, lambda
    
    x = max(lambda - pi.*(1-lambda).* 1 ./ (cL./cH-1),0)
    
    return x
end  

function equil_regions(pi::Any,lambda::Any,B::Any,c_H::Any)

    theta = indif_regions_1(pi,c_H)
    
    y = errmktclear_regions_1(pi,theta,lambda,B)
    return y
end
    
    #######

    #This next function maximizes with respect to theta. this function will then 
#be integrated in the errmktclear-regions function to compute the integral.

function f_regions(theta::Any,lambda::Any,B::Any)
        
    global A

     z = max((A/lambda-B*lambda/2+B*theta).*(theta>=0).*(theta<=lambda),0)
        
        return z
end

 
    
#integral from theta star to lamda  
     

function errmktclear_regions(pi,theta,lambda,B)
    f(t)= 1 ./ ((lambda-theta)+pi*(1-lambda)) .* f_regions(theta,lambda,B)
        w = quadgk(f,theta,lambda)
        return w[1] -1
end
    
        #########
  ## Now let's create the code that will call upon all these functions
  # This document computes the regions of the parameter space where we have different types of equilibria
    
  global qH, qL, cL, lambda, A, e, e2

  # Parameters
  qH = 1.0
  qL = 0.4
  
  lambda=.55
  
  cL = .27
  
  
  e = 1e-10
  e2 = 1e-3
  
  # Parameters of F
  A = 1.2
  
  ## Grid
 NC = 55
 cH = LinRange(0.07,0.095,NC)

 NB = 280
 Bs = LinRange(.1,7,NB)

 ## Plot equilibrium conditions
#= 
M = 9
pis = LinRange(0.00001,.99999,M) # Linrange is equivalent to Linspace in Matlab which generates linearly spaced values. 
guesstheta = 0.5

wstar=zeros(NC)

    for k=1:NB
       k
        for j=1:NC

            estar = (qH - qL) ./ cL
            wstar[j] = qH .- cH[j] .* estar
            
            
            # Compute actual equilibrium
            t_ind_L = indif_regions_1(e2,cH[j])
            check_L = errmktclear_regions_1(e2,t_ind_L,lambda,Bs[k])
            t_ind_H = indif_regions_1(1-e2,cH[j])
            check_H = errmktclear_regions(1-e2,t_ind_H,lambda,Bs[k])
            
            c= quadgk(1 ./(1-t) .*f_regions(t,lambda,Bs[k]),e,lambda) ## give the vector with integral in first entry
            d= quadgk(1 ./(1-t).*f_regions(t,lambda,Bs[k]), tt, lambda)
            if check_L<0
                pistar[j,k] = 0
    #             disp("Corner - separating")
            elseif check_H>0
    #             disp("Corner - no signaling")
                pistar[j,k] = 1
                if c[1]-1 <0
                    thetastar[j,k] = 0
                else()
                    thetastar[j,k] = find_zero(tt-> d[1]-1,[e lambda-e]')
                end
            else()
    #             disp("Interior")
                pistar[j,k] = find_zero(pi-> equil_regions_1[pi,lambda,Bs[k],cH[j]],[e 1-e]')
                thetastar[j,k] = indif_regions_1[pistar[j,k],cH[j]]
            end
            
            # Check deviations
            if pistar>0
                thetasdev = range(thetastar[j,k]+e,lambda-e,length=M);        
                profit =  ((lambda - thetasdev)*qL + pistar[j,k]*(1-lambda)*qH) ./ (lambda - thetasdev + pistar[j,k]*(1-lambda))-wstar[j]
                    
                for l = 1:M
                    wD[l,j,k] = qL + (qH - qL) * (1-cH[j]./cL * quadgk[ 1 ./(pistar[j,k]*(1-lambda)+lambda-t).*f_regions[t,lambda,Bs[k]],thetastar[j,k],thetasdev[l]])
                    devprofit[l,j,k] = qH -wD[l,j,k];            
                end
                trueeq[j,k] = max(devprofit[:,j,k] -profit')<=0
            else()
                trueeq[j,k] = 1
            end
            
            
        end
    end
    =# 
## couldn't generate the plots 
end