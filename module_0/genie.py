{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 13,
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "The average number per 5 attempts.\n"
     ]
    },
    {
     "data": {
      "text/plain": [
       "5"
      ]
     },
     "execution_count": 13,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "import numpy as np\n",
    "\n",
    "\n",
    "def score(game_score):\n",
    "    '''Start the game 1000 times to find out how quickly the game guess\n",
    "    the number'''\n",
    "    count_ls = []\n",
    "    np.random.seed(1)  # RANDOM SEED: the experiment could be reproducible\n",
    "    random_array = np.random.randint(1, 101, size=(1000))\n",
    "    for number in random_array:\n",
    "        count_ls.append(core(number))\n",
    "    score = int(np.mean(count_ls))\n",
    "    print(f\"The average number per {score} attempts.\")\n",
    "    return(score)\n",
    "\n",
    "\n",
    "def core(number):\n",
    "    lower = 1\n",
    "    upper = 101\n",
    "    count = 1\n",
    "    predict = (lower + upper) // 2\n",
    "\n",
    "    while number != predict:\n",
    "        count += 1\n",
    "        if number < predict:\n",
    "            upper = predict\n",
    "        else:\n",
    "            lower = predict\n",
    "        predict = (lower + upper) // 2\n",
    "    return count\n",
    "\n",
    "score(core)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.8.5"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}
