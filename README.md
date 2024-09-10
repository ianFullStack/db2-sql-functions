# db2-sql-functions
 Collection of DB2 SQL functions
 running in runscript with no library specified in my enviornment places the function in qgpl.

 RmvDashAP.sql : can run a script or sql statment in a program that calls function RmvDashAp and give it a String. It will reduce the string to 15 characters by removing dashes and slashes, without removing the numbers, and if it cannot remove enough to bring the count to 15, will return an error. Example of calling the function is. RmvDashAP('15\63A1-A158575515') or RmvDashAP(CharVarible). values(RmvDashAP('15\63A1-A158575515')) will have a result of '15631A158575515'. 
