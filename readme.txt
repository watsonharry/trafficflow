Contained inside this main ZIP are several folders. Each one contains a different collection of MATLAB scripts,
each used for a different part of the investigation. Every script inside of a folder is necessary to run that part
of the investigation.

PRELIM OPEN-ENDED
This contains everything needed to run an open-ended version of the preliminary model, as seen in figure 1 of
the report. To run the model, run the traffic.m script file. All relevant variables are available to change in a
section of the code marked DEFINE INITIAL VARIABLES. By default they are set to the values used for initial testing i.e.
which created figure 1.

PRELIM MEASUREMENT
This contains everything needed to collect flow vs. density data from the preliminary model, as seen in figures 2 through
6. To run, exectute the trafficFlowVersusDensity.m script file. As above, relevant variables are stored in DEFINE INITIAL
VARIABLES. Also as above, they're set to the values used to create figure 2.

EXTENDED OPEN-ENDED
This contains everything needed to run an open-ended version of the extended model, as seen in figure 9. To use it, run
the trafficAdv.m script file. System parameters are found in the same place and are set to create the demo seen in fig.
9.

EXTENDED MEASURMENT
This contains everything needed to collect flow vs. number of cars data from the extended model, as seen in figure 10,
11 and 12. To use, run the flowComparisonAdv.m script file. System parameters found in same place, set to produce fig. 11.