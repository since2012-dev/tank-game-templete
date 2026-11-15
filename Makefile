# Constants
PROJECT = Build

# Commands
run:
	love .

mango:
	mangohud love .

love:
	zip -9 -r $(PROJECT).love . -x "*.git*" -x "$(GAME).love"

clean:
	rm -f $(PROJECT).love
