UNSAFE MODULE DiscDate;

IMPORT Thread, Time, M3toC, Utime, TimePosix;

TYPE 

  days = {Sweetmorn, Boomtime, Pungenday, PricklePrickle, SettingOrange};
  seasons = {Chaos, Discord, Confusion, Bureaucracy, TheAftermath};
  
  disc_time = RECORD
    season: seasons;
    day:  [-1..73];
    yday: [0..365]; 
    year: [3066..LAST(INTEGER)];
  END;
  
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
  
(* TYPE TimeZone <: REFANY; *)

CONST 
  dayNames = ARRAY days OF TEXT{"Sweetmorn", 
                              "Boomtime", 
                              "Pungenday", 
                              "Prickle-Prickle", 
                              "Setting Orange"};

  seasonNames = ARRAY seasons OF TEXT{"Chaos", 
                                    "Discord", 
                                    "Confusion", 
                                    "Bureaucracy", 
                                    "The Aftermath"};

  firstHolidayNames = ARRAY seasons OF TEXT{"Mungday", 
                                          "Mojoday", 
                                          "Syaday",  
                                          "Zaraday",  
                                          "Maladay"};

  secondHolidayNames = ARRAY seasons OF TEXT{ "Chaoflux", 
                                            "Discoflux",  
                                            "Confuflux",  
                                            "Bureflux",  
                                            "Afflux"};

VAR
  mu := NEW(Thread.Mutex);

REVEAL TimeZone = BRANDED "Date.TimeZone" REF INTEGER;
       
PROCEDURE FromTime(t: Time.T; z: TimeZone := NIL): T =
  
  (*    Return the date corresponding to t, as observed in the time zone  *)
  (*    z. If z is NIL, Local is used.                                    *)
  
  VAR
    discdate : T;
    tv   : Utime.struct_timeval;
    tm   : Utime.struct_tm_star;
    
  BEGIN
    tv := TimePosix.ToUtime(t);
    LOCK mu DO
      IF (z = NIL) OR (z^ = Local^) THEN
        tm := Utime.localtime(ADR(tv.tv_sec));
      ELSIF z^ = UTC^ THEN
        tm := Utime.gmtime(ADR(tv.tv_sec));
      ELSE
        (* unknown timezone *)
        <* ASSERT FALSE *>
      END;
      date.year    := tm.tm_year + 1900 + 3066;
      date.yday     := tm.tm_yday;
      date.hour    := tm.tm_hour;
      date.minute  := tm.tm_min;
      date.second  := tm.tm_sec;
      date.season := Chaos;
      date.day := date.yday;
      
      (* The "tm.tm_gmtoff" field is seconds *east* of GMT, whereas
         the "date.offset" field is seconds *west* of GMT, so a
         negation is necessary. *)
      date.offset  := - (tm.tm_gmtoff);
      date.zone    := M3toC.CopyStoT (tm.tm_zone);
      
      (* catch years with 366 days *)
      IF (date.year MOD 4 ) = 2 THEN
        IF date.yday >= 59 THEN
          DEC(date.yday);
        END;
      END;
      
      (* make date.day the N-th day of date.season *)
      WHILE date.day > 73 DO
        INC(date.season);
        date.day := date.day - 73;
      END;
      
      date.weekDay := VAL(date.yday MOD 5, days);
      
      (* catch holidays *)
      IF (date.yday MOD 73) = 5 THEN
        date.holiday := firstHolidayNames[this.season];
      ELSIF (date.yday MOD 73) = 50 THEN
        date.holiday := secondHolidayNames[this.season];
      ELSE
        date.holiday := "";
      END;
    END;
    RETURN date;
  END FromTime;
  
BEGIN
END DiscDate.
