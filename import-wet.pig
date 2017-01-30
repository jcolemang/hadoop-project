
register PigFunctions.jar;
define WETLoad edu.rosehulman.gibsonjc.LoadWET();

data = load 'CC-MAIN-20161202170900-00000-ip-10-31-129-80.ec2.internal.warc.wet' 
        using WETLoad() 
        as (id:chararray, uid:chararray, content:chararray);

all_uris = foreach data generate uid;

less_data = filter data by (id != 'NOT VALID');

all_grouped = group data all;
counts = foreach all_grouped generate COUNT(data);
dump counts;


