{smcl}
{p2col:{bf: relogitplot} {hline 2} Generate predictive margins plots after rare events logit{p_end}}
{hline}

{marker syntax}{...}
{title:Syntax}

{cmd:relogitplot} {it:xvar}, range(#1 #d #2) [level() stat() noci {help twoway_options}]

{marker description}{...}
{title:Description}

{cmd:relogitplot} produces a predictive margins plot after a rare events logit {help relogit} for the specified variable at the specified range, setting other variables to a specified statistic

{marker options}{...}
{title:Options}

{opt range} is required. It specifies that the plot should be drawn for the predicted values of y from value #1 to value #2 of x, in steps of #d.

{opt level} specifies the desired confidence interval. Optional, default is 95.
{opt stat} specifies the statistic at which all other variables should be set. See {help setx} for options. Optional, default is mean.
{opt noci} suppresses confidence intervals. Optional.

{opt twoway_options} specifies other twoway options.

{marker examples}{...}
{title:Examples}

Setup
{cmd:clear}
{cmd:set obs 10000}
{cmd:gen y = cond(_n>300,0,1)}
{cmd:gen x = runiform()}
{cmd:relogit y x}

Example
{cmd:relogitplot x, range(0 0.05 1) scheme(s1mono) legend(off) xtitle(X) ytitle(Pr(Y)=1) title(Predictive margins with 95% CIs)}

{hline}

{marker author}{...}
{title:Author}

Ali Atia
Email: alitarekatia@gmail.com	

{hline}

{help relogit} is written by Michael Tomz, Gary King, Langche Zeng
