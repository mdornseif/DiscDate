INTERFACE DiscDate;

IMPORT Time;

TYPE
  T = RECORD
    year:    [3066..LAST(INTEGER)];
    season:  seasons;
    yday:    [-1..365];
    day:     [-1..73];
    hour:    [0 .. 23];
    minute:  [0 .. 59];
    second:  [0 .. 59];
    offset:  INTEGER;
    zone:    TEXT;
    weekDay: days;
    holiday: TEXT;
  END;
  
  TimeZone <: REFANY; 
  
  days = {Sweetmorn, Boomtime, Pungenday, PricklePrickle, SettingOrange, StTibsDay}; 
  seasons = {Chaos, Discord, Confusion, Bureaucracy, TheAftermath, StTibsDay};
     
CONST 
  dayNames = ARRAY days OF TEXT{"Sweetmorn", 
                              "Boomtime", 
                              "Pungenday", 
                              "Prickle-Prickle", 
                              "Setting Orange",
                              "St. Tibs Day"};

  seasonNames = ARRAY seasons OF TEXT{"Chaos", 
                                    "Discord", 
                                    "Confusion", 
                                    "Bureaucracy", 
                                    "The Aftermath",
                                    "St. Tibbs Day"};

  firstHolidayNames = ARRAY seasons OF TEXT{"Mungday", 
                                          "Mojoday", 
                                          "Syaday",  
                                          "Zaraday",  
                                          "Maladay",
                                          "this shouldn't happen (firstHolidayNames)"};

  secondHolidayNames = ARRAY seasons OF TEXT{ "Chaoflux", 
                                            "Discoflux",  
                                            "Confuflux",  
                                            "Bureflux",  
                                            "Afflux",
                                            "this shouldn't happen (secondHolidayNames)"};
                                           

VAR Local, UTC: TimeZone;

REVEAL TimeZone = BRANDED "Date.TimeZone" REF INTEGER;

PROCEDURE FromTime(t: Time.T; z: TimeZone := NIL): T;

(*    Return the date corresponding to t, as observed in the time zone  *)
(*    z. If z is NIL, Local is used.                                    *)

EXCEPTION Error;

END DiscDate.
