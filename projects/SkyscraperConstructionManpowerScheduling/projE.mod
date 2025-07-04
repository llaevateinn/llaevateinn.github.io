# Project E - XUEYAN ZHANG


set MONTH ordered;								#months

param N{MONTH};									#number of workers needed
param cost_a;									#cost for one person to arrive on first of each month
param cost_d;									#cost for one person to depart at the end of each month
param cost_o;									#cost over/understaffing for one person per month
param max_arrival;								#maximum number of arrivals
param max_overtime;								#maximum work of overtime
param aug_end;									#number of workers at the end of August

var x{m in MONTH} >=0 integer;					#arrivals at the first of month m
var y{m in MONTH} >=0 integer;					#departures at the end of month m
var w{m in MONTH} >=0 integer;					#workers employed in month m
var ABS{m in MONTH} >=0 integer;				#variable to replace absolute value

minimize tot_cost: sum{m in MONTH: m != 'Feb'} 
	 (cost_a * x[m]								#cost due to arrivals of workers
	+ cost_d * y[m]								#cost due to departures of workers
	+ cost_o * ABS[m]);							#cost due to over/understaffing
	
s.t. workers{m in MONTH: m != 'Aug'}:			#number of workers in each month
	w[next(m,MONTH)] - x[next(m,MONTH)] = w[m] - y[m];
s.t. worekrs_Aug:
	w['Aug'] - y['Aug'] = aug_end;
s.t. MAX_overtime{m in MONTH: m != 'Feb'}:		#overtime per month is limited
	(1 + max_overtime) * w[m] >= N[m];
s.t. MAX_arrival{m in MONTH: m != 'Feb'}:		#number of arrivals per month is limited
	x[m] <= max_arrival;
s.t. MAX_departure{m in MONTH: m != 'Feb'}:		#departure is limited to one third of total employment
	y[m] <= w[m] / 3;	
s.t. abs_value_1{m in MONTH: m != 'Feb'}:		#eliminating the absolute value
	ABS[m] >= w[m]-N[m];
s.t. abs_value_2{m in MONTH: m != 'Feb'}:
	ABS[m] >= N[m]-w[m];