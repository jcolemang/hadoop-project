
register PigFunctions.jar;
define WETLoad edu.rosehulman.gibsonjc.LoadWET();

data = load 'CC-MAIN-20161202170900-00000-ip-10-31-129-80.ec2.internal.warc.wet' 
        using WETLoad() 
        as (id:chararray, uid:chararray, content:chararray);

all_uris = foreach data generate uid;

less_data = filter data by (id != 'NOT VALID');



some = limit less_data 10;
test = foreach some generate uid;
dump test;

