MODULE DiscDateTest EXPORTS Main;  

IMPORT DiscDate, IO, Time;

VAR T : DiscDate.T;

BEGIN

T = DiscDateFromTime(Time.NOW(),Local);

END DiscDateTest.
