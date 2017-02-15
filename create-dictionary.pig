
register PigFunctions.jar;
define WETLoad edu.rosehulman.gibsonjc.LoadWET();
define GroupBag edu.rosehulman.gibsonjc.StringBagGroup();
define Vectorize edu.rosehulman.gibsonjc.VectorizeWords();

data = load '$inputPath' 
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
                     TOKENIZE(REPLACE(LOWER(content), '[^a-z ]', '')) as (words:{word_tuple:(word:chararray)});

min_len_words = foreach words_bag {
        longies = filter words by SIZE(word) > 3 and SIZE(word) < 20;
        generate id, uid, longies as (words:{word_tuple:(word:chararray)});
    };

word_counts = foreach min_len_words 
              generate id,
                       uid,
                       GroupBag(words) as (word_counts:{(word:chararray,count:int)});

word_counts = limit word_counts 1000;

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

sums = foreach grouped_words generate word as word, SUM(count) as count;
less_sums = filter sums by count > 10;

sorted_sums = order less_sums by count desc;
we_care_about = limit sorted_sums 1000;

store we_care_about into '$outputPath';



