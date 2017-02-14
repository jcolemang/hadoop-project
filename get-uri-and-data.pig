
register PigFunctions.jar;
define WETLoad edu.rosehulman.gibsonjc.LoadWET();
define GroupBag edu.rosehulman.gibsonjc.StringBagGroup();
define Vectorize edu.rosehulman.gibsonjc.VectorizeWords();

data = load 'CC-MAIN-20161202170900-00000-ip-10-31-129-80.ec2.internal.warc.wet' 
        using WETLoad() 
        as (id:chararray, 
            uid:chararray, 
            content:chararray);

less_data = filter data 
            by (id != 'NOT VALID');

uri_and_data = foreach less_data generate uid, content;

some = limit uri_and_data 10;

dump some;




