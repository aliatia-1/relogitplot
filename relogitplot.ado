* relogitplot written by Ali Atia. 
* Requires relogit package by Michael Tomz, Gary King, and Langche Zeng.
* Version 1

program define relogitplot
	version 8.0
	quietly{
		syntax varlist(min=1 max=1), range(numlist min=3 max=3) [stat(string asis) level(integer 95) noci *]
		if "`e(cmd)'" != "relogit" {
			di as error "You must run relogit before relogitplot."
			exit 198
		}
		if strpos("`e(rhsvars)'", "`varlist'")==0 { 
			di as error "`varlist' was not an explanatory variable in the last estimated model."
			exit 198
		}
		if "`stat'" == ""{
			local stat mean
		}
		local low: word 1 of `range'
		local step: word 2 of `range'
		local high: word 3 of `range'
		local words: colnames r(table)
		local words = subinstr("`words'","`varlist'","",1)
		local words = subinstr("`words'","_cons","",1)
		if `:word count `e(rhsvars)'' == 1{
			local setx1
		}
		else{
			local setx1 (`words') `stat'
		}
		forval x= `low'(`step')`high'{
			local newx = strtoname(strofreal(`x'))
			setx `setx1' (`varlist') `x'
			relogitq, level(`level')
			local `varlist'`newx' `=r(Pr)'
			local `varlist'`newx'u `=r(PrU)'
			local `varlist'`newx'l `=r(PrL)'
			local howmany `howmany' ``varlist'`newx''
		}
		tempvar temp`varlist' probability cu cl
		local obs `=c(N)'
		if c(N)<`:word count `howmany''	set obs `:word count `howmany''
		gen double `temp`varlist'' = .
		forval x=`low'(`step')`high'{
			local list `list' `x'
		}
		forval x= 1/`:word count `howmany''{
			replace `temp`varlist'' = `:word `x' of `list'' in `x'
		}
		levelsof `temp`varlist'',local(list)
		gen `probability' = .
		gen `cu' = .
		gen `cl' = .
		forval x= 1/`:word count `howmany''{
			local newx = strtoname(strofreal(`:word `x' of `list''))
			replace `probability' = ``varlist'`newx'' if `temp`varlist''==`:word `x' of `list''
			replace `cu' = ``varlist'`newx'u' if `temp`varlist''==`:word `x' of `list''
			replace `cl' = ``varlist'`newx'l' if `temp`varlist''==`:word `x' of `list''
		}
		if "`ci'" == ""{
			twoway connected `probability' `temp`varlist'' || rcap `cu' `cl' `temp`varlist'' ||,`options'
		}
		else{
			twoway connected `probability' `temp`varlist'' ||,`options'
		}
		set obs `obs'
	}
end
