MIRRORDIR=/mnt/raid24/scratch/temp

default: all.txt clone.txt

all.txt:
	ssh -t khcheung@bolo.berkeley.edu \
	'find /pbrepo \! -path "*/*.bak/*" \( -maxdepth 2 -mindepth 2 -type f -name HEAD \) -o \( -type d -name ".git" \)' \
	| awk -F'/' '{print $$(NF - 1)}' \
	| sort > $@

# a list of command to clone bare from bolowiki
clone.txt: all.txt
	sed 's/^/git clone --bare khcheung@bolowiki\.berkeley\.edu:\/pbrepo\//g' $^ > $@

mirror-github:
	< all.txt xargs -n1 -P0 ./bolo2github.sh -n

mirror-bitbucket:
	< bitbucket.txt xargs -n1 -P0 ./bitbucket2github.sh -d "$(MIRRORDIR)" -n

clean:
	rm -rf "$(MIRRORDIR)"
