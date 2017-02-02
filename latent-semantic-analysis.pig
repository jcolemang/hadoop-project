
register PigFunctions.jar;
define WETLoad edu.rosehulman.gibsonjc.LoadWET();
define GroupBag edu.rosehulman.gibsonjc.StringBagGroup();

data = load 'CC-MAIN-20161202170900-00000-ip-10-31-129-80.ec2.internal.warc.wet' 
        using WETLoad() 
        as (id:chararray, 
            uid:chararray, 
            content:chararray);

less_data = filter data 
            by (id != 'NOT VALID');

-- TODO fix this to use stripped, lowercase words
words_bag = foreach less_data 
            generate id,
                     uid,
                     TOKENIZE(content) as (words:{word_tuple:(word:chararray)});

word_counts = foreach words_bag 
              generate id,
                       uid,
                       GroupBag(words) as (word_counts:{(word:chararray,count:int)});

-- TODO filter out words under a specific length, words consisting of
-- just numbers and/or symbols
flattened = foreach word_counts generate id, uid, FLATTEN(word_counts);
just_words_and_counts = foreach flattened generate word_counts::word as word, 
                                                   word_counts::count as count;

grouped_words_temp = group just_words_and_counts by word;

grouped_words = foreach grouped_words_temp { 
        inner_data = foreach just_words_and_counts 
                             generate count; 
        generate group as word, inner_data as count; 
    };

sums = foreach grouped_words generate word, SUM(count);
store sums into 'out';

