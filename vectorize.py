

# assuming that these are passed in
words_and_counts = sorted([('hello', 1), ('my', 2), ('name', 1), ('is', 3), ('coleman', 1)], key=lambda t: t[0])
only_words = list(map(lambda t: t[0], words_and_counts))


# takes the dictionary, the word counts, and a vector 
# which is built up in the function calls
def create_vector(content, dictionary, vect):

    # base case
    if len(dictionary) == 0:
        return vect

    # need to fill in zeros
    if len(content) == 0:
        return vect + list(map(lambda t: (t[0], 0), dictionary))

    # get the first two tuples and check equality
    curr = content[0]
    curr_dict = dictionary[0]
    if curr[0] == curr_dict[0]:
        return create_vector(content[1:], dictionary[1:], [curr] + vect)

    # not equal. fill in a zero and continue on
    return create_vector(content, dictionary[1:], [(curr_dict[0], 0)] + vect)



def vectorize(uid, word_counts):

    # needed for the create vector function to work
    word_counts.sort(key=lambda a: a[0])

    # get rid of anything not in the dictionary
    only_dicts = filter(lambda word_tup: \
                            word_tup[0] in only_words, 
                        word_counts)

    # create and return the vector
    vect = create_vector(list(only_dicts), words_and_counts, [])
    return sorted(vect, key=lambda t: t[0])

if __name__ == "__main__":
    print(vectorize("test", [('hello', 10), ('james', 5), ('gibson', 3), ('my', 5)]))
