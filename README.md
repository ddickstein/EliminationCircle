##The Problem##

EliminationCircle was inspired by a friend of mine who asked me if I could write a computer program for him to set up a game of Killer.  He explained to me that he was organizing a youth group event with hundreds of kids, and that making sure that the game was set up correctly could take hours of his time.  In games that use elimination circles, every player is assigned a random target but all of the targets must be arranged in a large single circle, so that the game is over when the final player receives himself as a target.  My friend said that on previous occasions he had spent up to ten hours ensuring that a perfect circle was formed, because if he made any mistake in the randomization he might have ended up with multiple small circles, each of which would generate an independent winner.

Though I had played several games with elimination circles before, I had only ever arranged such games for groups of a relatively small size, and hadn't considered just how much time it might take to set up games of greater magnitude.  I wrote a simple command line application to help my friend, but then realized that this problem was universal enough that it merited a publicly available application that could assist many more game organizers like him.  This application can expedite the set up process and let the games commence within minutes.

##Primary Features##

EliminationCircle's primary function is to provide an administrative backend for anyone organizing an elimination circle game.  It allows for a detailed set up of the game, and then provides an admin panel listing all of the players from which administrators can see who is targeting who and can mark players as killed which will cause the panel to update.

A second major feature EliminationCircle provides is a running scoreboard that players can access at any point that will inform them who is still alive and how many kills each player has accumulated.

##Additional Features##

EliminationCircle offers a variety of custom features for setting up different kinds of games.  First, it allows extra fields to be added for each player in order to specify the elimination parameters.  For example, the game Killer requires that each player have a taboo word, so when setting up the game this extra field can be added to the players and every player can be given a taboo word.  Then a “Word” column will be generated in the admin panel from which the administrator can see each player’s word.  Game admins can decide how many additional parameters to add to their games.

In addition to deciding which elimination parameters to add, Game admins can also decide how to randomly assign them.  They can assign specific parameters to specific people, randomly assign each parameter individually, or randomly assign each set of parameters as a cluster.  These options add flexibility to the game creation so that each game can be incredibly unique and can inspire people to create their own elimination circle games.


##Contact##

Email daniel.dickstein@yale.edu with any questions, comments, or feature requests.