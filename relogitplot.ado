* relogitplot written by Ali Atia. 
* Requires relogit package by Michael Tomz, Gary King, and Langche Zeng.
* Version 1
program define relogitplot
	version 8.0
	quietly{
		syntax varlist, range(numlist) [stat(string asis) level(numlist) noci *]

		if "`e(cmd)'" != "relogit" {
			di as error "You must run relogit before relogitplot."
			exit 198
		}
		if strpos("`e(rhsvars)'", "`varlist'")==0 { 
			di as error "`varlist' was not an explanatory variable in the last estimated model."
			exit 198
		}
		if `:word count `varlist''>1{
			di as error "Too many variables specified."
			exit
		}
		if "`level'" == ""{
			local level 95
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
		mac li


		forval x= `=`low''(`=`step'')`=`high''{
			local newx = strtoname(strofreal(`x'))
			setx `setx1' (`varlist') `x'
			relogitq, level(`level')
			local `varlist'`newx' `=r(Pr)'
			local `varlist'`newx'u `=r(PrU)'
			local `varlist'`newx'l `=r(PrL)'
			local howmany `howmany' ``varlist'`newx''
		}
		preserve
		clear 
		set obs `:word count `howmany''
		gen double n = .
		forval x=`=`low''(`=`step'')`=`high''{
			local list `list' `x'
		}
		forval x= 1/`=_N'{
			replace n = `:word `x' of `list'' in `x'
		}
		levelsof n,local(list)
		gen c = .
		gen cu = .
		gen cl = .
		forval x= 1/`=_N'{
			local newx = strtoname(strofreal(`:word `x' of `list''))
			replace c = ``varlist'`newx'' if n==`:word `x' of `list''
			replace cu = ``varlist'`newx'u' if n==`:word `x' of `list''
			replace cl = ``varlist'`newx'l' if n==`:word `x' of `list''
		}
		if "`ci'" == ""{
			twoway connected c n || rcap cu cl n ||,`options'
		}
		else{
			twoway connected c n ||,`options'
		}
	}
end
