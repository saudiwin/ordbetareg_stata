This repository contains .ado files that can implement the ordbetareg model for bounded continuous variables (i.e. from 0 to 1 inclusive). 
Unlike standard beta regression, ordbetareg can handle values at the bounds, such as 0s and 1s.
For more information, see the paper by Robert Kubinec:

https://osf.io/preprints/socarxiv/2sx6y

This is an initial release of the .ado files. It is possible to fit the model and use predict/margins to obtain marginal effects in the scale of the 
outcome (i.e. between 0 and 1). Other fancier Stata features have not yet been implemented.
