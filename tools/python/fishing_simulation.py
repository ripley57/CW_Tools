# Description:
#	Fishing simulation from Chapter 4 (Listing 4.17) of Mastering Large Datasets.
#
# 	This program is a good demonstration of map() with methodcaller(), lambda, and classes.
#
# To run:
#	python3 fishing_simulation.py

import random, itertools
from operator import methodcaller

class Village:
    def __init__(self):
        self.population = random.uniform(1000,5000)
        self.cheat_rate = random.uniform(.05,.15)

    def update(self, sim):
        if sim.cheaters >= 2:
            self.cheat_rate += .05
        self.population = int(self.population * 1.025)	;# Population will increase each year.

    def go_fishing(self):
        if random.uniform(0,1) < self.cheat_rate:
            cheat = 1
            fish_taken = self.population * 2	;# A cheating village takes twice as much fish as the population.
        else:
            cheat = 0
            fish_taken = self.population * 1
        return fish_taken, cheat

class Lake_Simulation:
    def __init__(self):
        self.villages = [Village() for _ in range(4)]
        self.fish = 80000
        self.year = 1
        self.cheaters = 0

    def simulate(self):
        # Infinite loop.
        for _ in itertools.count():
            yearly_results = map(methodcaller("go_fishing"), self.villages)
            fishes, cheats = zip(*yearly_results)	;# Combine all the results.
            total_fished = sum(fishes)
            self.cheaters = sum(cheats)
            if self.year > 1000:
                print("Wow! Your villages lasted 1000 years!")
                break
            if self.fish < total_fished:
                print("The lake was overfished in {} years.".format(self.year))
                break
            else:
                self.fish -= total_fished	;# Deduct the number fished this year.
                self.fish = self.fish * 1.15	;# The fish population will grow each year.
                map(lambda x:x.update(self), self.villages)	;# Call update() in each Village.
                # Print the fished count for this year.
                print("Year {:<5}	Fish: {}".format(self.year, int(self.fish)))
                self.year += 1

if __name__ == "__main__":
    random.seed("Map & Reduce")
    Lake = Lake_Simulation()
    Lake.simulate()
    Lake.simulate()
    Lake.simulate()
