# KPU-Simulating-Cops-And-Robbers-Using-A-Random-Walk
For an upper levels computer programming course called Simulations, myself and two other classmates designed a project that was intended to simulate buglaries using the mathematical concept of a random walk. The idea for this project was inspired by a TED talk I had really enjoyed watching of Dr. Hannah Fry, where are the 4:39 minute mark, she began talking about a research group at UCLA who modelled burglary hot spots. [![4:39](https://img.youtube.com/vi/LnQYJa9-aR0/default.jpg)](https://www.youtube.com/watch?v=LnQYJa9-aR0&t=278s)

This project challenged my partners and I to incorporate several algorithms central to the themes of our coursework. For example, we needed to create an environment that had an effect on the objects instantiated with in. Our grid system that the "Robbers" move within, is based off the [Cellular automaton](https://en.wikipedia.org/wiki/Cellular_automaton) idea, specificxally a Moore neighboorhood. Not only does our environment have an effect on the Robbers, the Robbers and the Police have an effect on the environment.

What concepts did I learn?
- I learned about the Cellular Automaton concept and
- I learned about finite state machines
- Used push and pop matrices in order to properly display and orient graphics
- Random Walk and Levy Flight

What skills did I learn?
- How to work with the same source code amongst multiple group mates.
- How to organize and write code in a way that others can read, understand, and change if necessary.

Concepts implemented from the Literature Review?
- The Broken Glass Effect in the case of burglaries would be that if a house is broken into, then that house and all houses in the same neibourhood have an increased chance of being broken into. In our simulation, succeful burglary attempts increased the probability of the Moore neighboorhood of cells.
- The Broken Glass Effect leads to burglar hotspots. Especially as the simulation is allowed to run for longer times, you begin to see red patches of burglaries near by eachother. 
- The idea of an "Experienced" burglar. An experience burglar will travel further away, for example they may use public transportation to open up more opportunity for them. This idea was cleverly implement using a variation on the Random Walk called the Levy Flight. 

Did the project achieve it's aim?
- Yes! The project was a success because my partners and I gained a lot of knowlege while finishing a working beta prodject that produced a succefull simulation. We tested the projects validity by collecting some baseline parameters for the number of successfull robberies for N, number of robbers, produced for varying quantities of N.
- More data was collected with equal numbers of police and the simulation showed a decrease in robberies from the baseline. This matched the hypothesis that if Police pay attention to nearby burglary hotspots, then they can decrease future robbies by increasing presense in the effect neighbourhoods.
