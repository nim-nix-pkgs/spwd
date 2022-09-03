# Nim port of Python's "spwd" module.

# Written by Adam Chesak.
# Released under the MIT open source license.


import strutils
import times


type
    Spwd* = ref object
        sp_nam : string
        sp_pwd : string
        sp_lstchg : int
        sp_min : int
        sp_max : int
        sp_warn : int
        sp_inact : int
        sp_expire : int
        sp_flag : string

type
    Spwd2* = ref object
        sp_nam : string
        sp_pwd : string
        sp_lstchg : Time
        sp_min : TimeInterval
        sp_max : TimeInterval
        sp_warn : TimeInterval
        sp_inact : TimeInterval
        sp_expire : TimeInterval
        sp_flag : string
        


# Internal constant.
const SPWD_FILE = "/etc/shadow"


proc daysToSeconds(day : string): Time = 
    ## Internal proc. Converts the days from the format into a Time.
    
    var d : int = parseInt(day)
    d *= 24 * 60 * 60
    return fromSeconds(int64(d))


proc daysToInterval(day : string): TimeInterval = 
    ## Internal proc. Converts days from the format into a TimeInterval.
    
    return initInterval(days = parseInt(day))


proc getspall*(): seq[Spwd] = 
    ## Returns a sequence of all entries in the shadow file.
    
    var f : string = readFile(SPWD_FILE)
    var lines : seq[string] = f.splitLines()
    var spwds : seq[Spwd] = newSeq[Spwd](len(lines))
    
    for i in 0..high(lines):
        var s : seq[string] = lines[i].split(":")
        var p : Spwd = Spwd(sp_nam: s[0], sp_pwd: s[1], sp_lstchg: parseInt(s[2]), sp_min: parseInt(s[3]), sp_max: parseInt(s[4]),
                            sp_warn: parseInt(s[5]), sp_inact: parseInt(s[6]), sp_expire: parseInt(s[7]), sp_flag: s[8])
        spwds[i] = p
    
    return spwds


proc getspnam*(name : string): Spwd = 
    ## Returns the entry with the given ``name``. Returns ``nil`` if not found.
    
    var spwds : seq[Spwd] = getspall()
    
    for i in spwds:
        if i.sp_nam == name:
            return i
    
    return nil


proc getspall2*(): seq[Spwd2] = 
    ## The same as ``getspall()``, but uses the ``Swpd2`` object with ``Time`` and ``TimeInterval`` objects.
    
    var f : string = readFile(SPWD_FILE)
    var lines : seq[string] = f.splitLines()
    var spwds : seq[Spwd2] = newSeq[Spwd2](len(lines))
    
    for i in 0..high(lines):
        var s : seq[string] = lines[i].split(":")
        var p : Spwd2 = Spwd2(sp_nam: s[0], sp_pwd: s[1], sp_lstchg: daysToSeconds(s[2]), sp_min: daysToInterval(s[3]), sp_max: daysToInterval(s[4]),
                              sp_warn: daysToInterval(s[5]), sp_inact: daysToInterval(s[6]), sp_expire: daysToInterval(s[7]), sp_flag: s[8])
        spwds[i] = p
    
    return spwds


proc getspnam2*(name : string): Spwd2 = 
    ## The same as ``getspnam()``, but uses the ``Swpd2`` object with ``Time`` and ``TimeInterval`` objects.
    
    var spwds : seq[Spwd2] = getspall2()
    
    for i in spwds:
        if i.sp_nam == name:
            return i
    
    return nil
