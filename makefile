default: all.txt clone.txt

all.txt:
	ssh -t khcheung@bolo.berkeley.edu \
	'find /pbrepo \! -path "*/*.bak/*" \( -maxdepth 2 -mindepth 2 -type f -name HEAD \) -o \( -type d -name ".git" \)' \
	| awk -F'/' '{print $$(NF - 1)}' \
	| sort > $@

clone.txt: all.txt
	sed 's/^/git clone --bare khcheung@bolowiki\.berkeley\.edu:\/pbrepo\//g' $^ > $@

mirror:
	< all.txt xargs -i -n1 -P0 bash -c './bolo2github.sh -n $0' {}
