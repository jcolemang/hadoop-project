
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

-- filtering the data into something more manageable and useful
min_len_words = foreach words_bag {
        longies = filter words by SIZE(word) > 3 and SIZE(word) < 20;
        generate id, uid, longies as (words:{word_tuple:(word:chararray)});
    };

word_counts = foreach min_len_words 
              generate id,
                       uid,
                       GroupBag(words) as (word_counts:{(word:chararray,count:int)});

word_counts = limit word_counts 1000;

final = foreach word_counts generate uid, FLATTEN(BagToTuple(word_counts));

store final into '$outputPath';



