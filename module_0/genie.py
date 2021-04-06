import numpy as np


def score(game_score):
    '''Start the game 1000 times to find out how quickly game guess
    the number'''
    count_ls = []
    np.random.seed(1)  # RANDOM SEED: the experiment could be reproducible
    random_array = np.random.randint(1, 101, size=(1000))
    for number in random_array:
        count_ls.append(binary(number))
    score = int(np.mean(count_ls))
    print(f"The average number per {score} attempts.")
    return(score)


def binary(number):
    '''As a predict we take always the middle of the interval.
    In depend of the comparison the (lower) limit  or the (upper) limit.'''
    lower = 1
    upper = 101
    count = 1
    predict = (lower + upper) // 2

    while number != predict:
        count += 1
        if number < predict:
            upper = predict
        else:
            lower = predict
        predict = (lower + upper) // 2
    return count

score(binary)
